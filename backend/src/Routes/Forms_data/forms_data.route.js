import { Router } from "express";
import {
  get_form_data,
  save_data,
} from "../../Controller/forms_data.controller.js";
const forms_data_router = Router();
forms_data_router.route("/get-form-data").get(get_form_data);
forms_data_router.route("/save-data").post(save_data);
export default forms_data_router;
