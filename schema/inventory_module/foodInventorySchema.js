import mongoose from 'mongoose';
import passportLocalMongoose from 'passport-local-mongoose';
import autoIncrementModelID from '../counterSchema.js'; // Adjust path as necessary

const foodInventorySchema = new mongoose.Schema({
    hID: {type:Number,required: true, min:1},
    assigned_ID: { type: Number, unique: true, min: 1},
    img: {type: String, required: false, default: ""},
    food_name: {type: String, required: true},
    location: {type: Number, required: true},
    food_category: {type: Number, required: true},
    weight_type: {type: Number, required: true},
    package_type: {type: Number, required: true, default: 0,set: (v) => v === null ? 0 : v},
    isCountable: {type: Boolean, required: true},
    current_amount: {type: mongoose.Schema.Types.Decimal128, required: true,set: (v) => v === null ? 0 : v},
    total_amount: {type: mongoose.Schema.Types.Decimal128, required: true},
    consumed_amount: {type: mongoose.Schema.Types.Decimal128, required: true, default: 0.0,set: (v) => v === null ? 0 : v},
    current_quantity: {type: mongoose.Schema.Types.Decimal128, required: true, default: 0,set: (v) => v === null ? 0 : v},
    total_quanitity: {type: mongoose.Schema.Types.Decimal128, required: true, default: 0,set: (v) => v === null ? 0 : v},
    consumed_quantity: {type: mongoose.Schema.Types.Decimal128, required: true, default: 0,set: (v) => v === null ? 0 : v},
    total_price: {type: mongoose.Schema.Types.Decimal128, required: true},
    bestByDate: {type: Date, required: true},
    RemindDate: {type: Date, required: true},
    createdAt: { type: Date, default: Date.now , unique: false},
    modifiedAt: { type: Date , unique: false},
})


var newFood = false

foodInventorySchema.pre('save', async function (next) {
    try{
        if (this.isNew) {
            await autoIncrementModelID('Food', this);
        }
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