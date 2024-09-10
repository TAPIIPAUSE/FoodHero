// import express from 'express';
import bcrypt from 'bcryptjs';
import express from "express";
import UnitType from '../schema/unitTypeSchema.js';
import FoodType from '../schema/foodTypeSchema.js';
import Food from '../schema/foodInventorySchema.js';
import jwt from 'jsonwebtoken';
import passport from "passport";
import LocalStrategy from 'passport-local'
import { get_user_from_db, get_houseID } from '../service/user_service.js';
import House from '../schema/houseSchema.js';

const router = express.Router();

router.post('/addUnit',async(req,res) => {

    const {type} = req.body;

    const existingUnitType = await UnitType.findOne({ type });
    if (existingUnitType) {
      return res.status(400).send('Unit Type already exists');
    }

    const newUnitType = new UnitType({
        type
    })

    console.log("This will be your new unit:", type)

    await newUnitType.save();

    res.status(200).send("New Unit Type Registered");
})

router.post('/addFoodType',async(req,res) => {

    const {type} = req.body;

    const exisitingFoodType = await FoodType.findOne({ type });
    if (exisitingFoodType) {
      return res.status(400).send('Food Type already exists');
    }

    const newFoodType = new FoodType({
        type
    })

    console.log("This will be your new unit:", type)

    await newFoodType.save();

    res.status(200).send("New Food Type Registered");
})

router.post('/addFood', async(req,res) => {
  const {
    food_name,
    food_category,
    unit_type,
    current_amount,
    total_amount,
    total_price,
    bestByDate
  } = req.body

  var user = await get_user_from_db(req,res)

  var hID = await get_houseID(user)

  try{
    const newFood = new Food({
      hID,
      food_name,
      food_category,
      unit_type,
      current_amount,
      total_amount,
      total_price,
      bestByDate
    })
  
    console.log(newFood)
  
    await newFood.save();
  
    return res.status(200).send("New Food Registered to your Fridge")
  }catch (error){
    return res.status(500).send(`Error registering Food: ${error.message}`);
  }


})

// This function is created to retrieve all foods within that house
router.get('/getFoodByHouse', async(req,res) => {

  // const {fID} = req.body

  var user = await get_user_from_db(req,res)

  var hID = user.hID

  try{
  // search foods by the house ID
  const house_fridge = await Food.find({hID})

  return res.status(200).send(house_fridge)

  }catch(error){
    return res.status(400).send(`Error when getting Food's Info: ${error}`)
  }
})

// This function is created to retrieve food within that house
router.get('/getFoodById', async(req,res) => {

  const {fID} = req.body

  var user = await get_user_from_db(req,res)

  var hID = user.hID

  try{
  // search foods by the food ID
  const assigned_ID = fID
  const food = await Food.findOne({assigned_ID})


  return res.status(200).send(food)

  }catch(error){
    return res.status(400).send(`Error when getting Food's Info: ${error}`)
  }
})

export default router;