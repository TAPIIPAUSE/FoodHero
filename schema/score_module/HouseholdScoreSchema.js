import mongoose from "mongoose";


const householdScoreSchema = new mongoose.Schema({
    hID: {
        type: Number, // Integer type for household ID
        required: true
    },
    userID: {
        type: Number, // Integer type for user ID
        required: true
    },
    Score: {
        type: mongoose.Types.Decimal128, // BSON Decimal for precision
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    modifiedTime: {
        type: Date,
        default: Date.now
    }
});



const HouseholdScore = mongoose.model('HouseholdScore', householdScoreSchema);

export default HouseholdScore;
