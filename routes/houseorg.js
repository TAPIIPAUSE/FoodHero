import express from "express";
import { get_user_from_db } from "../service/user_service.js";
import { preprocess_House_Score, preprocess_Org_Score } from "../service/score_service.js";
import { authenticateToken } from "../service/jwt_auth.js";
import { preprocess_house_barchart, preprocess_org_barchart} from "../service/houseorg_service.js";
import House from "../schema/user_module/houseSchema.js";
import Organization from "../schema/user_module/organizationSchema.js";

const router = express.Router();

// Show all consumed items within 1 fridge
router.get("/household/score", authenticateToken, async (req, res) => {


    try {
      var user = await get_user_from_db(req, res);
      // We get Score Array from this Function
      const processed_score_array = await preprocess_House_Score(user)

      
      return res.status(200).send({
        "Messages": "Successfully Retrieved House Score",
        "Score_List": processed_score_array
      });
    } catch (error) {
      return res.status(400).send(`Error when retrieving household score: ${error}`);
    }
  });

    // Show all consumed items within 1 fridge
router.get("/organization/score", authenticateToken, async (req, res) => {


    try {
      var user = await get_user_from_db(req, res);
      // We get Score Array from this Function
      const processed_score_array = await preprocess_Org_Score(user)
  
      
      return res.status(200).send({
        "Messages": "Successfully Retrieved Organization Score",
        "Score_List": processed_score_array
      });
    } catch (error) {
      return res.status(400).send(`Error when retrieving organization score: ${error}`);
    }
  });

router.get("/household/weekly_fs-bar", authenticateToken, async (req, res) => {


    try {
      var user = await get_user_from_db(req, res);
  
      var h_ID = user.hID;
  
      // We get Score Array from this Function
      const processed_score_array = await preprocess_house_barchart(h_ID)

      
      return res.status(200).send({
        "Messages": "Successfully Retrieved House Score",
        "Document_Number": processed_score_array.length,
        "Week_List": processed_score_array
      });
    } catch (error) {
      return res.status(400).send(`Error when retrieving household score: ${error}`);
    }
  });

router.get("/organization/weekly_fs-bar", authenticateToken, async (req, res) => {


  try {
    var user = await get_user_from_db(req, res);

    var orgID = user.orgID;

    // We get Score Array from this Function
    const processed_score_array = await preprocess_org_barchart(orgID)

    
    return res.status(200).send({
      "Messages": "Successfully Retrieved Organization Barchart",
      "Document_Number": processed_score_array.length,
      "Week_List": processed_score_array
    });
  } catch (error) {
    return res.status(400).send(`Error when retrieving household score: ${error}`);
  }
});

router.get("/household/getHouseName", authenticateToken, async (req, res) => {


  try {
    var user = await get_user_from_db(req, res);
    // We get Score Array from this Function
    var house = await House.findOne({assigned_ID: user.hID})

    console.log(house)
    return res.status(200).send({
      "Messages": "Successfully Get House Name",
      "House_Name": house.house_name,
      "hID": house.assigned_ID
    });
  } catch (error) {
    return res.status(400).send(`Error when retrieving household score: ${error}`);
  }
});

router.get("/organization/getOrgName", authenticateToken, async (req, res) => {


  try {
    var user = await get_user_from_db(req, res);
    // We get Score Array from this Function
    var organization = await Organization.findOne({assigned_ID: user.orgID})

    
    return res.status(200).send({
      "Messages": "Successfully Get Organization Name",
      "Organiazation_Name": organization.org_name,
      "orgID": organization.assigned_ID
    });
  } catch (error) {
    return res.status(400).send(`Error when retrieving household score: ${error}`);
  }
});

export default router;