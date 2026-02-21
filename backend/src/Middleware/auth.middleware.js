import jwt from "jsonwebtoken";
import ApiResponse from "../Utils/ApiResponse.js";
import { UserModel } from "../Models/user.model.js";
const auth_middleware = async (req, res, next) => {
  try {
    let token;
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith("Bearer ")
    ) {
      token = req.headers.authorization.split(" ")[1];
    } else if (req.headers.token) {
      token = req.headers.token;
    }
    console.log(token);
    if (!token) {
      return res
        .status(500)
        .json(ApiResponse.error(`No authorization token provided`, 500));
    }
    const decoded = jwt.verify(
      token,
      process.env.Authentication_for_jsonwebtoken,
    );
    console.log(decoded);
    const user = await UserModel.findById(decoded._id)
      .select("-password")
      .lean();
    if (!user) {
      return res.status(404).json(ApiResponse.error(`User not found`, 404));
    }
    req.user = user;
    next();
  } catch (error) {
    return res.status(500).json(ApiResponse.error(`${error.message}`, 500));
  }
};

export { auth_middleware };
