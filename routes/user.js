// import express from 'express';
import bcrypt from 'bcryptjs';
import User from '../schema/userSchema.js'; // Adjust the import path according to your project structure
import express from "express";
import jwt from 'jsonwebtoken';
import passport from "passport";
import LocalStrategy from 'passport-local'


const router = express.Router();

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

    // Generate JWT Token
  const token = jwt.sign(
    { userId: user._id, username: user.username },
    process.env.SECRET_KEY || "1234!@#%<{*&)",
    { expiresIn: "1h" }
  );

  res.status(200).json({ message: 'Logged in successfully', token });




})


//   // Check If The Input Fields are Valid
//   if (!username || !password) {
//     return res
//       .status(400)
//       .json({ message: "Please Input Username and Password" });
//   }


//   if (!passwordMatch) {
//     return res.status(401).json({ message: "Invalid username or password" });
//   }

//   // Generate JWT Token
//   const token = jwt.sign(
//     { userId: user._id, username: user.username },
//     process.env.SECRET_KEY || "1234!@#%<{*&)",
//     { expiresIn: "1h" }
//   );

//   return res
//     .status(200)
//     .json({ message: "Login Successful", data: user, token });
// } catch (error) {
//   console.log(error.message);
//   return res.status(500).json({ message: "Error during login" });
// }
// })




export default router;