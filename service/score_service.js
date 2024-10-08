import UnitType from "../schema/inventory_module/unitTypeSchema.js";
import User from "../schema/user_module/userSchema.js";

export async function calculateScore(totalAmount,currentAmount,weightType) {
    try {
      const unitType = await UnitType.findOne({ assigned_ID: weightType });
      if (!unitType) {
        throw new Error('Unit type not found');
      }
  
      // Convert the food weight to grams
      let grams = totalAmount;
      switch (unitType.type) {
        case "Litre":
          grams *= 1000;
          break;
        case "Ml":
          grams /= 1000;
          break;
        case "Kg":
          grams *= 1000;
          break;
        case "Grams":
          // No conversion needed
          break;
        default:
          throw new Error('Unknown unit type');
      }
  
      // Calculate the consumed amount in grams
      const consumedPercen = (currentAmount*100)/totalAmount;
  
      // Calculate the score
      let score;
      if (grams > 1000) {
        if (consumedPercen >= 90) {
          score = consumedPercen/100 * 5;
        } else if (consumedPercen >= 70) {
          score = consumedPercen/100 * 3;
        } else {
          score = consumedPercen/100 * -5;
        }
      } else {
        if (consumedPercen > 80) {
          score = consumedPercen/100 * 2;
        } else {
          score = consumedPercen/100 * -2;
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