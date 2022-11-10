import 'package:flutter_clean_architecture/core/Interfaces/http_response.dart';

abstract class IHttpClient {
  Future<HttpResponse> get(String url);
}
