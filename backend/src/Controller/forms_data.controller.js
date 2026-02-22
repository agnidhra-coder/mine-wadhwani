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
      mineId,
      operationalDate,
      shiftNumber,
      supervisorId,
      checklistData,
      startTime,
    } = req.body;
    if (
      !mineId ||
      !operationalDate ||
      !shiftNumber ||
      !supervisorId ||
      !checklistData ||
      !startTime
    ) {
      return res
        .status(400)
        .json(
          ApiResponse.error(
            `All required fields are not provided in the request body`,
            400,
          ),
        );
    }
    const karo = await QuestionModel.create({
      mineId,
      operationalDate,
      shiftNumber,
      supervisorId,
      checklistData,
      startTime,
    });
    console.log(karo);
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
