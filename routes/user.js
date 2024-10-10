// import express from 'express';
import bcrypt from 'bcryptjs';
import User from '../schema/user_module/userSchema.js'; // Adjust the import path according to your project structure
import express from "express";
import jwt from 'jsonwebtoken';
import passport from "passport";
import LocalStrategy from 'passport-local'
import dotenv from 'dotenv';
import House from '../schema/user_module/houseSchema.js';
import Organization from '../schema/user_module/organizationSchema.js';
import { authenticateToken, authenticateCookieToken } from '../service/jwt_auth.js';
import { save_org_to_db, get_user_from_db, save_house_to_db, get_houseID, get_house_from_db, get_housename_from_db, get_orgname_from_db} from '../service/user_service.js';




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
  const hID = user.hID

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
  res.status(200).json({ success: true,message: 'Logged in successfully', token , hID: hID});
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
    user.isFamilyLead = true

    await user.save()
    
    res.status(200).send("New House Registered");
  }else{
    res.status(400).send("This house is being used already, please pick a new name")
  }
})

router.post('/join_house', authenticateCookieToken, async (req, res) => {
  const { housename } = req.body;
  const user = await get_user_from_db(req, res);
  const house = await get_housename_from_db(housename);
  
  if (!house) {
    res.status(400).send("House not found");
    return;
  }

  if (house.assigned_ID === user.hID) {
    res.status(400).send("You are already in a house");
    return;
  }
  user.hID = house.assigned_ID;
  user.orgID = house.org_ID;
  await user.save();
  res.status(200).send("House Joined");
  console.log("House Joined");
})

router.post('/create_org', authenticateCookieToken,async (req,res) => {

  const {org_name} = req.body;

  // 1# Create new house part
  var ID = await save_org_to_db(org_name)

  console.log("This is our ID", ID)
  if(ID){
    console.log("Organization Being Created . . .")

    // #2 User Update -> Adding the hID to that  user's hID field
    console.log("This is the ID: ", ID)
    var user = await get_user_from_db(req,res)
    // For updating the orgID in house table
    var hID = await get_houseID(user)
    var house = await get_house_from_db(hID)
    
    // Update in house table as well, -> org_id 
    house.org_ID = ID
    // Updte in user table as well, -> orgID
    user.orgID = ID
    user.isOrgLead = true

    // Save 2 tables
    await house.save()
    await user.save()
    
    res.status(200).send("New Organization Registered");
  }else{
    res.status(400).send("This organization is being used already, please pick a new name")
  }
})

router.post('/join_org', authenticateCookieToken, async (req, res) => {
  const { orgname } = req.body;
  const user = await get_user_from_db(req, res);
  const org = await get_orgname_from_db(orgname);

  if(user.isFamilyLead === false){
    console.log(user)
    return res.status(430).send("Only House Lead is permitted to join organization.")
  }
  
  if (!org) {
    res.status(400).send("Organization not found");
    console.log("Organization not found");
    return;
  }

  if (org.assigned_ID === user.orgID) {
    res.status(400).send("You are already in a organization");
    console.log("You are already in a organization");
    return;
  }
  user.orgID = org.assigned_ID;
  await user.save();
  res.status(200).send("Organization Joined");
  console.log("Organization Joined");
})


router.get('/test_jwt', authenticateCookieToken,async (req, res) => {

  var user = await get_user_from_db(req,res)
  console.log("User info:", user)
  var hID = await get_houseID(user)
  console.log("House ID:", hID)
  var house = await get_house_from_db(hID)

  console.log("House info:", house)
});





export default router;