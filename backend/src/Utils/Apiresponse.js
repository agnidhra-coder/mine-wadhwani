class ApiResponse {
  constructor(statusCode, data = null, message = "Success") {
    this.success = statusCode < 400;
    this.statusCode = statusCode;
    this.message = message;
    this.data = data;
  }

  static success(data, message = "Success", statusCode = 200) {
    return new ApiResponse(statusCode, data, message);
  }

  static error(
    message = "Something went wrong",
    statusCode = 500,
    errors = null,
  ) {
    return {
      success: false,
      statusCode,
      message,
      errors,
    };
  }
}

export default ApiResponse;
