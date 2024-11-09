// import express from 'express';
import bcrypt from "bcryptjs";
import express from "express";
import Food from '../schema/inventory_module/foodInventorySchema.js';
import ConsumedFood from "../schema/inventory_module/consumedFoodSchema.js";
import { get_user_from_db, get_houseID } from '../service/user_service.js';
import { save_consume_to_db } from '../service/inventory_service.js';
import { authenticateToken } from "../service/jwt_auth.js";
import { getFoodDetailForConsumeDetail, getFoodDetailForConsumeInventory, mapAmountQuan } from "../service/consume_service.js";
import { calculateScore,calculateSaveLost, calculateSaveLostForConsume } from "../service/score_service.js";
import { calculateConsumedData, updateConsume } from "../service/consume_service.js";
import PersonalScore from "../schema/score_module/PersonalScoreSchema.js";
import User from "../schema/user_module/userSchema.js";
import { updateHouseScore } from "../service/consume_service.js";
import { updateOrgScore } from "../service/consume_service.js";



const router = express.Router();

// Show all consumed items within 1 fridge
router.get("/showConsumedFood", authenticateToken, async (req, res) => {


  try {
    var user = await get_user_from_db(req, res);

    var h_ID = user.hID;
    const consumed_number = await ConsumedFood.countDocuments({ h_ID });
    const consumed_items = await ConsumedFood.find({ h_ID });
    // Fetch food details for each consumed item using Promise.all to wait for all promises to resolve
    const food_array = await Promise.all(
      consumed_items.map(async (food) => {
        const foodDetail = await getFoodDetailForConsumeInventory(food.food_ID, food.assigned_ID);
        return foodDetail;
      })
    );

    return res.status(200).send({
      Document_Number: consumed_number,
      food: food_array
    });
  } catch (error) {
    return res.status(400).send("Error when showing consumed food list", error);
  }
});

router.get("/getConsumeById", authenticateToken, async (req, res) => {
  const { cID } = req.body;

  try {
    // search foods by the food ID
    
    const assigned_ID = cID;
    const consumedFood = await ConsumedFood.findOne({ assigned_ID });
    const fID = consumedFood.food_ID
    
    const response = await getFoodDetailForConsumeDetail(fID, cID)
    console.log("This is Consume Response", response)
    return res.status(200).send({message: response});
  } catch (error) {
    return res.status(400).send(`Error when getting Consumed Food's Info: ${error}`);
  }
});

router.post("/confirmConsume", authenticateToken, async (req, res) => {
  const {
    cID,
    Percent
  } = req.body;
  try {
    const user = await User.findOne({username: req.user.username})
    const consumed_item = await ConsumedFood.findOne({ assigned_ID: cID })
    const food = await Food.findOne({ assigned_ID: consumed_item.food_ID })
  
    const { t_a: t_A,
      t_q: t_Q,
      t_p: t_P,
      c_a: c_A,
      c_q: c_Q,
      consumed_a: consumed_A,
      consumed_q: consumed_Q } = await mapAmountQuan(consumed_item.food_ID)

    // 1)Calculate Score Obtained from this Confirm Consumption
    let score = await calculateScore(t_A, Percent, food.weight_type)

    // 2)Calculate Waste Amount 
    var {
      current_amount: actual_c_A,
      current_quan: actual_c_Q, 
    act_consumed_amount: actual_consumed_amount,
    act_consumed_quan: actual_consumed_quantity} = await calculateConsumedData(Percent, consumed_item)

    // 3) Update in database
    // 3.1) Update in Food Inventory Database
    const updated_c_A = parseFloat(consumed_item.current_amount) - actual_c_A
    const updated_c_Q = parseFloat(consumed_item.current_quantity) - actual_c_Q


    await updateConsume(cID,food, updated_c_A, updated_c_Q, actual_c_A, actual_c_Q)
// CHECKPOINT1
    const { saved: save, lost: lost } = await calculateSaveLostForConsume(food,consumed_item, Percent)
    // 3.2) Update Score in Personal Score Database

    const leftover = parseFloat(consumed_item.current_amount) - actual_consumed_amount

    
    
    var personObject = new PersonalScore({
      "userID": user.assigned_ID,
      "hID": user.hID,
      "orgID": user.orgID,
      "Score": score,
      "Consume": actual_consumed_amount,
      "Waste": leftover,
      "Saved": save,
      "Lost": lost,
      "FoodType": food.food_category
    })

    console.log(personObject)
// CHECKPOINT2
    await personObject.save()

    // 3.3) Update Score in Household Score Database

    const HouseSize = await User.countDocuments({ hID: user.hID });
// CHECKPOINT3
    await updateHouseScore(user,score,HouseSize)

    // 3.4) Update Score in Organization Score Database

    const OrgSize = await User.countDocuments({ orgID: user.orgID });
// CHECKPOINT4
    await updateOrgScore(user,score,OrgSize)



    return res.status(200).send({
      message: "Consume Successfully",
      cID: consumed_item.assigned_ID,
      Score: score,
      Consumed_Amount: actual_consumed_amount,
      Wasted_Amount: leftover,
      Saved: save,
      Lost: lost
    })
  } catch (error) {
    return res.status(400).send(`Error when Confirm Consume : ${error}`);
  }
})

router.post("/compaction", authenticateToken, async(req,res)=>{
  try{
    await ConsumedFood.deleteMany({
      current_amount: 0,
      current_quantity: 0
    });
    

    return res.status(200).send({
      message: "Compact Consume Collection Successfully",
    })
  }catch (error){
    return res.status(200).send({
      message: "Error when compacting the Consume Collection",
      error: error
    })
  }
})

export default router;