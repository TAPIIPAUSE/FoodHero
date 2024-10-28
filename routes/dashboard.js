import express from "express";
import { get_user_from_db } from "../service/user_service.js";
import HouseholdScore from "../schema/score_module/HouseholdScoreSchema.js";
import { authenticateToken } from "../service/jwt_auth.js";
import User from "../schema/user_module/userSchema.js";
import { preprocess_House_Score, preprocess_interOrg_Score, preprocess_Org_Score } from "../service/score_service.js";
import { preprocess_House_fe_pie_chart, preprocess_House_foodtype_pie_chart, preprocess_House_fs_pie_chart, preprocess_Org_fs_pie_chart, preprocess_org_foodtype_pie_chart, preprocess_Org_fe_pie_chart, preprocess_house_heatmap, preprocess_Org_heatmap} from "../service/dashboard_service.js";
import { preprocess_house_barchart,preprocess_org_barchart } from "../service/houseorg_service.js";


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

    var orgID = user.orgID;

    // We get Score Array from this Function
    const processed_score_array = await preprocess_Org_Score(orgID)

    
    return res.status(200).send({
      "Messages": "Successfully Retrieved Organization Score",
      "Score_List": processed_score_array
    });
  } catch (error) {
    return res.status(400).send(`Error when retrieving organization score: ${error}`);
  }
});

  // Show all consumed items within 1 fridge
router.get("/inter_organization/score", authenticateToken, async (req, res) => {


  try {
    // We get Score Array from this Function
    const processed_score_array = await preprocess_interOrg_Score()

    
    return res.status(200).send({
      "Messages": "Successfully Retrieved Inter Organization Score",
      "Score_List": processed_score_array
    });
  } catch (error) {
    return res.status(400).send(`Error when retrieving inter organization score: ${error}`);
  }
});

router.get("/inter_organization/foodtype_pie_chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var orgID = user.orgID;

    const process_pie_chart = await preprocess_org_foodtype_pie_chart(orgID)

    

    return res.status(200).send({
      "Messages": "Successfully Retrieved Organization Food Saved based on Food Type Data",
      "Statistic": process_pie_chart
      // "Score List": processed_score_array
    });


  }catch(error){
    return res.status(400).send(`Error when retrieving household food saved pie chart: ${error}`);
  }
})

router.get("/household/foodtype_pie_chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var hID = user.hID;

    const process_pie_chart = await preprocess_House_foodtype_pie_chart(hID)

    

    return res.status(200).send({
      "Messages": "Successfully Retrieved Household Food Saved Data based on Food Type",
      "Statistic": process_pie_chart
      // "Score List": processed_score_array
    });


  }catch(error){
    return res.status(400).send(`Error when retrieving household food saved pie chart: ${error}`);
  }
})

router.get("/organization/foodtype_pie_chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var orgID = user.orgID;

    const process_pie_chart = await preprocess_org_foodtype_pie_chart(orgID)

    

    return res.status(200).send({
      "Messages": "Successfully Retrieved Organization Food Saved based on Food Type Data",
      "Statistic": process_pie_chart
      // "Score List": processed_score_array
    });


  }catch(error){
    return res.status(400).send(`Error when retrieving household food saved pie chart: ${error}`);
  }
})




// BEYOND THIS will be visualization module, which is sub module of dashboard based on household/organization




router.get("/household/visualization/fs-pie-chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var h_ID = user.hID;

    const process_h_stat = await preprocess_House_fs_pie_chart(h_ID)

    return res.status(200).send({
      "Messages": "Successfully Retrieved Household Food Saved Data",
      "Statistic": process_h_stat
      // "Score List": processed_score_array
    });


  }catch(error){
    return res.status(400).send(`Error when retrieving household food saved pie chart: ${error}`);
  }
})

router.get("/organization/visualization/fs-pie-chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var org_ID = user.orgID;

    const process_o_stat = await preprocess_Org_fs_pie_chart(org_ID)

    return res.status(200).send({
      "Messages": "Successfully Retrieved Organization Food Saved Data",
      "Statistic": process_o_stat
      // "Score List": processed_score_array
    });


  }catch(error){
    return res.status(400).send(`Error when retrieving household food saved pie chart: ${error}`);
  }
})

router.get("/household/visualization/fs-bar-chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var h_ID = user.hID;
     // We get Score Array from this Function
     const processed_score_array = await preprocess_house_barchart(h_ID)

      
     return res.status(200).send({
       "Messages": "Successfully Retrieved Household Weekly Food Saved in Bar Chart Format",
       "Document_Number": processed_score_array.length,
       "Week_List": processed_score_array
     });


  }catch(error){
    return res.status(400).send(`Error when retrieving household food saved pie chart: ${error}`);
  }
})

router.get("/organization/visualization/fs-bar-chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var h_ID = user.orgID;
     // We get Score Array from this Function
     const processed_score_array = await preprocess_org_barchart(h_ID)

      
     return res.status(200).send({
       "Messages": "Successfully Retrieved Organization Weekly Food Saved in Bar Chart Format",
       "Document_Number": processed_score_array.length,
       "Week_List": processed_score_array
     });


  }catch(error){
    return res.status(400).send(`Error when retrieving Organization food saved Bar chart: ${error}`);
  }
})

router.get("/household/visualization/foodtype_pie_chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var hID = user.hID;

    const process_pie_chart = await preprocess_House_foodtype_pie_chart(hID)

    

    return res.status(200).send({
      "Messages": "Successfully Retrieved Household Food Saved Data based on Food Type",
      "Statistic": process_pie_chart
      // "Score List": processed_score_array
    });


  }catch(error){
    return res.status(400).send(`Error when retrieving household food saved pie chart: ${error}`);
  }
})

router.get("/organization/visualization/foodtype_pie_chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var orgID = user.orgID;

    const process_pie_chart = await preprocess_org_foodtype_pie_chart(orgID)

    

    return res.status(200).send({
      "Messages": "Successfully Retrieved Organization Food Saved based on Food Type Data",
      "Statistic": process_pie_chart
      // "Score List": processed_score_array
    });


  }catch(error){
    return res.status(400).send(`Error when retrieving household food saved pie chart: ${error}`);
  }
})

router.get("/household/visualization/fe-pie-chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var h_ID = user.hID;

    const process_h_stat = await preprocess_House_fe_pie_chart(h_ID)

    return res.status(200).send({
      "Messages": "Successfully Retrieved Household Food Expense Data",
      "Statistic": process_h_stat
      // "Score List": processed_score_array
    });


  }catch(error){
    return res.status(400).send(`Error when retrieving household food expense pie chart: ${error}`);
  }
})

router.get("/organization/visualization/fe-pie-chart", authenticateToken, async(req,res) =>{
  try{

    var user = await get_user_from_db(req, res);
  
    var orgID = user.orgID;

    const process_org_stat = await preprocess_Org_fe_pie_chart(orgID)

    return res.status(200).send({
      "Messages": "Successfully Retrieved Organization Food Expense Data",
      "Statistic": process_org_stat
      // "Score List": processed_score_array
    });


  }catch(error){
    return res.status(400).send(`Error when retrieving household food expense pie chart: ${error}`);
  }
})

router.get("/household/visualization/heatmap", authenticateToken, async(req,res) => {
  try{

    var user = await get_user_from_db(req, res);
  
    var h_id = user.hID;

    const output = await preprocess_house_heatmap(h_id)


    return res.status(200).send({
      message: "Successfully get the heatmap for household.",
      Statistic: output
    })
  }catch(error){
    return res.status(400).send(`Error when retrieving household heatmap: ${error}`);
  }
})

router.get("/organization/visualization/heatmap", authenticateToken, async(req,res) => {
  try{

    var user = await get_user_from_db(req, res);
  
    var orgID = user.orgID;

    const output = await preprocess_Org_heatmap(orgID)


    return res.status(200).send({
      message: "Successfully get the heatmap for Organization.",
      Statistic: output
    })
  }catch(error){
    return res.status(400).send(`Error when retrieving Organization heatmap: ${error}`);
  }
})
export default router;

