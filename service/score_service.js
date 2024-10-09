import UnitType from "../schema/inventory_module/unitTypeSchema.js";
import User from "../schema/user_module/userSchema.js";

export async function calculateScore(totalAmount, currentAmount, weightType) {
    try {

        var {totalAmount:convertedTotalAmount,currentAmount:convertedCurrentAmount} = await unitConverter(weightType,totalAmount,currentAmount)
        console.log("Total Amount:",convertedTotalAmount)
        console.log("Current Amount:", convertedCurrentAmount)
        // Calculate the consumed amount in grams
        const consumedPercen = (convertedCurrentAmount * 100) / convertedTotalAmount;

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
export async function unitConverter(type,totalAmount,currentAmount) {
    const unitType = await UnitType.findOne({ assigned_ID: type });
    if (!unitType) {
        throw new Error('Unit type not found');
    }

    console.log("This is in unitConverter, the unit is ", unitType.type)
    console.log("This is in unitConverter, total amount", totalAmount)
    console.log("This is in unitConverter, current amount", currentAmount)

    // Convert the food weight to grams
    
    switch (unitType.type) {
        case "Litre":
            totalAmount *= 1000;
            currentAmount *= 1000;
            break;
        case "Ml":
            // No conversion here, we assume Ml is equivalent to gram
            break;
        case "Kg":
            totalAmount *= 1000;
            currentAmount *= 1000;
            break;
        case "Grams":
            // No conversion needed
            break;
        default:
            throw new Error('Unknown unit type');
    }
    console.log("After Conversion")
    console.log("This is in unitConverter, total amount", totalAmount)
    console.log("This is in unitConverter, current amount", currentAmount)


    return {totalAmount,currentAmount}
}