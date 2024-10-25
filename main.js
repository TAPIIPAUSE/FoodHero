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
app.use(express.urlencoded({extended:true})) 
app.use(express.static('public')) //static file for hosting

// Ensure Body Parsing, Cookie Parsing Middleware is Used
app.use(express.json());
app.use(cookieParser());

//Passport JS Tutorial
// Routes
import userRoute from './routes/user.js'
import inventoryRoute from './routes/inventory.js'
import consumeRoute from './routes/consume.js'
import dashboardRoute from './routes/dashboard.js'
import houseorgRoute from './routes/houseorg.js'

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
app.use('/api/v1/consume', consumeRoute)
app.use('/api/v1/dashboard', dashboardRoute)
app.use('/api/v1/houseorg', houseorgRoute)
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocs))

app.listen(3000, () => {
    console.log("Server Started");
})

// export client
app.get('/api/v1/inventory', async (req, res) => {
    try {
      const inventoryItems = await InventoryModel.find(); // Fetch all inventory items
      res.status(200).json(inventoryItems);
    } catch (error) {
      res.status(500).json({ message: 'Server Error' });
    }
  });
// GET Inventory Items
inventoryRoute.get('/', async (req, res) => {
    try {
      const inventoryItems = await Food.find();  // Fetch all items
      res.json(inventoryItems);
    } catch (error) {
      console.error('Error fetching inventory:', error);
      res.status(500).json({ error: 'Server error' });
    }
  });
  
 // module.exports = inventoryRoute;
