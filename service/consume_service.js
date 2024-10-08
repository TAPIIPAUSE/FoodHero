import Food from "../schema/inventory_module/foodInventorySchema.js";
import PackageUnitType from "../schema/inventory_module/packageTypeSchema.js";
import UnitType from "../schema/inventory_module/unitTypeSchema.js";


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