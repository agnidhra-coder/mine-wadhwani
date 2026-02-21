import express from "express";
const app = express();
import cors from "cors";
import { auth_middleware } from "./src/Middleware/auth.middleware.js";
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
import userrouter from "./src/Routes/User/user.route.js";
app.use("/api/v1/auth", userrouter);
// adding forms data route
import forms_data_router from "./src/Routes/Forms_data/forms_data.route.js";
app.use("/api/v1/forms_data", auth_middleware, forms_data_router);
export default app;
