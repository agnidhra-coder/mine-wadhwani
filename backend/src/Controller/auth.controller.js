import { UserModel } from "../Models/user.model.js";
import ApiResponse from "../Utils/Apiresponse.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

const RegisterUser = async (req, res) => {
  try {
    const { name, email, mine_role, password, mobilenumber, avatar } = req.body;

    if (!name || !email || !mine_role || !password || !mobilenumber) {
      return res
        .status(400)
        .json(ApiResponse.error("All fields are required", 400));
    }

    const email_user = await UserModel.findOne({
      $or: [{ email }],
    });

    if (email_user) {
      return res
        .status(409)
        .json(
          ApiResponse.error("User email already exists, please login", 409),
        );
    }

    const user = await UserModel.findOne({
      $or: [{ mobilenumber }],
    });

    if (user) {
      return res
        .status(409)
        .json(
          ApiResponse.error(
            "User mobile number already exists, please login",
            409,
          ),
        );
    }

    const hashpassword = await bcrypt.hash(password, 10);

    const newuser = await UserModel.create({
      name,
      email,
      password: hashpassword,
      mobilenumber,
      avatar: avatar || "default-avatar-url.jpg",
      mine_role,
    });

    const createduser = await UserModel.findById(newuser._id).select(
      "-password",
    );

    if (!createduser) {
      return res
        .status(500)
        .json(ApiResponse.error("Server issue while creating user", 500));
    }

    const jwtToken = jwt.sign(
      { email: createduser.email, _id: createduser._id },
      process.env.Authentication_for_jsonwebtoken,
      { expiresIn: "1h" },
    );

    const responseData = {
      user: createduser,
      token: jwtToken,
    };
    return res
      .status(201)
      .json(
        ApiResponse.success(
          responseData,
          "User registered and logged in successfully",
          201,
        ),
      );
  } catch (error) {
    console.error("Registration error:", error);
    return res
      .status(500)
      .json(
        ApiResponse.error(`Error in registering user: ${error.message}`, 500),
      );
  }
};

const LoginUser = async (req, res) => {
  try {
    const { email, mobilenumber, password } = req.body;

    if (!password || (!email && !mobilenumber)) {
      return res
        .status(400)
        .json(
          ApiResponse.error(
            "Email/Mobile number and password are required",
            400,
          ),
        );
    }

    const user = await UserModel.findOne({
      $or: [{ email }, { mobilenumber }],
    });

    if (!user) {
      return res
        .status(404)
        .json(
          ApiResponse.error("User does not exist, please register first", 404),
        );
    }

    const isPasswordCorrect = await bcrypt.compare(password, user.password);

    if (!isPasswordCorrect) {
      return res.status(401).json(ApiResponse.error("Invalid password", 401));
    }
    const jwtToken = jwt.sign(
      { email: user.email, _id: user._id },
      process.env.Authentication_for_jsonwebtoken,
      { expiresIn: "24h" },
    );

    const userWithoutPassword = await UserModel.findById(user._id).select(
      "-password",
    );

    const responseData = {
      user: userWithoutPassword,
      token: jwtToken,
    };

    return res
      .status(200)
      .json(
        ApiResponse.success(responseData, "User logged in successfully", 200),
      );
  } catch (error) {
    console.error("Login error:", error);
    return res
      .status(500)
      .json(ApiResponse.error(`Error in logging in: ${error.message}`, 500));
  }
};

export { RegisterUser, LoginUser };
