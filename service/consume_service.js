import ConsumedFood from "../schema/inventory_module/consumedFoodSchema.js";
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
    
    var food = await Food.findOne({ assigned_ID: fID })
    var consumed_food = await ConsumedFood.findOne({ assigned_ID: cID })
    var location = await Location.findOne({assigned_ID: food.location})
    var unit = await UnitType.findOne({assigned_ID: food.weight_type})
   
    var food_name = food.food_name
    var location = location.location
 
    if(food.isCountable){
      var package_id = food.package_type
      var package_type = await mapPackageType(package_id)

      return {
        FoodName: food_name,
        QuantityMessage: `${consumed_food.current_quantity} ${package_type}${consumed_food.current_quantity > 1 ? "s" : ""}`,
        Package: package_type,
        Location: location
      }
    }else{

      return {
        FoodName: food_name,
        AmountMessage: `${consumed_food.current_amount} ${unit.type}${consumed_food.current_amount > 1 ? "s" : ""}`,
        Unit: unit,
        Location: location
      }
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

  const waste = current_amount
  const consumed = parseFloat(food.current_amount) - current_amount

  return {current_amount, current_quan, consume_amount, consume_quan, waste, consumed}

}

// This function is designed only for Complete Consume
export async function calculateCompleteWasteData(consumedPercent,food){

  var act_consumed_amount = food.current_amount
  var act_consumed_quan = food.current_quantity

  var current_amount = parseFloat(food.current_amount) - parseFloat(act_consumed_amount)
  var current_quan = parseFloat(food.current_quantity) - parseFloat(act_consumed_quan)
  var consume_amount = parseFloat(food.consumed_amount) 
  var consume_quan = parseFloat(food.consumed_quantity) 

  const waste = act_consumed_amount
  const consumed = 0


  return {current_amount, current_quan, consume_amount, consume_quan, waste, consumed}

}
// This function is designed only for Confirm Consumption, Complete Consume will be calculated differently
export async function calculateConsumedData(consumedPercent,consumed){

  var act_consumed_amount = (consumedPercent/100) * consumed.current_amount
  var act_consumed_quan = (consumedPercent/100) * consumed.current_quantity

  var current_amount = parseFloat(consumed.current_amount) - parseFloat(act_consumed_amount)
  var current_quan = parseFloat(consumed.current_quantity) - parseFloat(act_consumed_quan)

  // console.log("Actual Consumed Amount:", act_consumed_amount)
  // console.log("Actual Consumed Quantity:", act_consumed_quan)
  // console.log("Current Amount:", current_amount)
  // console.log("Current Quantity:", current_quan)
  return {current_amount, current_quan,act_consumed_amount,act_consumed_quan}

}

export async function updateConsume(cID,food,cur_amount,cur_quan,con_a,con_quan){
  try{
    
    await Food.updateOne(
      { assigned_ID: food.assigned_ID }, // Filter by assigned_ID
      {
        $set: {
          consumed_amount: Number(food.consumed_amount) - con_a - cur_amount,
          consumed_quantity: Number(food.consumed_quantity) - con_quan - cur_quan,
        },
      }
    );

    await ConsumedFood.updateOne(
      { assigned_ID: cID }, // Filter by assigned_ID
      {
        $set: {
          current_amount: 0,
          current_quantity: 0
        },
      }
    );
  }catch (error){
    console.log("Error updating food inventory when consuming:", error)
    throw error
  }

}

export async function updateCompleteConsume(food){
  try{
    
    await Food.updateOne(
      { assigned_ID: food.assigned_ID }, // Filter by assigned_ID
      {
        $set: {
          current_amount: 0,
          current_quantity: 0
        },
      }
    );

  }catch (error){
    console.log("Error updating food inventory when consuming:", error)
    throw error
  }

}

export async function updateCompleteWaste(food){
  try{
    
    await Food.updateOne(
      { assigned_ID: food.assigned_ID }, // Filter by assigned_ID
      {
        $set: {
          current_amount: 0,
          current_quantity: 0
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