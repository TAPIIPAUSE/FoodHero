import mongoose from 'mongoose';
import passportLocalMongoose from 'passport-local-mongoose';
import autoIncrementModelID from '../counterSchema.js'; // Adjust path as necessary

const consumedFoodSchema = new mongoose.Schema({
    assigned_ID: { type: Number, unique: true, min: 1},
    food_ID: {type:Number, required: true},
    user_ID: {type: Number, required: true, min: 1},
    h_ID: {type: Number, required: true, min: 1},
    current_amount: {type: mongoose.Schema.Types.Decimal128, required: true},
    current_quantity: {type: mongoose.Schema.Types.Decimal128, required: true, default: 0,set: (v) => v === null ? 0 : v},
    saved: {type: mongoose.Schema.Types.Decimal128, required: true, default: 0},
    lost: {type: mongoose.Schema.Types.Decimal128, required: true, default: 0},
    consumed: {type: mongoose.Schema.Types.Decimal128, required: true, default: 0},
    wasted: {type: mongoose.Schema.Types.Decimal128, required: true, default: 0},
    score: {type: mongoose.Schema.Types.Decimal128, required: true, default: 0},
    createdAt: { type: Date, default: Date.now , unique: false},
    modifiedAt: { type: Date , unique: false},
})

// consumedFoodSchema.plugin(passportLocalMongoose, { 
//     usernameField: false,
//     selectFields: [] // This disables the addition of the default username field
//   })

var consumed = false

consumedFoodSchema.pre('save', async function (next) {
    try{
        await autoIncrementModelID('ConsumedFood', this);
        consumed = true
        next()
    } catch(error){
        next(error)
    }
})

consumedFoodSchema.post('save', function (next) {
    console.log("Saved Successfully")
    console.log("Here is the result of your registration", this)
    return true
  })

const ConsumedFood = mongoose.model('ConsumedFood', consumedFoodSchema);

export default ConsumedFood;