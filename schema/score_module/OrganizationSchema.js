import mongoose from "mongoose";

const organizationScoreSchema = new mongoose.Schema({
    orgID: {
        type: Number, // Integer type for organization ID
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

const OrganizationScore = mongoose.model('OrganizationScore', organizationScoreSchema);

export default OrganizationScore;
