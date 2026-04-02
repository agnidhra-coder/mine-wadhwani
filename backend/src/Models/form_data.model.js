import mongoose, { mongo } from "mongoose";
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
      initial: -1,
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
          enum: ["YES", "NO", "NA"],
        },
        comment: String,
      },
    ],
    startTime: {
      type: Date,
      required: true,
    },
  },
  {
    timestamps: true,
  },
);
Question_schema.index(
  { mineId: 1, operationalDate: 1, shiftNumber: 1 },
  { unique: true },
);
export const QuestionModel = mongoose.model("Question", Question_schema);

export default QuestionModel;
