import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import User from "../schema/user_module/userSchema.js";
import House from "../schema/user_module/houseSchema.js";
import Organization from "../schema/user_module/organizationSchema.js";
import ConsumedFood from "../schema/inventory_module/consumedFoodSchema.js";

export async function save_consume_to_db(fID,user,retrievedAmount, retrievedQuantity) {
    try {
      // Check if the house already exists in the database
      var newID = 0;
      var userID = user.assigned_ID
      var hID = user.hID

      const newConsumed = new ConsumedFood({
        food_ID: fID,
        user_ID: userID,
        h_ID: hID,  // provide userID value
        current_amount: retrievedAmount,  // retrievedAmount mapped to current_amount
        current_quantity: retrievedQuantity,  // retrievedQuantity mapped to current_quantity
        saved: 0,  // default or initial value
        lost: 0,   // default or initial value
        consumed: 0,  // default or initial value
        wasted: 0,   // default or initial value
        score: 0,    // default or initial value
      });
    console.log("This is your new consumed object:", newConsumed);
    var new_consumption = await newConsumed.save();
    newID = new_consumption.assigned_ID;
    return newID; // Indicate that a new consumed was created
    
    } catch (error) {
      console.error("Error checking or saving consumed:", error);
      throw error; // Re-throw the error to handle it elsewhere if needed
    }
  }
