import Food from "../schema/inventory_module/foodInventorySchema.js";
import Location from "../schema/inventory_module/locationSchema.js";
import PackageUnitType from "../schema/inventory_module/packageTypeSchema.js";
import UnitType from "../schema/inventory_module/unitTypeSchema.js";
import HouseholdScore from "../schema/score_module/HouseholdScoreSchema.js";
import OrganizationScore from "../schema/score_module/OrganizationScoreSchema.js"


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
      "URL": food.img,
      "isCountable": food.isCountable
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

export async function mapAmountQuan(id){
  try{
    const food  = await Food.findOne({assigned_ID: id})

    const t_a = parseFloat(food.total_amount)
    const t_p = parseFloat(food.total_price)
    const t_q = parseFloat(food.total_quanitity)
    const c_a = parseFloat(food.current_amount)
    const c_q = parseFloat(food.current_quantity)
    const consumed_a = parseFloat(food.consumed_amount)
    const consumed_q = parseFloat(food.consumed_quantity)

    return {t_a,t_q, t_p,c_a,c_q,consumed_a, consumed_q}

  }catch (error){
    throw error
  }
}

// This function is designed only for Complete Consume
export async function calculateCompleteConsumedData(consumedPercent,food){

  var act_consumed_amount = (consumedPercent/100) * food.current_amount
  var act_consumed_quan = (consumedPercent/100) * food.current_quantity

  var current_amount = parseFloat(food.current_amount) - parseFloat(act_consumed_amount)
  var current_quan = parseFloat(food.current_quantity) - parseFloat(act_consumed_quan)
  var consume_amount = parseFloat(food.consumed_amount) + parseFloat(act_consumed_amount)
  var consume_quan = parseFloat(food.consumed_quantity) + parseFloat(act_consumed_quan)

  return {current_amount, current_quan, consume_amount, consume_quan}

}

// This function is designed only for Complete Consume
export async function calculateCompleteWasteData(consumedPercent,food){

  var act_consumed_amount = food.current_amount
  var act_consumed_quan = food.current_quantity

  var current_amount = parseFloat(food.current_amount) - parseFloat(act_consumed_amount)
  var current_quan = parseFloat(food.current_quantity) - parseFloat(act_consumed_quan)
  var consume_amount = parseFloat(food.consumed_amount) 
  var consume_quan = parseFloat(food.consumed_quantity) 

  console.log("current_amount:", current_amount)
  console.log("current_quan:", current_quan)
  console.log("consume_amount:", consume_amount)
  console.log("consume_quan:", consume_quan)
  return {current_amount, current_quan, consume_amount, consume_quan}

}
// This function is designed only for Confirm Consumption, Complete Consume will be calculated differently
export async function calculateConsumedData(consumedPercent,consumed){

  var act_consumed_amount = (consumedPercent/100) * consumed.current_amount
  var act_consumed_quan = (consumedPercent/100) * consumed.current_quantity

  var current_amount = parseFloat(consumed.current_amount) - parseFloat(act_consumed_amount)
  var current_quan = parseFloat(consumed.current_quantity) - parseFloat(act_consumed_quan)

  return {current_amount, current_quan}

}

export async function updateConsume(food,cur_amount,cur_quan,con_a,con_quan){
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
    "orgID": user.orgID,
    "hID": user.hID,
    "Score": per_org_capita
  })

  await OrganizationObject.save()
}