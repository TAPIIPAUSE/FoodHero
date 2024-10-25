import mongoose from 'mongoose';

const PersonalScoreSchema = new mongoose.Schema({
    userID: {
        type: Number,
        required: true
    },hID: {
        type: Number, // Integer type for household ID
        required: true
    },
    FoodType: {
        type: Number, // Integer type for household ID
        required: true
    },
    orgID: {
        type: Number, // Integer type for organization ID
        required: true
    },
    Score: {
        type: Number, // Float type
        required: true
    },
    Consume: {
        type: mongoose.Types.Decimal128, // Float type
        required: true
    },
    Waste: {
        type: mongoose.Types.Decimal128,// Float type
        required: true
    },
    Saved: {
        type: mongoose.Types.Decimal128, // BSON Decimal type for precision
        required: true
    },
    Lost: {
        type: mongoose.Types.Decimal128, // BSON Decimal type for precision
        required: true
    },
    createdAt: {
        type: Date,
        default: Date.now
    },
    modifiedAt: {
        type: Date,
        default: Date.now
    }
});

const PersonalScore = mongoose.model('PersonalScore', PersonalScoreSchema);

export default PersonalScore;
