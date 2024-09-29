// import express from 'express';
import bcrypt from 'bcryptjs';
import express from "express";
import UnitType from '../schema/unitTypeSchema.js';
import FoodType from '../schema/foodTypeSchema.js';
import Food from '../schema/foodInventorySchema.js';
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

router.put("/editFood", async (req, res) => {
  const {
    id,
    food_name,
    food_category,
    unit_type,
    current_amount,
    total_amount,
    total_price,
    bestByDate,
  } = req.body;

  var user = await get_user_from_db(req, res);

  var hID = await get_houseID(user);

  try {
    // Find the existing food item
    const existingFood = await Food.findOne({ _id: id, hID: hID });

    if (!existingFood) {
      return res.status(404).send("Food item not found or you don't have permission to edit it");
    }

    // Update the food item
    existingFood.food_name = food_name;
    existingFood.food_category = food_category;
    existingFood.unit_type = unit_type;
    existingFood.current_amount = current_amount;
    existingFood.total_amount = total_amount;
    existingFood.total_price = total_price;
    existingFood.bestByDate = bestByDate;

    // Save the updated food item
    await existingFood.save();

    console.log(existingFood);

    return res.status(200).json(existingFood);
  } catch (error) {
    return res.status(500).send(`Error updating Food: ${error.message}`);
  }
});

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

// Delete by the input's fID
router.post('/deleteFoodById', async(req,res) => {
  const {fID} = req.body
  var user = await get_user_from_db(req,res)
  try{
  // search foods by the food ID
  const assigned_ID = fID
  // Deletion doesn't require save -> deleteOne with the designated ID, and that's all
  const deleteResult = await Food.deleteOne({assigned_ID})

  // delete result looks like this { acknowledged: true, deletedCount: 1 }
  
  // Secondly, the delete function returns the deletion object
  if (deleteResult.deletedCount === 0) {
    return res.status(404).send("Food not found");
  }

  return res.status(200).send("Delete Successfully")

  }catch(error){
    return res.status(400).send(`Error when deleting Food's Info: ${error}`)
  }
})

export default router;