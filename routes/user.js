// import express from 'express';
import bcrypt from 'bcryptjs';
import User from '../schema/userSchema.js'; // Adjust the import path according to your project structure
import express from "express";


const router = express.Router();


// Registration Function, set the postman request to POST, Body -> x-www-form-urlencoded
// Required fields for Registration
// Username
// Email
// Password

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


// router.post('/login', (req,res)=>{
//   const username = req.body.username
//   const email = req.body.email
//   const password = req.body.password

//   const user = new userAuth({
//       username: username,
//       email: email,
//       password: password
//   })

//   req.login(user, function(err,user){
//       if(err){
//           console.log(err)
//       }else{
//           console.log("Log In Successfully")

//           res.json({
//               "messages": "Welcome Logged In User"
//           }).status(200)
    
//       }
//   })
// })

// router.get('/logout', (res,req)=>{
//   req.logOut(function(err){
//       if(err){
//           console.log(err)
//       }else{
//           res.redirect('/register')
//       }
//   })
// })

export default router;