const mongoose = require('mongoose');
const { Schema } = mongoose;

const personalScoreSchema = new Schema({
    userID: {
        type: Number,
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

module.exports = mongoose.model('PersonalScore', personalScoreSchema);
