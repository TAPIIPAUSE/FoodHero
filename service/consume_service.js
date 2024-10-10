import Food from "../schema/inventory_module/foodInventorySchema.js";
import Location from "../schema/inventory_module/locationSchema.js";
import PackageUnitType from "../schema/inventory_module/packageTypeSchema.js";
import UnitType from "../schema/inventory_module/unitTypeSchema.js";
import HouseholdScore from "../schema/score_module/HouseholdScoreSchema.js";
import OrganizationScore from "../schema/score_module/OrganizationSchema.js";


export async function getFoodDetailForConsumeInventory(fID, cID) {

  // For Frontend Display Screen 
  // Data Preprocessing steps -> get food data and format it

  try {
    var assigned_ID = fID

    // Get the food item
    var food = await Food.findOne({ assigned_ID })

    var consume_msg = ""
    var remain_msg = ""



    if (food.isCountable) {
      var package_id = food.package_type
      var package_type = await mapPackageType(package_id)

      consume_msg = `${Number(food.consumed_quantity.toString())} ${package_type}${Number(food.consumed_quantity.toString()) > 1 ? (package_type === 'Box' ? 'es' : 's') : ''}`;
      remain_msg = `${Number(food.current_quantity.toString())} ${package_type}${Number(food.current_quantity.toString()) > 1 ? (package_type === 'Box' ? 'es' : 's') : ''}`;

    } else {
      var unit_id = food.weight_type
      var unit_type = await mapUnitType(unit_id)

      consume_msg = `${Number(food.consumed_amount.toString())} ${unit_type}${unit_type === 'Kg' && Number(food.consumed_amount.toString()) > 1 ? 's' : ''}`;
      remain_msg = `${Number(food.current_amount.toString())} ${unit_type}${unit_type === 'Kg' && Number(food.current_amount.toString()) > 1 ? 's' : ''}`;


    }


    return {
      "Consume_ID": cID,
      "Food_ID": fID,
      "FoodName": food.food_name,
      "Expired": food.bestByDate,
      "Consuming": consume_msg,
      "Remaining": remain_msg,
      "URL": food.img
    };



  } catch (error) {
    console.error("Error checking consumed:", error);
    throw error; //
  }
}

export async function getFoodDetailForConsumeDetail(fID,cID){
  try{
    var assigned_ID = fID
    var food = await Food.findOne({ assigned_ID })
    var location = await Location.findOne({assigned_ID: food.location})

    var package_id = food.package_type
    var package_type = await mapPackageType(package_id)

    var food_name = food.food_name
    var location = location.location
    var unit = ""
    var saved_msg = ""
    var lost_msg = ""

    if(food.isCountable){
    
    
    

      
    }

  }catch(error){
    throw error
  }
}


export async function mapPackageType(id) {
  var assigned_ID = id
  var package_type = await PackageUnitType.findOne({ assigned_ID })
  console.log(package_type)
  return package_type.type
}

export async function mapUnitType(id) {
  var assigned_ID = id
  var unit_type = await UnitType.findOne({ assigned_ID })
  console.log(unit_type)
  return unit_type.type
}

export async function calculateConsumedData(consumedPercent,food){

  var act_consumed_amount = (consumedPercent/100) * food.current_amount
  var act_consumed_quan = (consumedPercent/100) * food.current_quantity

  var current_amount = parseFloat(food.current_amount) - parseFloat(act_consumed_amount)
  var current_quan = parseFloat(food.current_quantity) - parseFloat(act_consumed_quan)
  var consume_amount = parseFloat(food.consumed_amount) + parseFloat(act_consumed_amount)
  var consume_quan = parseFloat(food.consumed_quantity) + parseFloat(act_consumed_quan)

  return {current_amount, current_quan, consume_amount, consume_quan}

}

export async function updateCountableConsume(food,cur_amount,cur_quan,con_a,con_quan){
  try{
    await Food.updateOne(
      { assigned_ID: food.assigned_ID }, // Filter by assigned_ID
      {
        $set: {
          current_amount: cur_amount,
          current_quantity: cur_quan,
          consumed_amount: con_a,
          consumed_quantity: con_quan,
        },
      }
    );
  }catch (error){
    console.log("Error updating food inventory when consuming:", error)
    throw error
  }

}

export async function updateHouseScore(user,score, housesize){
  const per_house_capita = score/housesize

  var HouseObject = new HouseholdScore({
    "userID": user.assigned_ID,
    "hID": user.hID,
    "Score": per_house_capita
  })

  await HouseObject.save()
}

export async function updateOrgScore(user,score, orgSize){
  const per_org_capita = score/orgSize

  var OrganizationObject = new OrganizationScore({
    "orgID": user.hID,
    "Score": per_org_capita
  })

  await OrganizationObject.save()
}