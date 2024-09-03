import mongoose from 'mongoose';
import passportLocalMongoose from 'passport-local-mongoose';
import autoIncrementModelID from './counterSchema.js'; // Adjust path as necessary

const foodInventorySchema = new mongoose.Schema({
    hID: {type:Number, unique: true, required: true, min:1},
    assigned_ID: { type: Number, unique: true, min: 1 , index: true},
    food_name: {type: String, required: true},
    food_category: {type: String, required: true},
    unit_type: {type: String, required: true},
    current_amount: {type: mongoose.Schema.Types.Decimal128, required: true, unique: true},
    total_amount: {type: mongoose.Schema.Types.Decimal128, required: true, unique: true},
    total_price: {type: mongoose.Schema.Types.Decimal128, required: true, unique: true},
    createdAt: { type: Date, required: true, unique: false},
    createdAt: { type: Date, default: Date.now , unique: false},
    modifiedAt: { type: Date , unique: false},
})

foodInventorySchema.plugin(passportLocalMongoose)

var newOrg = false

foodInventorySchema.pre('save', async function (next) {
    if(this.isNew){
        try{
            await autoIncrementModelID('Organization', this);
            newOrg = true
            next()
        } catch(error){
            next(error)
        }
        
        
    }else{
        console.log("This organization's name has been used already!")
        next()
    }
})

foodInventorySchema.post('save', function (next) {
    console.log("Saved Successfully")
    console.log("Here is the result of your registration", this)
    return true
  })

const Organization = mongoose.model('Organization', foodInventorySchema);

export default Organization;