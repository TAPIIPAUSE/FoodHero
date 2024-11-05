import Food from "../schema/inventory_module/foodInventorySchema.js";
import PersonalScore from "../schema/score_module/PersonalScoreSchema.js";

  export async function weekly_fs_house_score(hID) {
    const pastWeekData = [];
  
    for (let i = 0; i < 7; i++) {
      const startOfDay = new Date();
      startOfDay.setDate(startOfDay.getDate() - i);
      startOfDay.setHours(0, 0, 0, 0);
  
      const endOfDay = new Date(startOfDay);
      endOfDay.setHours(23, 59, 59, 999);
  
      // Query the Food collection for entries created on the specific day
      const dailyFood = await PersonalScore.find({
        hID: hID,
        createdAt: { $gte: startOfDay, $lte: endOfDay }
      });
  
      pastWeekData.push({
        date: startOfDay.toDateString(),
        items: dailyFood
      });
    }
  
    return pastWeekData;
  }

  export async function preprocess_house_barchart(hID){
    const weekly_list = await weekly_fs_house_score(hID)

    const output = weekly_list.map(item => {
        
        var con_acc = 0
        var total = 0
        item.items.map( i => {
            con_acc = con_acc + Number(i.Consume)
            total = total + Number(i.Consume) + Number(i.Waste)
        })

        var waste_acc = total - con_acc

        const consume_result = (con_acc && total) ? ((con_acc / total) * 100).toFixed(2) : "0.00";
        const waste_result = (waste_acc && total) ? ((waste_acc / total) * 100).toFixed(2) : "0.00";


        return {
            Date: item.date,
            Consume: con_acc,
            Wasted: total - con_acc,
            Total: total,
            consumePercent: Number(consume_result),
            wastePercent: Number(waste_result)
        }
    })
    return output
  }

  export async function weekly_fs_org_score(orgID) {
    const pastWeekData = [];
  
    for (let i = 0; i < 7; i++) {
      const startOfDay = new Date();
      startOfDay.setDate(startOfDay.getDate() - i);
      startOfDay.setHours(0, 0, 0, 0);
  
      const endOfDay = new Date(startOfDay);
      endOfDay.setHours(23, 59, 59, 999);
  
      // Query the Food collection for entries created on the specific day
      const dailyFood = await PersonalScore.find({
        orgID: orgID,
        createdAt: { $gte: startOfDay, $lte: endOfDay }
      });
  
      pastWeekData.push({
        date: startOfDay.toDateString(),
        items: dailyFood
      });
    }
  
    return pastWeekData;
  }

  export async function preprocess_org_barchart(orgID){
    const weekly_list = await weekly_fs_org_score(orgID)

    const output = weekly_list.map(item => {
        
        var con_acc = 0
        var total = 0
        item.items.map( i => {
            con_acc = con_acc + Number(i.Consume)
            total = total + Number(i.Consume) + Number(i.Waste)
        })


        var waste_acc = total - con_acc

        const consume_result = (con_acc && total) ? ((con_acc / total) * 100).toFixed(2) : "0.00";
        const waste_result = (waste_acc && total) ? ((waste_acc / total) * 100).toFixed(2) : "0.00";

        return {
            Date: item.date,
            Consume: con_acc,
            Wasted: total - con_acc,
            Total: total,
            consumePercent: Number(consume_result),
            wastePercent: Number(waste_result)
        }
    })

    return output
  }