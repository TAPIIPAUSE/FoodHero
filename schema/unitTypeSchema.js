import mongoose from 'mongoose';
import passportLocalMongoose from 'passport-local-mongoose';
import autoIncrementModelID from './counterSchema.js'; // Adjust path as necessary

const unitTypeSchema = new mongoose.Schema({
    unitId:{
        type: Number,
        unique: true,
        min: 1,
        index: true
    },
    type: {
        type:String,
        unique: true,
        required: true
    }
})

unitTypeSchema.plugin(passportLocalMongoose);

// https://techinsights.manisuec.com/mongodb/mongoose-pre-and-post-hooks-middlewares/#:~:text=Pre%20and%20post%20middleware%20hooks%20is%20a%20very%20useful%20feature,particular%20action%20that%20you%20specify.

unitTypeSchema.pre('save', async function (next) {
  if (this.isNew) {
    try {
      console.log("This is the id before autoIncrement", this.unitId)
      await autoIncrementModelID('UnitType', this);
      console.log("This is the id after autoIncrement:", this.unitId);
      console.log("This is the body of User after autoIncrement", this)
      next();
    } catch (error) {
      next(error);
    }
  } else {
    next();
  }
});

const UnitType = mongoose.model('UnitType', unitTypeSchema);

export default UnitType;