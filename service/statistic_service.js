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
        
        var acc = 0
        item.items.map( i => {
            acc = acc + Number(i.Consume)
        })
        return {
            Date: item.date,
            Statistic: acc
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
        
        var acc = 0
        item.items.map( i => {
            acc = acc + Number(i.Consume)
        })
        return {
            Date: item.date,
            Statistic: acc
        }
    })

    return output
  }