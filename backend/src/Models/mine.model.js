import mongoose from "mongoose";

const MineSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      unique: true,
    },
    type: {
      type: String,
      required: true,
      enum: ["Opencast", "Underground", "Coal", "Metal"],
    },
    area: {
      type: String,
      required: true,
    },
    location: {
      type: String,
      required: false,
    },
  },
  {
    timestamps: true,
  },
);

export const MineModel = mongoose.model("Mine", MineSchema);
export default MineModel;
