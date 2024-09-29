import cors from 'cors';
import express from "express";
import session from "express-session";
import passport from "passport";
import mongoose from "mongoose";
import LocalStrategy from 'passport-local'
import crypto from 'crypto'
import {MongoClient} from "mongodb"
import cookieParser from 'cookie-parser';
import swaggerDocs from './utils/swagger-output.json' assert { type: 'json' };
import swaggerUi from "swagger-ui-express";

const app = express();
app.use(cors({ origin: ['http://127.0.0.1:PORT','http://localhost:3000'] })); 
app.use(express.urlencoded({extended:true})) 
app.use(express.static('public')) //static file for hosting

// Ensure Body Parsing, Cookie Parsing Middleware is Used
app.use(express.json());
app.use(cookieParser());

//Passport JS Tutorial
// Routes
import userRoute from './routes/user.js'
import inventoryRoute from './routes/inventory.js'

if(userRoute){
    console.log("Found the directory")
}
// const uri = "mongodb://admin:foodhero@10.4.150.148:27017/"
const uri = "mongodb+srv://foodhero:foodhero@foodhero.a6ndt4i.mongodb.net/userAuth"

const client = new MongoClient(uri); //Connect DB


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



// const userRouter = require("./routes/userRoute.js")

// implement all route function from routes file
app.use('/api/v1/users', userRoute)
app.use('/api/v1/inventory', inventoryRoute)
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs))

app.listen(3000, () => {
    console.log("Server Started");
})

// export client


