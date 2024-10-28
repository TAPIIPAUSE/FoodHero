import PersonalScore from "../schema/score_module/PersonalScoreSchema.js"

export async function preprocess_Org_fs_pie_chart(orgID){
    const org_stat = await PersonalScore.find({orgID: orgID})

      var processed_org_member = org_stat.map(member => {

      return {"Lost": Number(member.Waste),
        "Consume": Number(member.Consume)}
      })

      var total_waste = 0;
      var total_consume = 0;

      processed_org_member.map(m => {
        total_waste = total_waste + m.Waste
        total_consume = total_consume + m.Consume
      })

      const total_food = total_consume + total_waste

      const percent_consume = (total_consume/total_food)*100
      const percent_waste = (total_waste/total_food)*100

      return {
        "Waste": total_waste,
        "Consume": total_consume,
        "Total": total_food,
        "Percent_Consume": Number(percent_consume.toFixed(2)),
        "Percent_Waste": Number(percent_waste.toFixed(2))
      }
}

export async function preprocess_House_fs_pie_chart(h_ID){
    const house_stat = await PersonalScore.find({hID: h_ID})

      var processed_h_member = house_stat.map(member => {

      return { "Waste": Number(member.Waste),
        "Consume": Number(member.Consume)}
      })

      var total_waste = 0;
      var total_consume = 0;

      processed_h_member.map(m => {
        total_waste = total_waste + m.Waste
        total_consume = total_consume + m.Consume
      })

      const total_food = total_consume + total_waste

      const percent_consume = (total_consume/total_food)*100
      const percent_waste = (total_waste/total_food)*100



      return {
        "Waste": total_waste,
        "Consume": total_consume,
        "Total": total_food,
        "Percent_Consume": Number(percent_consume.toFixed(2)),
        "Percent_Waste": Number(percent_waste.toFixed(2))
      }
}

export async function preprocess_House_foodtype_pie_chart(h_ID){
  const house_stat = await PersonalScore.find({hID: h_ID})

    var processed_h_member = house_stat.map(member => {

    return { 
      "Total":Number(member.Waste) + Number(member.Consume),
      "Waste": Number(member.Waste),
      "Consume": Number(member.Consume),
      "Category": Number(member.FoodType)}
    })

    

    const result = processed_h_member.reduce((acc, item) => {
      const { Category, Waste, Consume, Total } = item;
    
      // Check if the category is already in the accumulator
      if (!acc[Category]) {
        acc[Category] = { Category, TotalWaste: 0 ,TotalConsume: 0 ,TotallyTotal: 0 ,};
      }
    
      // Sum up the waste for each category
      acc[Category].TotalWaste += Waste;
      acc[Category].TotalConsume += Consume;
      acc[Category].TotallyTotal += Total;

    
      return acc;
    }, {});

    const resultArray = Object.values(result);

    

    // console.log(result)
    var totalOfConsumption = 0;

    resultArray.map(item => {
      totalOfConsumption = totalOfConsumption + item.TotalConsume
    })
    

    const output = resultArray.map(category => {
      const percent = (category.TotalConsume/totalOfConsumption)*100
      return{
        Category: category.Category,
        Waste: category.TotalWaste,
        Consume: category.TotalConsume,
        Total: category.TotallyTotal,
        Percent: Number(percent.toFixed(2))
      }
    })



    return output
}

export async function preprocess_org_foodtype_pie_chart(orgID){
  const org_stat = await PersonalScore.find({orgID: orgID})

    var processed_h_member = org_stat.map(member => {

    return { 
      "Total":Number(member.Waste) + Number(member.Consume),
      "Waste": Number(member.Waste),
      "Consume": Number(member.Consume),
      "Category": Number(member.FoodType)}
    })

    

    const result = processed_h_member.reduce((acc, item) => {
      const { Category, Waste, Consume, Total } = item;
    
      // Check if the category is already in the accumulator
      if (!acc[Category]) {
        acc[Category] = { Category, TotalWaste: 0 ,TotalConsume: 0 ,TotallyTotal: 0 ,};
      }
    
      // Sum up the waste for each category
      acc[Category].TotalWaste += Waste;
      acc[Category].TotalConsume += Consume;
      acc[Category].TotallyTotal += Total;

    
      return acc;
    }, {});
    const resultArray = Object.values(result);
    
    // console.log(result)
    var totalOfConsumption = 0;

    resultArray.map(item => {
      totalOfConsumption = totalOfConsumption + item.TotalConsume
    })
    

    const output = resultArray.map(category => {
      const percent = (category.TotalConsume/totalOfConsumption)*100
      return{
        Category: category.Category,
        Waste: category.TotalWaste,
        Consume: category.TotalConsume,
        Total: category.TotallyTotal,
        Percent: Number(percent.toFixed(2))
      }
    })



    return output
}

export async function preprocess_House_fe_pie_chart(h_ID){
  const house_stat = await PersonalScore.find({hID: h_ID})

    var processed_h_member = house_stat.map(member => {

    return { "Saved": Number(member.Saved),
      "Lost": Number(member.Lost)}
    })

    console.log(processed_h_member)

    var total_lost = 0;
    var total_saved = 0;

    processed_h_member.map(m => {
      total_lost = total_lost + m.Lost
      total_saved = total_saved + m.Saved
    })

    const total_food = total_saved + total_lost

    const percent_saved = (total_saved/total_food)*100
    const percent_lost = (total_lost/total_food)*100



    return {
      "Lost": total_lost,
      "Saved": total_saved,
      "Total": total_food,
      "Percent_Saved": Number(percent_saved.toFixed(2)),
      "Percent_Lost": Number(percent_lost.toFixed(2))
    }
}

export async function preprocess_Org_fe_pie_chart(org_ID){
  const org_stat = await PersonalScore.find({orgID: org_ID})

    var processed_org_member = org_stat.map(member => {

    return { "Saved": Number(member.Saved),
      "Lost": Number(member.Lost)}
    })

    console.log(processed_org_member)

    var total_lost = 0;
    var total_saved = 0;

    processed_org_member.map(m => {
      total_lost = total_lost + m.Lost
      total_saved = total_saved + m.Saved
    })

    const total_food = total_saved + total_lost

    const percent_saved = (total_saved/total_food)*100
    const percent_lost = (total_lost/total_food)*100



    return {
      "Lost": total_lost,
      "Saved": total_saved,
      "Total": total_food,
      "Percent_Saved": Number(percent_saved.toFixed(2)),
      "Percent_Lost": Number(percent_lost.toFixed(2))
    }
}

export async function monthly_house(hID) {
  const monthData = [];
  const today = new Date();
  
  // Get the first and last day of the current month
  const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
  const endOfMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);

  // Loop from the 1st to the last day of the current month
  for (let day = new Date(startOfMonth); day <= endOfMonth; day.setDate(day.getDate() + 1)) {
    const startOfDay = new Date(day);
    startOfDay.setHours(0, 0, 0, 0);

    const endOfDay = new Date(day);
    endOfDay.setHours(23, 59, 59, 999);

    // Query the Food collection for entries created on the specific day
    const dailyFood = await PersonalScore.find({
      hID: hID,
      createdAt: { $gte: startOfDay, $lte: endOfDay }
    });

    monthData.push({
      date: startOfDay.toDateString(),
      items: dailyFood
    });
  }

  return monthData;
}


export async function preprocess_house_heatmap(hID){
  const weekly_list = await monthly_house(hID)

  const output = weekly_list.map(item => {
      
      var waste_acc = 0
      var total = 0
      item.items.map( i => {
          waste_acc = waste_acc + Number(i.Consume)
          total = total + Number(i.Consume) + Number(i.Waste)
      })

      const result = (waste_acc && total) ? ((waste_acc / total) * 100).toFixed(2) : "0.00";


      return {
          Date: item.date,
          Waste: waste_acc,
          Total: total,
          Percent_Waste: Number(result)
      }
  })
  return output
}

export async function monthly_org(orgID) {
  const monthData = [];
  const today = new Date();
  
  // Get the first and last day of the current month
  const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
  const endOfMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);

  // Loop from the 1st to the last day of the current month
  for (let day = new Date(startOfMonth); day <= endOfMonth; day.setDate(day.getDate() + 1)) {
    const startOfDay = new Date(day);
    startOfDay.setHours(0, 0, 0, 0);

    const endOfDay = new Date(day);
    endOfDay.setHours(23, 59, 59, 999);

    // Query the Food collection for entries created on the specific day
    const dailyFood = await PersonalScore.find({
      orgID: orgID,
      createdAt: { $gte: startOfDay, $lte: endOfDay }
    });

    monthData.push({
      date: startOfDay.toDateString(),
      items: dailyFood
    });
  }

  return monthData;
}

export async function preprocess_Org_heatmap(orgID){
  const monthly_list = await monthly_org(orgID)

  const output = monthly_list.map(item => {
      
      var waste_acc = 0
      var total = 0
      item.items.map( i => {
          waste_acc = waste_acc + Number(i.Consume)
          total = total + Number(i.Consume) + Number(i.Waste)
      })

      const result = (waste_acc && total) ? ((waste_acc / total) * 100).toFixed(2) : "0.00";


      return {
          Date: item.date,
          Waste: waste_acc,
          Total: total,
          Percent_Waste: Number(result)
      }
  })
  return output
}