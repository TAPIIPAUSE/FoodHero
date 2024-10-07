// import express from 'express';
import bcrypt from "bcryptjs";
import express from "express";
import Food from '../schema/inventory_module/foodInventorySchema.js';
import ConsumedFood from "../schema/inventory_module/consumedFoodSchema.js";
import { get_user_from_db, get_houseID } from '../service/user_service.js';
import { save_consume_to_db } from '../service/inventory_service.js';
import { authenticateCookieToken } from "../service/jwt_auth.js";
import { getFoodDetailForConsumeInventory } from "../service/consume_service.js";

const router = express.Router();

// Show all consumed items within 1 fridge
router.get("/showConsumedFood",authenticateCookieToken, async (req, res) => {
  
    
try {
    var user = await get_user_from_db(req, res);
  
    var h_ID = user.hID;
  
    const consumed_items = await ConsumedFood.find({ h_ID });
    // Fetch food details for each consumed item using Promise.all to wait for all promises to resolve
    const food_array = await Promise.all(
      consumed_items.map(async (food) => {
        const foodDetail = await getFoodDetailForConsumeInventory(food.food_ID, food.assigned_ID);
        return foodDetail;
      })
    );
    
    console.log(food_array)
  return res.status(200).send("Successful");
} catch (error) {
  return res.status(400).send("Error when showing consumed food list", error);
}
});

export default router;