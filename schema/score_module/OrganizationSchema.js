const mongoose = require('mongoose');
const { Schema } = mongoose;

const organizationScoreSchema = new Schema({
    orgID: {
        type: Number, // Integer type for organization ID
        required: true
    },
    Score: {
        type: mongoose.Types.Decimal128, // BSON Decimal for precision
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
    createdAt: {
        type: Date,
        default: Date.now
    },
    modifiedTime: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('OrganizationScore', organizationScoreSchema);
