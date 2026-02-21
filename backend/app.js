import express from "express";
const app = express();
import cors from "cors";
app.use(
  cors({
    origin: "*",
    credentials: true,
  }),
);

app.use(
  express.json({
    limit: "50mb",
  }),
);

app.use(
  express.urlencoded({
    extended: true,
    limit: "50mb",
  }),
);
import userrouter from "./src/Routes/user.route.js";
app.use("/api/v1/auth", userrouter);
export default app;
