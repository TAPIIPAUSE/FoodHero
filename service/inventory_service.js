import ConsumedFood from "../schema/inventory_module/consumedFoodSchema.js";
import { mapPackageType, mapUnitType } from "./consume_service.js";
import Food from "../schema/inventory_module/foodInventorySchema.js";
import PackageUnitType from "../schema/inventory_module/packageTypeSchema.js";
import UnitType from "../schema/inventory_module/unitTypeSchema.js";
import Location from "../schema/inventory_module/locationSchema.js";
import FoodType from "../schema/inventory_module/foodTypeSchema.js";

export async function save_consume_to_db(fID, user, retrievedAmount, retrievedQuantity) {
  try {
    // Check if the house already exists in the database
    var newID = 0;

    const newConsumed = new ConsumedFood({
      food_ID: fID,
      user_ID: user.assigned_ID,
      h_ID: user.hID,
      current_amount: retrievedAmount,  // retrievedAmount mapped to current_amount
      current_quantity: retrievedQuantity,  // retrievedQuantity mapped to current_quantity
      saved: 0,  // default or initial value
      lost: 0,   // default or initial value
      consumed: 0,  // default or initial value
      wasted: 0,   // default or initial value
      score: 0,    // default or initial value
    });
    console.log("User assigned_ID:", user.assigned_ID);
    console.log("User hID:", user.hID);

    console.log("This is your new consumed object:", newConsumed);
    var new_consumption = await newConsumed.save();
    newID = new_consumption.assigned_ID;
    return newID; // Indicate that a new consumed was created

  } catch (error) {
    console.error("Error checking or saving consumed:", error);
    throw error; // Re-throw the error to handle it elsewhere if needed
  }
}

export async function getFoodDetailForFoodInventory(fID) {

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
      "Food_ID": fID,
      "FoodName": food.food_name,
      "Expired": food.bestByDate,
      "Consuming": consume_msg,
      "Remaining": remain_msg,
      "URL": food.img,
      "isCountable": food.isCountable,
      "category": food.food_category,
      "location": food.location
    };



  } catch (error) {
    console.error("Error checking Food:", error);
    throw error; //
  }
}

export async function getFoodDetailForFoodDetail(fID) {

  // For Frontend Display Screen 
  // Data Preprocessing steps -> get food data and format it

  try {
    var assigned_ID = fID

    // Get the food item
    var food = await Food.findOne({ assigned_ID })
    const category = await FoodType.findOne({assigned_ID: food.food_category})

    var consume_msg = ""
    var remain_msg = ""
    console.log('This is food detail retrieved from DataBase...', food)
    const isCountable = food.isCountable

    var unit_id = food.weight_type
    var unit_type = await mapUnitType(unit_id)

    var remain_amt_message = ""

    if (food.isCountable) {
      var package_id = food.package_type
      var package_type = await mapPackageType(package_id)

      
      remain_msg = `${Number(food.current_quantity.toString())} ${package_type}${Number(food.current_quantity.toString()) > 1 ? (package_type === 'Box' ? 'es' : 's') : ''}`;
      remain_amt_message = `${Number(food.current_amount.toString())} ${unit_type}${unit_type === 'Kg' && Number(food.current_amount.toString()) > 1 ? 's' : ''}`;
    } else {
     
      remain_msg = `${Number(food.current_amount.toString())} ${unit_type}${unit_type === 'Kg' && Number(food.current_amount.toString()) > 1 ? 's' : ''}`;
      remain_amt_message = ""

    }

    var package_type = await mapPackageType(food.package_type)

    // if(food.package_type){
    //   var package_type = await mapPackageType(food.package_type)
    //   console.log("Food is Countable", package_type)
    // }else{
    //   console.log("Food is uncounatble", food.package_type)
    
    // }

    const location = await getLocationString(food.location)

    const {
      individual_weight: ind_w,
      individual_price: ind_p,
    } = await individualWeightandPrice(food)


    return {
      "Food_ID": fID,
      "FoodName": food.food_name,
      "Category": category.type,
      "Location": location,
      "Expired": food.bestByDate,
      "Remind": food.RemindDate,
      "TotalCost": Number(food.total_price.toString()),
      "IndividualWeight": ind_w,
      "IndividualCost": ind_p,
      "Remaining": remain_msg,
      "Remaining_amount": remain_amt_message,
      "URL": food.img,
      "isCountable": food.isCountable,
      "weightCountable": Number(food.current_amount.toString()),
      "quantityCountable": Number(food.current_quantity.toString()),
      "weightUncountable": Number(food.current_amount.toString()),
      "unit": unit_type,
      "package": package_type
    };



  } catch (error) {
    console.error("Error checking Food:", error);
    throw error; //
  }
}

export async function getLocationString(lID) {
  const location = await Location.findOne({ assigned_ID: lID })
  return location.location
}

export async function individualWeightandPrice(food) {
  const total_weight = Number(food.total_amount)
  const total_price = Number(food.total_price)

  if (food.isCountable) {
    // We need to consider if the food is actually countable
    const total_quan = Number(food.total_quanitity)
    const individual_weight = total_weight / total_quan
    const individual_price = total_price / total_quan

    return {
      individual_weight: individual_weight,
      individual_price: individual_price
    }
  } else {
    return {
      // Reminder that in uncountable food, there is no individual weight/ price, so we can use total amount and price
      individual_weight: total_weight,
      individual_price: total_price
    }
  }
}



