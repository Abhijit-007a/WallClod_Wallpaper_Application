import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wall_clod/modal/appError.dart';

class ErrorHadling {
  apiErrorHadling(
    http.Response response,
  ) {
    var data = jsonDecode(response.body);
    ApiError apiError = new ApiError.fromJson(data);
    return apiError;
  }
}
