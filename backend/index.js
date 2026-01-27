import express from "express";
import dotenv from "dotenv";
import cors from "cors";
dotenv.config();
import { connectDB } from "./src/DB/index.db.js";
import app from "./app.js";
connectDB()
  .then(() => {
    app.listen(process.env.PORT || 1425, () => {
      console.log(`⚙️ Server is running on port ${process.env.PORT}`);
    });
    app.get("/", (req, res) => {
      res.json({ message: "Welcome to the API" });
    });
  })
  .catch((e) => {
    console.log("DB connection error", e);
  });
