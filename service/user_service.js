import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';
import User from '../schema/userSchema.js';
import House from '../schema/houseSchema.js';

export async function get_user_from_db (req,res){

    try{
        const token = req.cookies.token

        const decoded_token = jwt.verify(token, process.env.TOKEN_SECRET)
    
        const target_user = decoded_token.username
    
        console.log("Target User: ",target_user)
    
          // JWT verify method is used for verify the token the take two arguments one is token string value, 
  // and second one is secret key for matching the token is valid or not. 
  // The validation method returns a decode object that we stored the token in.

        const existingUser = await User.findOne({"username": target_user})

        if(!existingUser){
            console.log("Token username doesn't match with the current username available in database.")
        }

        return existingUser
        
    } catch (error){
        console.error("Error getting user info", error)
        return res.status(500).json({ message: 'An error occurred.' });
    }



}

export async function get_house_from_db (req,res){

    try{
        const existingHouse = await House.findOne({"house_name": target_user})
        // console.log(existingHouse)
        return existingHouse
        
    } catch (error){
        console.error("Error updating house", error)
        return res.status(500).json({ message: 'An error occurred.' });
    }



}

export async function save_house_to_db (house_name){
    

    try {
        // Check if the house already exists in the database
        const house = await House.findOne({ house_name });
        var newID = 0
    
        // If house does not exist, create a new house entry
        if (!house) {
          console.log("House doesn't exist, creation approved");
    
          const newHouse = new House({
            house_name
          });
    
          console.log("This will be your new house name:", house_name);
          const newly_registered_house = await newHouse.save();
          newID = newly_registered_house.assigned_ID
          return newID; // Indicate that a new house was created
        } else {
          console.log("House already exists");
          return false; // Indicate that the house already exists
        }
      } catch (error) {
        console.error("Error checking or saving house:", error);
        throw error; // Re-throw the error to handle it elsewhere if needed
      }

}