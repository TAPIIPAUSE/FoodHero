import PersonalScore from "../schema/score_module/PersonalScoreSchema.js"

export async function preprocess_Org_fs_pie_chart(orgID){
    const org_stat = await PersonalScore.find({orgID: orgID})

      var processed_org_member = org_stat.map(member => {

      return { "Waste": Number(member.Waste),
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