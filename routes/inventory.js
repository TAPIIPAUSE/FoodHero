// import express from 'express';
import bcrypt from "bcryptjs";
import express from "express";
import UnitType from '../schema/inventory_module/unitTypeSchema.js';
import FoodType from '../schema/inventory_module/foodTypeSchema.js';
import PackageUnitType from '../schema/inventory_module/packageTypeSchema.js';
import Location from '../schema/inventory_module/locationSchema.js';
import Food from '../schema/inventory_module/foodInventorySchema.js';
import { get_user_from_db, get_houseID } from '../service/user_service.js';
import { authenticateToken } from "../service/jwt_auth.js";
import { getFoodDetailForFoodDetail, getFoodDetailForFoodInventory,save_consume_to_db  } from "../service/inventory_service.js";
import { calculateSaveLost, calculateScore } from "../service/score_service.js";
import ConsumedFood from "../schema/inventory_module/consumedFoodSchema.js";
import { calculateCompleteConsumedData, updateConsume, updateHouseScore, updateOrgScore, calculateCompleteWasteData, updateCompleteConsume, updateCompleteWaste } from "../service/consume_service.js";
import PersonalScore from "../schema/score_module/PersonalScoreSchema.js";
import User from "../schema/user_module/userSchema.js";


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

router.post("/addFood", authenticateToken, async (req, res) => {
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

    await newFood.save();

    return res.status(200).send("New Food Registered to your Fridge");
  } catch (error) {
    return res.status(500).send(`Error registering Food: ${error.message}`);
  }
});

router.put("/editFood", authenticateToken, async (req, res) => {
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
    existingFood.img = img;
    existingFood.location = location;
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
router.get("/getFoodByHouse", authenticateToken, async (req, res) => {
  // const {fID} = req.body

  var user = await get_user_from_db(req, res);

  var hID = user.hID;

  try {
    // search foods by the house ID
    const house_fridge = await Food.find({ hID });
    const food_size = await Food.countDocuments({ hID });

    const food_array = await Promise.all(
      house_fridge.map(async (food) => {
        const foodDetail = await getFoodDetailForFoodInventory(food.assigned_ID);
        return foodDetail;
      })
    );

    return res.status(200).send({
      Document_Number: food_size,
      food: food_array
    });
  } catch (error) {
    return res.status(400).send(`Error when getting Food's Info: ${error}`);
  }
});

// This function is created to retrieve food within that house
router.get("/getFoodById", authenticateToken, async (req, res) => {
  const { fID } = req.body;

  var user = await get_user_from_db(req, res);

  var hID = user.hID;

  try {
    // search foods by the food ID
    const assigned_ID = fID;
    const food = await Food.findOne({ assigned_ID });

    const food_detail = await getFoodDetailForFoodDetail(food.assigned_ID)

    return res.status(200).send(food_detail);
  } catch (error) {
    return res.status(400).send(`Error when getting Food's Info: ${error}`);
  }
});

// Delete by the input's fID
router.post("/deleteFoodById", authenticateToken, async (req, res) => {
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

router.post('/consume', authenticateToken, async (req, res) => {

  var { fID, retrievedAmount, retrievedQuantity } = req.body;

  try {
    var assigned_ID = fID

    // Get the food item
    var food = await Food.findOne({ assigned_ID })

    if (!food) {
      return res.status(404).send(`Food item with assigned_ID ${assigned_ID} not found.`);
    }
    var countable = food.isCountable

    // Narrative: Countable food will be given only quantity, therefore we need to calculate the change of weight y ourselves,
    // We start off by calcualting the per unit weight
    if (countable) {

      const perunitAmount = food.total_amount / food.total_quanitity
      //per unit weight calculation

      retrievedAmount = perunitAmount * retrievedQuantity

      var currentQuantity = food.current_quantity
      if (retrievedQuantity > currentQuantity) {
        return res.status(403).send(`Your order is not fulfilled, the current quantity is not enough for your retreiveal, please select again.\n
          Here is your current quantity ${currentQuantity}, but here is your requested quantity ${retrievedQuantity}`)
      }

      var newCurrentQuantity = currentQuantity - retrievedQuantity

      var user = await get_user_from_db(req, res)
      var user_ID = user.assigned_ID
      // Create consumed object

      var consumed_ID = await save_consume_to_db(fID, user, retrievedAmount, retrievedQuantity)

      console.log("This is our newly registered consumed food: ", consumed_ID)

      // Update the currentAmount on inventory collection
      food.current_amount = food.current_amount - retrievedAmount
      food.current_quantity = newCurrentQuantity
      food.consumed_quantity = parseInt(food.consumed_quantity) + retrievedQuantity //need to parse int first: CAREFUL
      food.consumed_amount = parseInt(food.consumed_amount) + retrievedAmount //need to parse int first: CAREFUL

      await food.save()

    } else {
      var currentAmount = food.current_amount
      if (retrievedAmount > currentAmount) {
        return res.status(403).send(`Your order is not fulfilled, the current amount is not enough for your retreiveal, please select again.\n
          Here is your current amount ${currentAmount}, but here is your requested amount ${retrievedAmount}`)
      }

      var newCurrentAmount = currentAmount - retrievedAmount

      var user = await get_user_from_db(req, res)
      var user_ID = user.assigned_ID
      // Create consumed object
      var consumed_ID = save_consume_to_db(fID, user, retrievedAmount, retrievedQuantity)

      console.log("This is our newly registered consumed food: ", consumed_ID)

      // Update the currentAmount on inventory collection
      food.current_amount = newCurrentAmount
      food.consumed_amount = retrievedAmount

      await food.save()


    }

    res.status(200).send(`Successfully consume food: ${food}\n`)

  } catch (error) {
    return res.status(400).send(`Error when consuming Food: ${error}`)
  }

})

router.post('/consume/all', authenticateToken, async (req, res) => {
  const { fID } = req.body;

  try {
    const food = await Food.findOne({ assigned_ID: fID });
    const user = await get_user_from_db(req, res)
    var consume_percen = 100


    let consumedFood = await ConsumedFood.findOne({ assigned_ID: fID, user_ID: user.assigned_ID });
    if (!food) {
      return res.status(404).json({ message: 'Food item not found' });
    }

    // 1) Calculate the score for consuming all of the food
    let score = await calculateScore(food.total_amount, consume_percen, food.weight_type); // Consuming 100% of the food

    // 2)Calculate Consumed Amount 
    var {
      current_amount: act_current_amount,
      current_quan: act_current_quan,
      consume_amount: act_consume_amount,
      consume_quan: act_consume_quan,
      waste: w,
      consumed: c } = await calculateCompleteConsumedData(consume_percen, food)

      

    // 3) Update in database
    // 3.1) Update in Food Inventory Database
    await updateCompleteConsume(food)

    const { saved: save, lost: lost } = await calculateSaveLost(food, consume_percen)
    // 3.2) Update Score in Personal Score Database
    var personObject = new PersonalScore({
      "userID": user.assigned_ID,
      "hID": user.hID,
      "orgID": user.orgID,
      "Score": score,
      "Consume": c,
      "Waste": w,
      "Saved": save,
      "Lost": lost,
    })

    await personObject.save()

    // 3.3) Update Score in Household Score Database

    const HouseSize = await User.countDocuments({ hID: user.hID });

    await updateHouseScore(user, score, HouseSize)

    // 3.4) Update Score in Organization Score Database

    const OrgSize = await User.countDocuments({ orgID: user.orgID });

    await updateOrgScore(user, score, OrgSize)


    res.status(200).json({
      message: 'Food item consumed successfully',
      scoreGained: score,
      PersonObject: personObject
    });

  } catch (error) {
    console.error('Error in consume all route:', error);
    res.status(500).json({ message: 'An error occurred while processing your request' });
  }
});

router.post('/complete_waste', authenticateToken, async (req, res) => {
  const { fID } = req.body;

  try {
    const food = await Food.findOne({ assigned_ID: fID });
    const user = await get_user_from_db(req, res)
    var consume_percen = 0


    let consumedFood = await ConsumedFood.findOne({ assigned_ID: fID, user_ID: user.assigned_ID });
    if (!food) {
      return res.status(404).json({ message: 'Food item not found' });
    }

    // 1) Calculate the score for consuming all of the food
    let score = await calculateScore(food.total_amount, consume_percen, food.weight_type); // Consuming 100% of the food

    // 2)Calculate Consumed Amount 
    var {
      current_amount: act_current_amount,
      current_quan: act_current_quan,
      consume_amount: act_consume_amount,
      consume_quan: act_consume_quan,
      waste: w,
      consumed: c } = await calculateCompleteWasteData(consume_percen, food)

    // 3) Update in database
    // 3.1) Update in Food Inventory Database
    await updateCompleteWaste(food)

    const { saved: save, lost: lost } = await calculateSaveLost(food, consume_percen)
    // 3.2) Update Score in Personal Score Database
    var personObject = new PersonalScore({
      "userID": user.assigned_ID,
      "hID": user.hID,
      "orgID": user.orgID,
      "Score": score,
      "Consume": c,
      "Waste": w,
      "Saved": save,
      "Lost": lost,
    })

    console.log(score)

    await personObject.save()

    // 3.3) Update Score in Household Score Database

    const HouseSize = await User.countDocuments({ hID: user.hID });

    await updateHouseScore(user, score, HouseSize)

    // 3.4) Update Score in Organization Score Database

    const OrgSize = await User.countDocuments({ orgID: user.orgID });

    await updateOrgScore(user, score, OrgSize)


    res.status(200).json({
      message: 'Food item Waste successfully',
      scoreGained: score,
      PersonObject: personObject
    });

  } catch (error) {
    console.error('Error in Waste all route:', error);
    res.status(500).json({ message: 'An error occurred while processing your request' });
  }
});

router.post("/compaction", authenticateToken, async(req,res)=>{
  try{
    await Food.deleteMany({
      current_amount: 0,
      current_quantity: 0,
      consumed_amount: 0,
      consumed_quantity: 0,
    });
    

    return res.status(200).send({
      message: "Compact Food Inventory Collection Successfully",
    })
  }catch (error){
    return res.status(200).send({
      message: "Error when compacting the Food Inventory Collection",
      error: error
    })
  }
})

export default router;
