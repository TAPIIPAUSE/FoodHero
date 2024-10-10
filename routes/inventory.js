// import express from 'express';
import bcrypt from "bcryptjs";
import express from "express";
import UnitType from '../schema/inventory_module/unitTypeSchema.js';
import FoodType from '../schema/inventory_module/foodTypeSchema.js';
import PackageUnitType from '../schema/inventory_module/packageTypeSchema.js';
import Location from '../schema/inventory_module/locationSchema.js';
import Food from '../schema/inventory_module/foodInventorySchema.js';
import { get_user_from_db, get_houseID } from '../service/user_service.js';
import { authenticateCookieToken } from "../service/jwt_auth.js";
import { getFoodDetailForFoodInventory } from "../service/inventory_service.js";
import { calculateScore, save_consume_to_db } from '../service/inventory_service.js';
import ConsumedFood from "../schema/inventory_module/consumedFoodSchema.js";

const router = express.Router();

router.post("/addUnit", async (req, res) => {
  const { type } = req.body;

  const existingUnitType = await UnitType.findOne({ type });
  if (existingUnitType) {
    return res.status(400).send("Unit Type already exists");
  }

  const newUnitType = new UnitType({
    type,
  });

  console.log("This will be your new unit:", type);

  await newUnitType.save();

  res.status(200).send("New Unit Type Registered");
});

router.post("/addFoodType", async (req, res) => {
  const { type } = req.body;

  const existingPackageType = await FoodType.findOne({ type });
  if (exisitingFoodType) {
    return res.status(400).send("Food Type already exists");
  }

  const newFoodType = new FoodType({
    type,
  });

  console.log("This will be your new unit:", type);

  await newFoodType.save();

  res.status(200).send("New Food Type Registered");
});

router.post("/addPackageType", async (req, res) => {
  const { type } = req.body;

  const existingPackageType = await PackageUnitType.findOne({ type });
  if (existingPackageType) {
    return res.status(400).send("Food Type already exists");
  }

  const newPackage = new PackageUnitType({
    type,
  });

  console.log("This will be your new package unit:", type);

  await newPackage.save();

  res.status(200).send("New Food Package Type Registered");
});

router.post("/addLocation", async (req, res) => {
  const { location } = req.body;

  const existingLocation = await Location.findOne({ location });
  if (existingLocation) {
    return res.status(400).send("Location already exists");
  }

  const newLocation = new Location({
    location,
  });

  console.log("This will be your new location:", location);

  await newLocation.save();

  res.status(200).send("Location Registered");
});

router.post("/addFood", authenticateCookieToken,async (req, res) => {
  const {
    food_name,
    img,
    location,
    food_category,
    isCountable,
    weight_type,
    package_type,
    current_amount,
    total_amount,
    consumed_amount,
    current_quantity,
    total_quanitity,
    consumed_quantity,
    total_price,
    bestByDate,
    RemindDate,
  } = req.body;

  var user = await get_user_from_db(req, res);

  var hID = await get_houseID(user);

  try {
    const newFood = new Food({
      hID,
      food_name,
      img,
      location,
      food_category,
      isCountable,
      weight_type,
      package_type,
      current_amount,
      total_amount,
      consumed_amount,
      current_quantity,
      total_quanitity,
      consumed_quantity,
      total_price,
      bestByDate,
      RemindDate,
    });

    console.log(newFood);

    await newFood.save();

    return res.status(200).send("New Food Registered to your Fridge");
  } catch (error) {
    return res.status(500).send(`Error registering Food: ${error.message}`);
  }
});

router.put("/editFood", authenticateCookieToken,async (req, res) => {
  var hID = await get_houseID(user);
  var user = await get_user_from_db(req, res);
  const {
    id,
    food_name,
    img,
    location,
    food_category,
    isCountable,
    weight_type,
    package_type,
    current_amount,
    total_amount,
    consumed_amount,
    current_quantity,
    total_quanitity,
    consumed_quantity,
    total_price,
    bestByDate,
    remindDate,
  } = req.body;

  try {
    // Find the existing food item
    const existingFood = await Food.findOne({ _id: id, hID: hID });

    if (!existingFood) {
      return res
        .status(404)
        .send("Food item not found or you don't have permission to edit it");
    }

    // Update the food item
    existingFood.food_name = food_name;
    existingFood.img=img;
    existingFood.location=location;
    existingFood.food_category = food_category;
    existingFood.isCountable = isCountable;
    existingFood.weight_type = weight_type;
    existingFood.package_type = package_type;
    existingFood.current_amount = current_amount;
    existingFood.total_amount = total_amount;
    existingFood.consumed_amount = consumed_amount;
    existingFood.current_quantity = current_quantity;
    existingFood.total_quanitity = total_quanitity;
    existingFood.consumed_quantity = consumed_quantity;
    existingFood.total_price = total_price;
    existingFood.bestByDate = bestByDate;
    existingFood.remindDate = remindDate;

    // Save the updated food item
    await existingFood.save();

    console.log(existingFood);

    return res.status(200).json(existingFood);
  } catch (error) {
    return res.status(500).send(`Error updating Food: ${error.message}`);
  }
});

// This function is created to retrieve all foods within that house
router.get("/getFoodByHouse",authenticateCookieToken, async (req, res) => {
  // const {fID} = req.body

  var user = await get_user_from_db(req, res);

  var hID = user.hID;

  try {
    // search foods by the house ID
    const house_fridge = await Food.find({ hID });

    const food_array = await Promise.all(
      house_fridge.map(async (food) => {
        const foodDetail = await getFoodDetailForFoodInventory(food.assigned_ID);
        return foodDetail;
      })
    );

    return res.status(200).send(food_array);
  } catch (error) {
    return res.status(400).send(`Error when getting Food's Info: ${error}`);
  }
});

// This function is created to retrieve food within that house
router.get("/getFoodById", authenticateCookieToken,async (req, res) => {
  const { fID } = req.body;

  var user = await get_user_from_db(req, res);

  var hID = user.hID;

  try {
    // search foods by the food ID
    const assigned_ID = fID;
    const food = await Food.findOne({ assigned_ID });

    return res.status(200).send(food);
  } catch (error) {
    return res.status(400).send(`Error when getting Food's Info: ${error}`);
  }
});

// Delete by the input's fID
router.post("/deleteFoodById", authenticateCookieToken,async (req, res) => {
  const { fID } = req.body;
  var user = await get_user_from_db(req, res);
  try {
    // search foods by the food ID
    const assigned_ID = fID;
    // Deletion doesn't require save -> deleteOne with the designated ID, and that's all
    const deleteResult = await Food.deleteOne({ assigned_ID });

    // delete result looks like this { acknowledged: true, deletedCount: 1 }

    // Secondly, the delete function returns the deletion object
    if (deleteResult.deletedCount === 0) {
      return res.status(404).send("Food not found");
    }

    return res.status(200).send("Delete Successfully");
  } catch (error) {
    return res.status(400).send(`Error when deleting Food's Info: ${error}`);
  }
});

router.post('/consume', authenticateCookieToken,async(req,res)=>{

  var {fID, retrievedAmount, retrievedQuantity} = req.body;

  try{
    var assigned_ID = fID

    // Get the food item
    var food = await Food.findOne({assigned_ID})

    if (!food) {
      return res.status(404).send(`Food item with assigned_ID ${assigned_ID} not found.`);
    }
    var countable = food.isCountable

    // Narrative: Countable food will be given only quantity, therefore we need to calculate the change of weight y ourselves,
    // We start off by calcualting the per unit weight
    if(countable){

      const perunitAmount = food.total_amount/food.total_quanitity
      //per unit weight calculation

      retrievedAmount = perunitAmount * retrievedQuantity

      var currentQuantity = food.current_quantity
      if(retrievedQuantity > currentQuantity){
        return res.status(403).send(`Your order is not fulfilled, the current quantity is not enough for your retreiveal, please select again.\n
          Here is your current quantity ${currentQuantity}, but here is your requested quantity ${retrievedQuantity}`)
      }

      var newCurrentQuantity = currentQuantity - retrievedQuantity

      var user = get_user_from_db(req,res)
      var user_ID = user.assigned_ID
      // Create consumed object

      var consumed_ID = await save_consume_to_db(fID,user,retrievedAmount, retrievedQuantity)

      console.log("This is our newly registered consumed food: ",consumed_ID)

      // Update the currentAmount on inventory collection
      food.current_amount = food.current_amount - retrievedAmount
      food.current_quantity = newCurrentQuantity
      food.consumed_quantity = parseInt(food.consumed_quantity) + retrievedQuantity //need to parse int first: CAREFUL
      food.consumed_amount = parseInt(food.consumed_amount) + retrievedAmount //need to parse int first: CAREFUL

      await food.save()

    }else{
      var currentAmount = food.current_amount
      if(retrievedAmount > currentAmount){
        return res.status(403).send(`Your order is not fulfilled, the current amount is not enough for your retreiveal, please select again.\n
          Here is your current amount ${currentAmount}, but here is your requested amount ${retrievedAmount}`)
      }

      var newCurrentAmount = currentAmount - retrievedAmount

      var user = await get_user_from_db(req,res)
      var user_ID = user.assigned_ID
      // Create consumed object
      var consumed_ID = save_consume_to_db(fID, user,retrievedAmount, retrievedQuantity)

      console.log("This is our newly registered consumed food: ",consumed_ID)

      // Update the currentAmount on inventory collection
      food.current_amount = newCurrentAmount
      food.consumed_amount = retrievedAmount

      await food.save()


  }

  res.status(200).send(`Successfully consume food: ${food}\n`)

  }catch(error){
    return res.status(400).send(`Error when consuming Food: ${error}`)
  }

})

router.post('/consume/all', async (req, res) => {
  const { fID } = req.body;

  try {
    const food = await Food.findOne({ assigned_ID: fID });
    const user = await get_user_from_db(req,res)
    let consumedFood = await ConsumedFood.findOne({ assigned_ID: fID, user_ID: user.assigned_ID });
    if (!food) {
      return res.status(404).json({ message: 'Food item not found' });
    }

    // Calculate the score for consuming all of the food
    let score = await calculateScore(food.total_amount,food.current_amount,food.weight_type); // Consuming 100% of the food
    if (Object.is(score, -0) || Math.abs(score) < Number.EPSILON) {
      score = 0;
    }
    console.log("This is our score: ", score)

    
    await Food.updateOne(
      { assigned_ID: fID }, // Filter by assigned_ID
      {
        $set: {
          current_amount: 0,
          current_quantity: 0,
          consumed_amount: food.total_amount,
          consumed_quantity: food.total_quantity,
        },
      }
    );

    // If no consumedFood entry is found, create a new one
    if (!consumedFood) {
      consumedFood = new ConsumedFood({
        assigned_ID: fID,
        user_ID: user.assigned_ID,
        food_ID: food.assigned_ID,
        score: score,  // Set the initial score
        total_amount: food.total_amount,
        total_quantity: food.total_quantity,
        consumed_amount: food.total_amount,
        consumed_quantity: food.total_quantity,
        current_amount: 0,
        current_quantity: 0,
      });
    } else {
      // If consumedFood exists, update the score
      consumedFood.score += score;
    }

    // Save the consumedFood entry
    await consumedFood.save();

    // Remove the food item from the user's inventory
    // await Food.deleteOne({ assigned_ID: food.assigned_ID });

    res.status(200).json({
      message: 'Food item consumed successfully',
      scoreGained: score,
    });

  } catch (error) {
    console.error('Error in consume all route:', error);
    res.status(500).json({ message: 'An error occurred while processing your request' });
  }
});

export default router;
