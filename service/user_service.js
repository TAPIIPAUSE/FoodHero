import jwt from "jsonwebtoken";
import dotenv from "dotenv";
import User from "../schema/user_module/userSchema.js";
import House from "../schema/user_module/houseSchema.js";
import Organization from "../schema/user_module/organizationSchema.js";

export async function get_user_from_db(req, res) {
  try {
    const target_user = req.user.username;
    
    // JWT verify method is used for verify the token the take two arguments one is token string value,
    // and second one is secret key for matching the token is valid or not.
    // The validation method returns a decode object that we stored the token in.
    const existingUser = await User.findOne({ username: target_user });
  
    if (!existingUser) {
      console.log(
        "Token username doesn't match with the current username available in database."
      );
    }

    return existingUser;
  } catch (error) {
    console.error("Error getting user info", error);
    return res.status(500).json({ message: "An error occurred." });
  }
}

export async function get_house_from_db(hID) {
  // Need to be called with the get_houseID, so this method could receive the houseID, and use it for searching
  try {
    var target_house = await House.findOne({ assigned_ID: hID });

    if (!target_house) {
      console.log(
        "House ID doesn't match with the current house available in database."
      );
    }

    return target_house;
  } catch (error) {
    console.error("Error getting house info", error);
    return res.status(500).json({ message: "An error occurred." });
  }
}

export async function get_housename_from_db(house_name) {
  // Need to be called with the get_houseID, so this method could receive the houseID, and use it for searching
  try {
    var target_house = await House.findOne({ house_name: house_name });

    if (!target_house) {
      console.log(
        "House Name doesn't match with the current house available in database."
      );
    }

    return target_house;
  } catch (error) {
    console.error("Error getting house info", error);
    return res.status(500).json({ message: "An error occurred." });
  }
}

export async function get_orgname_from_db(org_name) {
  // Need to be called with the get_houseID, so this method could receive the houseID, and use it for searching
  try {
    var target_org = await Organization.findOne({ org_name: org_name });

    if (!target_org) {
      console.log(
        "Organization Name doesn't match with the current organization available in database."
      );
    }

    return target_org;
  } catch (error) {
    console.error("Error getting org info", error);
    return res.status(500).json({ message: "An error occurred." });
  }
}

export async function get_houseID(user) {
  // Get house from the user info
  try {
    return user.hID;
  } catch (error) {
    console.error("Error getting house info", error);
    return res.status(500).json({ message: "An error occurred." });
  }
}

export async function save_house_to_db(house_name) {
  try {
    // Check if the house already exists in the database
    const house = await House.findOne({ house_name });
    console.log("This is starting of save_house_to_db:", house);
    var newID = 0;

    // If house does not exist, create a new house entry
    if (!house) {
      console.log("House doesn't exist, creation approved");

      const newHouse = new House({
        house_name,
      });

      console.log("This is your new house object:", newHouse);

      console.log("This will be your new house name:", house_name);
      const newly_registered_house = await newHouse.save();
      newID = newly_registered_house.assigned_ID;
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

export async function save_org_to_db(org_name) {
  try {
    // Check if the organization already exists in the database
    const organization = await Organization.findOne({ org_name });
    var newID = 0;

    // If organization does not exist, create a new organization entry
    if (!organization) {
      console.log("Organization doesn't exist, creation approved");

      const newOrg = new Organization({
        org_name,
      });

      console.log("This is your new Organization object:", newOrg);

      console.log("This will be your new Organization name:", org_name);
      const newly_registered_org = await newOrg.save();
      newID = newly_registered_org.assigned_ID;
      return newID; // Indicate that a new organization was created
    } else {
      console.log("Organization already exists");
      return false; // Indicate that the house already exists
    }
  } catch (error) {
    console.error("Error checking or saving organization:", error);
    throw error; // Re-throw the error to handle it elsewhere if needed
  }
}
