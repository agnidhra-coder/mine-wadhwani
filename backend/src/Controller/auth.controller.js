import { UserModel } from "../Models/user.model.js";
import ApiResponse from "../Utils/Apiresponse.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

const RegisterUser = async (req, res) => {
  try {
    const { name, email, password, mobilenumber, avatar } = req.body;

    // Validation check
    if (!name || !email || !password || !mobilenumber) {
      return res
        .status(400)
        .json(ApiResponse.error("All fields are required", 400));
    }

    // Check if user already exists
    const email_user = await UserModel.findOne({
      $or: [{ email }],
    });

    if (email_user) {
      return res
        .status(409)
        .json(ApiResponse.error("User email already exists, please login", 409));
    }

    const user = await UserModel.findOne({
      $or: [{ mobilenumber }],
    });

    if (user) {
      return res
        .status(409)
        .json(ApiResponse.error("User mobile number already exists, please login", 409));
    }

    // Hash password
    const hashpassword = await bcrypt.hash(password, 10);

    // Create new user
    const newuser = await UserModel.create({
      name,
      email,
      password: hashpassword,
      mobilenumber,
      avatar: avatar || "default-avatar-url.jpg",
    });

    // Fetch created user (excluding password)
    const createduser = await UserModel.findById(newuser._id).select(
      "-password",
    );

    if (!createduser) {
      return res
        .status(500)
        .json(ApiResponse.error("Server issue while creating user", 500));
    }

    // ✅ Generate JWT token after successful registration
    const jwtToken = jwt.sign(
      { email: createduser.email, _id: createduser._id },
      process.env.Authentication_for_jsonwebtoken,
      { expiresIn: "1h" },
    );

    // Prepare response data with token
    const responseData = {
      user: createduser,
      token: jwtToken,
    };
    // Success response with token
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

    // Find user by email or mobile number
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

    // Check password
    const isPasswordCorrect = await bcrypt.compare(password, user.password);

    if (!isPasswordCorrect) {
      return res.status(401).json(ApiResponse.error("Invalid password", 401));
    }

    // Generate JWT token
    const jwtToken = jwt.sign(
      { email: user.email, _id: user._id },
      process.env.Authentication_for_jsonwebtoken,
      { expiresIn: "24h" },
    );

    // Remove password from user object before sending
    const userWithoutPassword = await UserModel.findById(user._id).select(
      "-password",
    );

    // Prepare response data
    const responseData = {
      user: userWithoutPassword,
      token: jwtToken,
    };

    // Success response
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
