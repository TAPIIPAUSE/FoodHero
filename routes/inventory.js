// import express from 'express';
import bcrypt from 'bcryptjs';
import express from "express";
import UnitType from '../schema/unitTypeSchema.js';
import FoodType from '../schema/foodTypeSchema.js';
import jwt from 'jsonwebtoken';
import passport from "passport";
import LocalStrategy from 'passport-local'
import { get_user_from_db, get_houseID } from '../service/user_service.js';

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

router.get('/addFood', async(req,res) => {
  const {
    food_name,
    food_category,
    unit_type,
    current_amount,
    total_amount,
    total_price
  } = req.body

  console.log(req.body)

  return res.status(200).send("Receiving Message Payload")
})


export default router;