const mongoose = require('mongoose');
const { Schema } = mongoose;

const householdScoreSchema = new Schema({
    hID: {
        type: Number, // Integer type for household ID
        required: true
    },
    userID: {
        type: Number, // Integer type for user ID
        required: true
    },
    Consume: {
        type: mongoose.Types.Decimal128, // BSON Decimal for precision
        required: true
    },
    Waste: {
        type: mongoose.Types.Decimal128, // BSON Decimal for precision
        required: true
    },
    MoneySaved: {
        type: mongoose.Types.Decimal128, // BSON Decimal for precision
        required: true
    },
    MoneyLost: {
        type: mongoose.Types.Decimal128, // BSON Decimal for precision
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

module.exports = mongoose.model('HouseholdScore', householdScoreSchema);
