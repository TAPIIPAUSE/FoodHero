import mongoose from 'mongoose';
import passportLocalMongoose from 'passport-local-mongoose';
import autoIncrementModelID from './counterSchema.js'; // Adjust path as necessary



const userSchema = new mongoose.Schema({
  assigned_ID: { type: Number, unique: true, min: 1},
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  orgID: { type: Number, unique: false, default: 0},
  isOrgLead: { type: Boolean , unique: false,default: false},
  hID: { type: Number, unique: false,default: 0},
  isFamilyLead: { type: Boolean , unique: false, default: false},
  createdAt: { type: Date, default: Date.now , unique: false},
  modifiedAt: { type: Date , unique: false}
});

userSchema.plugin(passportLocalMongoose);

// https://techinsights.manisuec.com/mongodb/mongoose-pre-and-post-hooks-middlewares/#:~:text=Pre%20and%20post%20middleware%20hooks%20is%20a%20very%20useful%20feature,particular%20action%20that%20you%20specify.

userSchema.pre('save', async function (next) {
  if (this.isNew) {
    try {
      console.log("This is the id before autoIncrement", this.assigned_ID)
      await autoIncrementModelID('User', this);
      console.log("This is the id after autoIncrement:", this.assigned_ID);
      console.log("This is the body of User after autoIncrement", this)
      next();
    } catch (error) {
      next(error);
    }
  } else {
    next();
  }
});

userSchema.post('save', function (next) {
  console.log("Saved Successfully")
  console.log("Here is the result of your registration", this)
})

const User = mongoose.model('User', userSchema);

export default User;
