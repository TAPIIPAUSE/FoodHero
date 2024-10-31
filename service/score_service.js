import UnitType from "../schema/inventory_module/unitTypeSchema.js";
import User from "../schema/user_module/userSchema.js";
import Food from "../schema/inventory_module/foodInventorySchema.js";
import HouseholdScore from "../schema/score_module/HouseholdScoreSchema.js";
import OrganizationScore from "../schema/score_module/OrganizationScoreSchema.js"
import House from "../schema/user_module/houseSchema.js";
import Organization from "../schema/user_module/organizationSchema.js";

export async function calculateScore(totalAmount, consumedPercen, weightType) {
    try {
        var consumedAmount = (consumedPercen/100) * totalAmount
        var {totalAmount:convertedTotalAmount, consumedAmount:convertedCurrentAmount} = await unitConverter(weightType,totalAmount,consumedAmount)
        // Calculate the score
        let score;
        if (convertedTotalAmount > 1000) {
            if (consumedPercen >= 90) {
                score = consumedPercen / 100 * 5;
            } else if (consumedPercen >= 70) {
                score = consumedPercen / 100 * 3;
            } else {
                score = (100 - consumedPercen) / 100 * -5;
            }
        } else {
            if (consumedPercen >= 80) {
                score = consumedPercen / 100 * 2;
            } else {
                score = (100 - consumedPercen) / 100 * -2;
            }
        }

        if (Object.is(score, -0) || Math.abs(score) < Number.EPSILON) {
            score = 0;
        }

        return score;
    } catch (error) {
        console.error('Error calculating score:', error);
        throw error
        return 0; // Default score in case of error
    }
}

export async function update_scoretoDB(userID, score) {
    try {
        // Find the user by userID
        const user = await User.findOne({ assigned_ID: userID });
        if (!user) {
            throw new Error('User not found');
        }

        // Update the user's score
        user.score = score;
        await user.save();

        return score;
    } catch (error) {
        console.error('Error updating score:', error);
        return 0; // Default score in case of error
    }

}

export async function getAmountInGrams(food) {

        // Prepare the variable
        var totalAmount, currentAmount = await unitConverter(food.type, food.total_amount, food.current_amount)

    return totalAmount, currentAmount
}

// This function would 1)Preprocess variety of units into single Grams unit. 2)Return total amount and current amount, ready for calculating the score
export async function unitConverter(type,totalAmount,consumedAmount) {
    const unitType = await UnitType.findOne({ assigned_ID: type });
    if (!unitType) {
        throw new Error('Unit type not found');
    }


    // Convert the food weight to grams
    
    switch (unitType.type) {
        case "Litre":
            totalAmount *= 1000;
            consumedAmount *= 1000;
            break;
        case "Ml":
            // No conversion here, we assume Ml is equivalent to gram
            break;
        case "Kg":
            totalAmount *= 1000;
            consumedAmount *= 1000;
            break;
        case "Gram":
            // No conversion needed
            break;
        default:
            throw new Error('Unknown unit type');
    }


    return {totalAmount,consumedAmount}
}

export async function calculateSaveLost(food, percent){
    const c_a = parseFloat(food.current_amount)
    const t_a = parseFloat(food.total_amount)
    const t_p = parseFloat(food.total_price)
    
    const saved = (t_p*((c_a*(percent/100))/t_a))
    const lost = (t_p*((c_a*((100 - percent)/100))/t_a))

    return {saved,lost}
}

export async function calculateSaveLostForConsume(food,consume, percent){
    const c_a = parseFloat(consume.current_amount)
    const t_a = parseFloat(food.total_amount)
    const t_p = parseFloat(food.total_price)
    console.log("c_a:", c_a)
    console.log("t_a:", t_a)
    console.log("t_p:", t_p)
    
    const saved = (t_p*((c_a*(percent/100)))/t_a)
    const lost = (t_p*((c_a*((100 - percent)/100))/t_a))

    return {saved,lost}
}

export async function preprocess_House_Score(h_ID){
    const house_member = await User.find({hID: h_ID})

      var processed_h_member = house_member.map(member => member.assigned_ID)

      // Get score from HouseScore Table
      const score_array = await Promise.all(
        processed_h_member.map(async (food) => {
          const score_individual = await HouseholdScore.find({userID: food})
          return score_individual;
        })
      );
      

      const processed_score_array = score_array.map(person_score => {
        var acc = 0;
        const acc_person_score = person_score.map(i_score=>{
          acc += parseFloat(i_score.Score)
        })
        return parseFloat(acc.toFixed(2))
        
      })

      const member = await get_House_Member(h_ID);

      const combined = member.map((m, index) => {
        return { "Rank": null ,"Username": m, "Score": processed_score_array[index] !== undefined ? processed_score_array[index] : 0 };
      });

      combined.sort((a, b) => b.Score - a.Score);

      for (let i = 1; i <= combined.length; i++) {
        combined[i-1].Rank = i
      }    

      

      return combined
}

export async function get_House_Member(hID){
    const member = await User.find({hID: hID})
    
    const member_name = member.map(m => {
        return m.username
    })
    
    return member_name
}

export async function preprocess_Org_Score(org_ID){
    const org_member = await OrganizationScore.find({orgID: org_ID})

      var processed_in_org_score = org_member.map(member => member.hID)

      const uniqueHouse = [...new Set(processed_in_org_score)];

      // Get score from HouseScore Table
      const score_array = await Promise.all(
        uniqueHouse.map(async (user) => {
          const score_individual = await OrganizationScore.find({hID: user})
          return score_individual;
        })
      );

    
      

      const processed_score_array = score_array.map(house_score => {
        var acc = 0;
        const acc_person_score = house_score.map(i_score=>{
          acc += parseFloat(i_score.Score)
        })
        return parseFloat(acc.toFixed(2))
        
      })

    //   In organization View, user will be seeing the housename instead, not username
    // IMPORTANT!!!
      const member = await get_Org_Member(org_ID);
      console.log(processed_score_array)
      const combined = member.map((m, index) => {
        return { 
          "Rank": null ,
          "Housename": m,
          "Score": processed_score_array[index] !== undefined ? processed_score_array[index] : 0};
      });

      combined.sort((a, b) => b.Score - a.Score);

      for (let i = 1; i <= combined.length; i++) {
        combined[i-1].Rank = i
      }    

      

      return combined
}


export async function get_Org_Member(orgID){
    const member = await House.find({org_ID: orgID})
    
    const member_name = member.map(m => {
        return m.house_name
    })
    

    console.log(member_name)
    return member_name
}

export async function preprocess_interOrg_Score(){
    const org_list = await OrganizationScore.find()

      var processed_in_org_score = org_list.map(member => member.orgID)

      const uniqueOrg = [...new Set(processed_in_org_score)];

      

      // Get score from HouseScore Table
      const score_array = await Promise.all(
        uniqueOrg.map(async (user) => {
          const score_individual = await OrganizationScore.find({orgID: user})
          return score_individual;
        })
      );
      

      const processed_score_array = score_array.map(house_score => {
        var acc = 0;
        house_score.map(i_score=>{
          acc += parseFloat(i_score.Score)
        })
        return parseFloat(acc.toFixed(2))
        
      })

      console.log(processed_score_array)

    //   In organization View, user will be seeing the housename instead, not username
    // IMPORTANT!!!
      const member = await get_allOrg(uniqueOrg)

      const combined = member.map((m, index) => {
        return { "Rank": null ,"Orgname": m, "Score":processed_score_array[index] !== undefined ? processed_score_array[index] : 0 };
      });

      combined.sort((a, b) => b.Score - a.Score);

      for (let i = 1; i <= combined.length; i++) {
        combined[i-1].Rank = i
      }    

      

      return combined
}

export async function get_allOrg(orgID_list){

    const org_name_list = await Promise.all(
        orgID_list.map(async org_ID => {
          const member = await Organization.findOne({ assigned_ID: org_ID });
          return member.org_name; // or return member.org_name if you want the name specifically
        })
      );
      

    
    return org_name_list
}