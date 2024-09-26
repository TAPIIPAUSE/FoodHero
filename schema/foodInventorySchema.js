import mongoose from 'mongoose';
import passportLocalMongoose from 'passport-local-mongoose';
import autoIncrementModelID from './counterSchema.js'; // Adjust path as necessary

const foodInventorySchema = new mongoose.Schema({
    hID: {type:Number,required: true, min:1},
    assigned_ID: { type: Number, unique: true, min: 1},
    food_name: {type: String, required: true},
    food_category: {type: Number, required: true},
    unit_type: {type: Number, required: true},
    current_amount: {type: mongoose.Schema.Types.Decimal128, required: true},
    total_amount: {type: mongoose.Schema.Types.Decimal128, required: true},
    total_price: {type: mongoose.Schema.Types.Decimal128, required: true},
    bestByDate: {type: Date, required: true},
    createdAt: { type: Date, default: Date.now , unique: false},
    modifiedAt: { type: Date , unique: false},
})

foodInventorySchema.plugin(passportLocalMongoose, { 
    usernameField: false,
    selectFields: [] // This disables the addition of the default username field
  })

var newFood = false

foodInventorySchema.pre('save', async function (next) {
    try{
        await autoIncrementModelID('Food', this);
        newFood = true
        next()
    } catch(error){
        next(error)
    }
})

foodInventorySchema.post('save', function (next) {
    console.log("Saved Successfully")
    console.log("Here is the result of your registration", this)
    return true
  })

const Food = mongoose.model('Food', foodInventorySchema);

export default Food;