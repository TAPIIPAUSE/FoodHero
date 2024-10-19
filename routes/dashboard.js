import express from "express";
import { get_user_from_db } from "../service/user_service.js";
import HouseholdScore from "../schema/score_module/HouseholdScoreSchema.js";
import { authenticateToken } from "../service/jwt_auth.js";
import User from "../schema/user_module/userSchema.js";
import { preprocess_House_Score } from "../service/score_service.js";


const router = express.Router();

// Show all consumed items within 1 fridge
router.get("/household/score", authenticateToken, async (req, res) => {


    try {
      var user = await get_user_from_db(req, res);
  
      var h_ID = user.hID;
  
      // We get Score Array from this Function
      const processed_score_array = await preprocess_House_Score(h_ID)

      
      return res.status(200).send({
        "Messages": "Successfully Retrieved House Score",
        "Score List": processed_score_array
      });
    } catch (error) {
      return res.status(400).send(`Error when retrieving household score: ${error}`);
    }
  });

  export default router;