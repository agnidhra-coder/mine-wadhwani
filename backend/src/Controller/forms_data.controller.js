import questions from "../Models/seed_data.js";
import ApiResponse from "../Utils/Apiresponse.js";
import QuestionModel from "../Models/form_data.model.js";
const get_form_data = (req, res) => {
  try {
    return res
      .status(201)
      .json(
        ApiResponse.success(
          questions,
          "Questions data fetched successfully",
          201,
        ),
      );
  } catch (error) {
    console.error("Registration error:", error);
    return res
      .status(500)
      .json(
        ApiResponse.error(
          `Error in fetching questions data: ${error.message}`,
          500,
        ),
      );
  }
};

const save_data = async (req, res) => {
  try {
    const {
      mine_name,
      mine_type,
      area,
      shift,
      Inspection_type,
      Inspector_id,
      checklistData,
    } = req.body;
    if (!mine_name) {
      return res
        .status(400)
        .json(ApiResponse.error("mine_name is required", 400));
    }
    if (!mine_type) {
      return res
        .status(400)
        .json(ApiResponse.error("mine_type is required", 400));
    }
    if (!area) {
      return res.status(400).json(ApiResponse.error("area is required", 400));
    }
    if (!shift) {
      return res.status(400).json(ApiResponse.error("shift is required", 400));
    }
    if (!Inspection_type) {
      return res
        .status(400)
        .json(ApiResponse.error("Inspection_type is required", 400));
    }
    if (!Inspector_id) {
      return res
        .status(400)
        .json(ApiResponse.error("Inspector_id is required", 400));
    }
    if (checklistData) {
      if (checklistData.length === 0) {
        return res
          .status(400)
          .json(ApiResponse.error("checklist data can not be empty", 400));
      }
      if (!Array.isArray(checklistData)) {
        return res
          .status(400)
          .json(ApiResponse.error("checklistData must be an array", 400));
      }
    }
    const Question = await QuestionModel.create({
      mine_name,
      mine_type,
      area,
      shift,
      Inspection_type,
      Inspector_id,
      checklistData,
      startTime: new Date().toISOString(),
    });
    console.log(Question);
    return res
      .status(201)
      .json(ApiResponse.success(null, "Form data saved successfully", 201));
  } catch (error) {
    console.error("Error saving form data:", error);
    return res
      .status(500)
      .json(
        ApiResponse.error(`Error in saving form data: ${error.message}`, 500),
      );
  }
};

export { get_form_data, save_data };
