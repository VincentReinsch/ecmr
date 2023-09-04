import 'package:vialticecmr/model/api_error.dart';

class ApiResponse {
  // _data will hold any response converted into
  // its own object. For example user.
  late Object _data = Object();
  // _apiError will hold the error object
  late ApiError _apiError = ApiError(error: '');

  Object get Data => _data;
  set Data(Object data) => _data = data;

  ApiError get GetApiError => _apiError;
  set setApiError(ApiError error) => _apiError = error;
}
