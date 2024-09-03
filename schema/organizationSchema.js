import mongoose from 'mongoose';
import passportLocalMongoose from 'passport-local-mongoose';
import autoIncrementModelID from './counterSchema.js'; // Adjust path as necessary

const orgSchema = new mongoose.Schema({
    assigned_ID: { type: Number, unique: true, min: 1 , index: true},
    org_name: {type: String, required: true, unique: true},
    createdAt: { type: Date, default: Date.now , unique: false},
    modifiedAt: { type: Date , unique: false},
})

orgSchema.plugin(passportLocalMongoose)

var newOrg = false

orgSchema.pre('save', async function (next) {
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

orgSchema.post('save', function (next) {
    console.log("Saved Successfully")
    console.log("Here is the result of your registration", this)
    return true
  })

const Organization = mongoose.model('Organization', orgSchema);

export default Organization;