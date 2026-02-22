import { Router } from "express";
const userrouter = Router();
import { LoginUser, RegisterUser } from "../../Controller/auth.controller.js";
import { auth_middleware } from "../../Middleware/auth.middleware.js";
import {
  requireSuperAdmin,
  requireAdmin,
} from "../../Middleware/role.middleware.js";
userrouter.route("/register").post(RegisterUser);
userrouter.route("/login").post(LoginUser);
userrouter.route("/profile").post(auth_middleware, (req, res) => {
  return res.status(200).json({
    message: "user is verified",
    user: req.user,
  });
});
userrouter
  .route("/super-admin")
  .post(auth_middleware, requireSuperAdmin, (req, res) => {
    return res.status(200).json({
      message: "Hello from superadmin",
    });
  });
userrouter.route("/admin").post(auth_middleware, requireAdmin, (req, res) => {
  return res.status(200).json({
    message: "Hello from admin",
    user: req.user,
  });
});
export default userrouter;
