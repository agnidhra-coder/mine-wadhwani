import mongoose, { mongo } from "mongoose";
const UserSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
    },
    mobilenumber: {
      type: String,
      required: true,
      unique: true,
    },
    avatar: {
      type: String,
      default: "default-avatar-url.jpg",
    },
    password: {
      type: String,
      required: true,
      unique: true,
    },
    role: {
      type: String,
      enum: ["SUPER_ADMIN", "MINE_ADMIN", "SUPERVISOR"],
      default: "SUPERVISOR",
    },
    mineid: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Mine",
    },
  },
  {
    timestamps: true,
  },
);

export const UserModel = mongoose.model("User", UserSchema);
