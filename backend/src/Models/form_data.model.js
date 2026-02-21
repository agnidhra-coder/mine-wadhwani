import mongoose, { mongo } from "mongoose";
const Question_schema = new mongoose.Schema(
  {
    // mineId: {
    //   type: mongoose.Schema.Types.ObjectId,
    //   ref: "Mine",
    //   // required: true,
    // },
    // operationalDate: {
    //   type: Date,
    //   // required: true,
    // },
    // shiftNumber: {
    //   type: Number,
    //   // required: true,
    //   enum: [1, 2, 3],
    //   initial: -1,
    // },
    supervisorId: {
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
    // startTime: {
    //   type: Date,
    //   // required: true,
    // },
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
