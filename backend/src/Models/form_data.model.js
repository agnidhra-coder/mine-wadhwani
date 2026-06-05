import mongoose from "mongoose";

const Question_schema = new mongoose.Schema(
  {
    mine_name: {
      type: String,
      required: true,
    },
    mine_type: {
      type: String,
      required: true,
      enum: ["Opencast", "Underground", "Coal", "Metal"],
    },
    area: {
      type: String,
      required: true,
    },
    shift: {
      type: Number,
      enum: [1, 2, 3],
      required: true,
    },
    date: {
      type: Date,
      required: true,
      default: Date.now,
    },
    Inspection_type: {
      type: String,
      required: true,
    },
    Inspector_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    checklistData: [
      {
        questionCode: String,
        maintopic: String,
        subtopic: String,
        questionText: String,
        answer: {
          type: String,
        },
        comment: String,
        imageUrl: [String],
        action: String,
      },
    ],
    completed: {
      type: Boolean,
      default: false,
    },
    observations: {
      type: String,
      default: "",
    },
    signature: {
      type: String,
      default: "",
    },
    startTime: {
      type: Date,
      required: true,
    },
    endTime: {
      type: Date,
      default: Date.now,
    },
  },
  {
    timestamps: true,
  },
);

// Create compound index to ensure one submitted inspection per user, for a specific mine, shift, and date
Question_schema.index(
  {
    mine_name: 1,
    shift: 1,
    Inspection_type: 1,
    date: 1,
    Inspector_id: 1,
    completed: 1,
  },
  { unique: true },
);

export const QuestionModel = mongoose.model("Question", Question_schema);

export default QuestionModel;
