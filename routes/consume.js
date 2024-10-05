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
  
    
  var user = await get_user_from_db(req, res);

  var h_ID = user.hID;

  const consumed_items = await ConsumedFood.find({ h_ID });

  var food_array = []

  consumed_items.forEach(food => {
    food_array.push(getFoodDetailForConsumeInventory(food.fID))
});

  res.status(200).send("Successful");
});

export default router;