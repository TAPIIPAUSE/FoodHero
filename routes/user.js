// import express from 'express';
import bcrypt from 'bcryptjs';
import User from '../schema/userSchema.js'; // Adjust the import path according to your project structure
import express from "express";
import jwt from 'jsonwebtoken';
import passport from "passport";
import LocalStrategy from 'passport-local'
import dotenv from 'dotenv';
import House from '../schema/houseSchema.js';
import { authenticateToken, authenticateCookieToken } from '../service/jwt_auth.js';
import { get_house_from_db, get_user_from_db, save_house_to_db} from '../service/user_service.js';



const router = express.Router();

dotenv.config();

passport.use(new LocalStrategy(
  { usernameField: 'username' },
  async (username, password, done) => {
      try {
          const user = await User.findOne({ username });
          if (!user) {
              return done(null, false, { message: 'Incorrect username.' });
          }
          const isMatch = await bcrypt.compare(password, user.password);
          if (!isMatch) {
              return done(null, false, { message: 'Incorrect password.' });
          }
          return done(null, user);
      } catch (err) {
          return done(err);
      }
  }
));

passport.serializeUser((user, done) => {
  done(null, user.id);
});

passport.deserializeUser(async (id, done) => {
  try {
      const user = await User.findById(id);
      done(null, user);
  } catch (err) {
      done(err);
  }
});

router.post('/register', async (req, res) => {
  try {
    const { username, email, password } = req.body;

    if (!username || !password || !email) {
      return res.status(400).send('Username, email, and password are required');
    }

    // Check if username or email already exists
    const existingUser = await User.findOne({ $or: [{ username }, { email }] });
    if (existingUser) {
      return res.status(400).send('Username or email already exists');
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user with hashed password
    const newUser = new User({
      username,
      email,
      password: hashedPassword
    });

    console.log("This is user info before saving:", newUser);

    // Save the new user to the database
    await newUser.save();



    res.status(200).send('User Registered');
  } catch (error) {
    console.error("Error during registration:", error);
    if (error.code === 11000) {
      res.status(400).send('Duplicate key error: email, username, or id must be unique');
    } else {
      res.status(500).send(`Error registering user: ${error.message}`);
    }
  }
});

router.post('/login', async (req, res) => {

  const { username, password } = req.body;

  console.log("Username:", username)
  console.log("Password", password)

  const user = await User.findOne({ username });

  if (!user) {
    res.status(400).send(`There is no username registered as: ${username}`)
    console.log(`There is no username registered as: ${username}`);
    return;
  } else {
    console.log(`Found username: ${username}`);
  }

  const passwordMatch = await bcrypt.compare(password, user.password)

  if(!passwordMatch){
    res.status(400).send("Password doesn't match!!!")
    return;
  }
  console.log("TOKEN_SECRET during signing:", process.env.TOKEN_SECRET);

    // Generate JWT Token
  const token = jwt.sign(
    { userId: user._id, username: user.username },
    process.env.TOKEN_SECRET,
    { expiresIn: '1h' }
  );

  res.cookie('token', token, {
    httpOnly: true, // Cookie is only accessible by the web server
    secure: process.env.NODE_ENV === 'production', // Set to true if using HTTPS
    sameSite: 'Strict', // Helps prevent CSRF attacks
    maxAge: 3600000 // 1 hour in milliseconds
  });


  console.log("Token received for signing:", token);
  res.status(200).json({ success: true,message: 'Logged in successfully', token });
})

router.post('/create_house', authenticateCookieToken,async (req,res) => {

  const {house_name} = req.body;

  // 1# Create new house part
  var ID = await save_house_to_db(house_name)

  console.log("This is our ID", ID)
  if(ID){
    console.log("House Being Created . . .")

    // #2 User Update -> Adding the hID to that  user's hID field
    console.log("This is the ID: ", ID)
    var user = await get_user_from_db(req,res)

    user.hID = ID

    await user.save()
    
    res.status(200).send("New House Registered");
  }else{
    res.status(400).send("This house is being used already, please pick a new name")
  }
 
  
  



  
})

router.get('/test_jwt', async (req, res) => {

  // var house = await save_house_to_db(req,res)
 
  // console.log(house)

  // var user = await get_user_from_db(req,res)

  // try{
  //   user.hID = 1

  //   await user.save()
  //   console.log(user)
  res.status(200).json({ message: 'Save Successfully' });
  // } catch(error){
  //   console.error("Error updating house", error)
  //   return res.status(500).json({ message: 'An error occurred.' });
  // }

});





export default router;