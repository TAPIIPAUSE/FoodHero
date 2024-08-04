import express from "express";
import session from "express-session";
import passport from "passport";
import mongoose from "mongoose";
import LocalStrategy from 'passport-local'
import crypto from 'crypto'
import {MongoClient} from "mongodb"


const app = express();
app.use(express.urlencoded({extended:true})) 
app.use(express.static('public')) //static file for hosting

//Passport JS Tutorial
// Routes
import userRoute from './routes/user.js'

if(userRoute){
    console.log("Found the directory")
}

const uri = "mongodb://127.0.0.1:27017/userAuth"; // Replace with your MongoDB URI
const client = new MongoClient(uri); //Connect DB

// Authentication Function
async function findUserByUsername(email) {
    await client.connect();
    const database = client.db(uri); // Replace with your database name
    const users = database.collection('users');
    const foundEmail = await users.findOne({ email: email });
    return foundEmail;
  }


//Passport -> library for easy authentication, passport.use (defining how do we ogin) -> localstrategy (dedault: username, password)
passport.use(new LocalStrategy(async function(username, password, cb) {
try {
    const user = await findUserByUsername(username);
    
    if (!user) {
    return cb(null, false, { message: 'Incorrect username or password.' });
    }

    crypto.pbkdf2(password, user.salt, 310000, 32, 'sha256', function(err, hashedPassword) {
    if (err) {
        return cb(err);
    }
    if (!crypto.timingSafeEqual(Buffer.from(user.hashed_password, 'hex'), hashedPassword)) {
        return cb(null, false, { message: 'Incorrect username or password.' });
    }
    return cb(null, user);
    });
} catch (err) {
    return cb(err);
}
}));



// Utilize session -> remember me
app.use(session({
    secret: 'This is my secret key',
    resave: false,
    saveUninitialized: true,
    // cookie: { secure: true }
}))

// Initiate passport
app.use(passport.initialize());
app.use(passport.session());

// Connect to DB
mongoose.connect(uri)
.then(()=> console.log("Connected to Mongo DB"))
.catch((err) => console.log(err))

// Middleware
app.use((req,res,next) => {
    console.log(`${req.method}: ${req.url}`)
    console.log('Request Body:', req.body)
    next()
});





// implement all route function from routes file
app.use('/api/v1/users', userRoute)



app.listen(3000, ()=>{
    console.log("Server Started");
})

// export client


