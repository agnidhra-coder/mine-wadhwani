import { Router } from "express";
import {
  get_form_data,
  save_data,
  get_saved_data,
  upload_media,
  delete_draft,
} from "../../Controller/forms_data.controller.js";
import upload from "../../Middleware/upload.middleware.js";

const forms_data_router = Router();

forms_data_router.route("/get-form-data").get(get_form_data);
forms_data_router.route("/save-data").post(save_data);
forms_data_router.route("/saved-data").get(get_saved_data);
forms_data_router.route("/delete-draft/:id").delete(delete_draft);
forms_data_router
  .route("/upload-media/:inspectionId/:questionIndex")
  .post(upload.array("images", 5), upload_media);

export default forms_data_router;
