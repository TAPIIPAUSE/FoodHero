export async function getFoodDetailForConsumeInventory(fID){

    // For Frontend Display Screen 
    // Data Preprocessing steps -> get food data and format it

    try{
      var assigned_ID = fID

      // Get the food item
      var food = await Food.findOne({assigned_ID})

      if(food.isCountable){
        return {
            "FoodName": food.food_name,
            "Expired": food.bestByDate,
            "Consuming": food.consumed_quantity,
            "Remaining": food.current_quantity
          };
      }else{
        return {
            "FoodName": food.food_name,
            "Expired": food.bestByDate,
            "Consuming": food.consumed_amount,
            "Remaining": food.current_amount
          };
      }


      
    }catch (error){
      console.error("Error checking or saving consumed:", error);
      throw error; //
    }
  }