import express from "express";
import { get_user_from_db } from "../service/user_service.js";
import HouseholdScore from "../schema/score_module/HouseholdScoreSchema.js";
import { authenticateToken } from "../service/jwt_auth.js";


const router = express.Router();

// Show all consumed items within 1 fridge
router.get("/household_score", authenticateToken, async (req, res) => {


    try {
      var user = await get_user_from_db(req, res);

      console.log("This is our user :", user)
  
      var h_ID = user.hID;
  
      const houseScore = await HouseholdScore.find({ hID:h_ID });
      // Fetch food details for each consumed item using Promise.all to wait for all promises to resolve
    //   const food_array = await Promise.all(
    //     consumed_items.map(async (food) => {
    //       const foodDetail = await getFoodDetailForConsumeInventory(food.food_ID, food.assigned_ID);
    //       return foodDetail;
    //     })
    //   );
  
      return res.status(200).send(houseScore);
    } catch (error) {
      return res.status(400).send("Error when retrieving household score", error);
    }
  });

  export default router;