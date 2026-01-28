import { Router } from "express";
const userrouter = Router();
import { LoginUser, RegisterUser } from "../Controller/auth.controller.js";
userrouter.route("/register").post(RegisterUser);
userrouter.route("/login").post(LoginUser);

export default userrouter;
