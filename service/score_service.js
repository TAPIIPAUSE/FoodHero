import UnitType from "../schema/inventory_module/unitTypeSchema.js";
import User from "../schema/user_module/userSchema.js";
import Food from "../schema/inventory_module/foodInventorySchema.js";

export async function calculateScore(totalAmount, consumedPercen, weightType) {
    try {
        var consumedAmount = (consumedPercen/100) * totalAmount
        var {totalAmount:convertedTotalAmount, consumedAmount:convertedCurrentAmount} = await unitConverter(weightType,totalAmount,consumedAmount)
        // Calculate the score
        let score;
        if (convertedTotalAmount > 1000) {
            if (consumedPercen >= 90) {
                score = consumedPercen / 100 * 5;
            } else if (consumedPercen >= 70) {
                score = consumedPercen / 100 * 3;
            } else {
                score = consumedPercen / 100 * -5;
            }
        } else {
            if (consumedPercen > 80) {
                score = consumedPercen / 100 * 2;
            } else {
                score = consumedPercen / 100 * -2;
            }
        }

        if (Object.is(score, -0) || Math.abs(score) < Number.EPSILON) {
            score = 0;
        }

        return score;
    } catch (error) {
        console.error('Error calculating score:', error);
        throw error
        return 0; // Default score in case of error
    }
}

export async function update_scoretoDB(userID, score) {
    try {
        // Find the user by userID
        const user = await User.findOne({ assigned_ID: userID });
        if (!user) {
            throw new Error('User not found');
        }

        // Update the user's score
        user.score = score;
        await user.save();

        return score;
    } catch (error) {
        console.error('Error updating score:', error);
        return 0; // Default score in case of error
    }

}

export async function getAmountInGrams(food) {

        // Prepare the variable
        var totalAmount, currentAmount = await unitConverter(food.type, food.total_amount, food.current_amount)

    return totalAmount, currentAmount
}

// This function would 1)Preprocess variety of units into single Grams unit. 2)Return total amount and current amount, ready for calculating the score
export async function unitConverter(type,totalAmount,consumedAmount) {
    const unitType = await UnitType.findOne({ assigned_ID: type });
    if (!unitType) {
        throw new Error('Unit type not found');
    }


    // Convert the food weight to grams
    
    switch (unitType.type) {
        case "Litre":
            totalAmount *= 1000;
            consumedAmount *= 1000;
            break;
        case "Ml":
            // No conversion here, we assume Ml is equivalent to gram
            break;
        case "Kg":
            totalAmount *= 1000;
            consumedAmount *= 1000;
            break;
        case "Grams":
            // No conversion needed
            break;
        default:
            throw new Error('Unknown unit type');
    }


    return {totalAmount,consumedAmount}
}