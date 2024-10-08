import ConsumedFood from "../schema/inventory_module/consumedFoodSchema.js";
import { mapPackageType,mapUnitType } from "./consume_service.js";
import Food from "../schema/inventory_module/foodInventorySchema.js";
import PackageUnitType from "../schema/inventory_module/packageTypeSchema.js";
import UnitType from "../schema/inventory_module/unitTypeSchema.js";

export async function save_consume_to_db(fID,user,retrievedAmount, retrievedQuantity) {
    try {
      // Check if the house already exists in the database
      var newID = 0;

      const newConsumed = new ConsumedFood({
        food_ID: fID,
        user_ID: user.assigned_ID,
        h_ID: user.hID,
        current_amount: retrievedAmount,  // retrievedAmount mapped to current_amount
        current_quantity: retrievedQuantity,  // retrievedQuantity mapped to current_quantity
        saved: 0,  // default or initial value
        lost: 0,   // default or initial value
        consumed: 0,  // default or initial value
        wasted: 0,   // default or initial value
        score: 0,    // default or initial value
      });
    console.log("User assigned_ID:", user.assigned_ID);
    console.log("User hID:", user.hID);

    console.log("This is your new consumed object:", newConsumed);
    var new_consumption = await newConsumed.save();
    newID = new_consumption.assigned_ID;
    return newID; // Indicate that a new consumed was created
    
    } catch (error) {
      console.error("Error checking or saving consumed:", error);
      throw error; // Re-throw the error to handle it elsewhere if needed
    }
  }

  export async function getFoodDetailForFoodInventory(fID) {

    // For Frontend Display Screen 
    // Data Preprocessing steps -> get food data and format it
  
    try {
      var assigned_ID = fID
  
      // Get the food item
      var food = await Food.findOne({ assigned_ID })
  
      var consume_msg = ""
      var remain_msg = ""
  
  
  
      if (food.isCountable) {
        var package_id = food.package_type
        var package_type = await mapPackageType(package_id)
  
        consume_msg = `${Number(food.consumed_quantity.toString())} ${package_type}${Number(food.consumed_quantity.toString()) > 1 ? (package_type === 'Box' ? 'es' : 's') : ''}`;
        remain_msg = `${Number(food.current_quantity.toString())} ${package_type}${Number(food.current_quantity.toString()) > 1 ? (package_type === 'Box' ? 'es' : 's') : ''}`;
  
      } else {
        var unit_id = food.weight_type
        var unit_type = await mapUnitType(unit_id)
  
        consume_msg = `${Number(food.consumed_amount.toString())} ${unit_type}${unit_type === 'Kg' && Number(food.consumed_amount.toString()) > 1 ? 's' : ''}`;
        remain_msg = `${Number(food.current_amount.toString())} ${unit_type}${unit_type === 'Kg' && Number(food.current_amount.toString()) > 1 ? 's' : ''}`;
  
  
      }
  
  
      return {
        "Food_ID": fID,
        "FoodName": food.food_name,
        "Expired": food.bestByDate,
        "Consuming": consume_msg,
        "Remaining": remain_msg,
        "URL": food.img
      };
  
  
  
    } catch (error) {
      console.error("Error checking Food:", error);
      throw error; //
    }
  }


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