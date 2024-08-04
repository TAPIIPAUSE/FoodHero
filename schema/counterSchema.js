import mongoose from 'mongoose';

const counterSchema = new mongoose.Schema({
  _id: { type: String, required: true },
  seq: { type: Number, default: 0 }
});

const counterModel = mongoose.model('counter', counterSchema);

const autoIncrementModelID = async function (modelName, doc) {
  try {
    const counter = await counterModel.findByIdAndUpdate(
      modelName,
      { $inc: { seq: 1 } },
      { new: true, upsert: true }
    );

    doc.userID = counter.seq;
    console.log("This is the counter.seq:", counter.seq);
    console.log("This is doc.id:", doc.userID);
  } catch (error) {
    throw error;
  }
};

export default autoIncrementModelID;
