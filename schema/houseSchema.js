import mongoose from 'mongoose';
import passportLocalMongoose from 'passport-local-mongoose';
import autoIncrementModelID from './counterSchema.js'; // Adjust path as necessary

const houseSchema = new mongoose.Schema({
    assigned_ID: { type: Number, unique: true, min: 1 , index: true},
    org_ID: {type:Number, default: 0},
    house_name: {type: String, required: true, unique: true},
    createdAt: { type: Date, default: Date.now , unique: false},
    modifiedAt: { type: Date , unique: false},
})

houseSchema.plugin(passportLocalMongoose)

var newHouse = false

houseSchema.pre('save', async function (next) {
    if(this.isNew){
        try{
            await autoIncrementModelID('House', this);
            newHouse = true
            next()
        } catch(error){
            next(error)
        }
        
        
    }else{
        console.log("This household's name has been used already!")
        next()
    }
})

houseSchema.post('save', function (next) {
    console.log("Saved Successfully")
    console.log("Here is the result of your registration", this)
    return true
  })

const House = mongoose.model('House', houseSchema);

export default House;