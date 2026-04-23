import dotenv from "dotenv";
import mongoose from "mongoose";
dotenv.config();

const connectDB = async () => {
  try {
    console.log("process.env.MONGODB_URI:", process.env.MONGODB_URI);
    const connect = await mongoose.connect(process.env.MONGODB_URI);
    console.log(`DB Connection Successful: ${connect.connection.host}`);
  } catch (e) {
    console.error(`Error connecting to MongoDB: ${e.message}`);
    process.exit(1);
  }
};

export { connectDB };
