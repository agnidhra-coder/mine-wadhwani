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
      inspectionId,
      mine_name,
      mine_type,
      area,
      shift,
      Inspection_type,
      Inspector_id,
      checklistData,
      date,
      startTime,
      endTime,
      completed,
      observations,
      signature,
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

    // Convert dates if provided, else use current time
    const formDate = date ? new Date(date) : new Date();
    const formStartTime = startTime ? new Date(startTime) : new Date();
    const formEndTime = endTime ? new Date(endTime) : new Date();

    let Question;
    if (inspectionId) {
      Question = await QuestionModel.findById(inspectionId);
    }

    if (!Question) {
      Question = await QuestionModel.findOne({
        mine_name,
        shift: Number(shift),
        Inspection_type,
        Inspector_id,
        completed: false,
      });
    }

    if (Question) {
      Question.mine_type = mine_type;
      Question.area = area;
      Question.date = formDate;
      if (checklistData) Question.checklistData = checklistData;
      Question.startTime = formStartTime;
      Question.endTime = formEndTime;
      Question.completed = completed === true;
      Question.observations = observations || "";
      Question.signature = signature || "";
      await Question.save();
    } else {
      Question = await QuestionModel.create({
        mine_name,
        mine_type,
        area,
        shift: Number(shift),
        date: formDate,
        Inspection_type,
        Inspector_id,
        checklistData,
        startTime: formStartTime,
        endTime: formEndTime,
        completed: completed === true,
        observations: observations || "",
        signature: signature || "",
      });
    }

    console.log(Question);
    return res
      .status(201)
      .json(ApiResponse.success(Question, "Form data saved successfully", 201));
  } catch (error) {
    console.error("Error saving form data:", error);
    return res
      .status(500)
      .json(
        ApiResponse.error(`Error in saving form data: ${error.message}`, 500),
      );
  }
};

const get_saved_data = async (req, res) => {
  try {
    const { mine_name, shift, Inspection_type, date, Inspector_id, completed } =
      req.query;

    const query = {};
    if (mine_name) query.mine_name = mine_name;
    if (shift) query.shift = Number(shift);
    if (Inspection_type) query.Inspection_type = Inspection_type;
    if (Inspector_id) query.Inspector_id = Inspector_id;
    if (completed !== undefined) {
      query.completed = completed === "true" || completed === true;
    }
    if (date) {
      // Ensure date comparison covers the whole day if required, or strict equality
      const queryDate = new Date(date);
      queryDate.setHours(0, 0, 0, 0);
      const nextDate = new Date(queryDate);
      nextDate.setDate(nextDate.getDate() + 1);
      query.date = { $gte: queryDate, $lt: nextDate };
    }

    const forms = await QuestionModel.find(query);

    return res
      .status(200)
      .json(
        ApiResponse.success(forms, "Saved forms fetched successfully", 200),
      );
  } catch (error) {
    console.error("Error fetching saved forms:", error);
    return res
      .status(500)
      .json(
        ApiResponse.error(
          `Error in fetching saved forms: ${error.message}`,
          500,
        ),
      );
  }
};

const upload_media = async (req, res) => {
  try {
    const { inspectionId, questionIndex } = req.params;

    // --- basic param checks ---
    if (!inspectionId) {
      return res
        .status(400)
        .json(ApiResponse.error("inspectionId is required", 400));
    }

    const qIdx = Number(questionIndex);
    if (isNaN(qIdx) || qIdx < 0) {
      return res
        .status(400)
        .json(
          ApiResponse.error("questionIndex must be a non-negative number", 400),
        );
    }

    // --- files check ---
    if (!req.files || req.files.length === 0) {
      return res
        .status(400)
        .json(ApiResponse.error("At least one image file is required", 400));
    }

    // --- fetch inspection document ---
    const inspection = await QuestionModel.findById(inspectionId);
    if (!inspection) {
      return res
        .status(404)
        .json(ApiResponse.error("Inspection not found", 404));
    }

    if (qIdx >= inspection.checklistData.length) {
      return res
        .status(400)
        .json(
          ApiResponse.error(
            `questionIndex ${qIdx} is out of bounds. This inspection has ${inspection.checklistData.length} questions.`,
            400,
          ),
        );
    }

    // --- upload all files to Cloudinary in parallel ---
    const { uploadToCloudinary } = await import("../Utils/cloudinary.js");

    const uploadPromises = req.files.map((file) =>
      uploadToCloudinary(file.buffer, {
        folder: `mine-inspections/${inspectionId}`,
        public_id: `q${qIdx}_${Date.now()}_${Math.round(Math.random() * 1000)}`,
      }),
    );

    const uploadResults = await Promise.all(uploadPromises);
    const imageUrls = uploadResults.map((r) => r.secure_url);

    // --- push URLs into the specific question's imageUrl array ---
    const updatePath = `checklistData.${qIdx}.imageUrl`;

    const updatedInspection = await QuestionModel.findByIdAndUpdate(
      inspectionId,
      { $push: { [updatePath]: { $each: imageUrls } } },
      { new: true },
    );

    return res.status(200).json(
      ApiResponse.success(
        {
          uploadedUrls: imageUrls,
          question: updatedInspection.checklistData[qIdx],
        },
        "Images uploaded successfully",
        200,
      ),
    );
  } catch (error) {
    console.error("Error uploading media:", error);
    return res
      .status(500)
      .json(ApiResponse.error(`Error uploading media: ${error.message}`, 500));
  }
};

const delete_draft = async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json(ApiResponse.error("id is required", 400));
    }

    const draft = await QuestionModel.findById(id);
    if (!draft) {
      return res.status(404).json(ApiResponse.error("Draft not found", 404));
    }

    // Safety check: Only delete if completed is false (meaning it is a draft)
    if (draft.completed) {
      return res
        .status(200)
        .json(
          ApiResponse.success(
            null,
            "Completed inspection preserved (not deleted)",
            200,
          ),
        );
    }

    await QuestionModel.findByIdAndDelete(id);
    return res
      .status(200)
      .json(ApiResponse.success(null, "Draft deleted successfully", 200));
  } catch (error) {
    console.error("Error deleting draft:", error);
    return res
      .status(500)
      .json(ApiResponse.error(`Error deleting draft: ${error.message}`, 500));
  }
};

export { get_form_data, save_data, get_saved_data, upload_media, delete_draft };
