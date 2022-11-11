import 'package:flutter_clean_architecture/core/Interfaces/http_response.dart';
import 'package:flutter_clean_architecture/core/http_client/http_client_interface.dart';
import 'package:http/http.dart' as http;

class HttpClientCustom implements IHttpClient {
  final client = http.Client();

  @override
  Future<HttpResponse> get(String url) async {
    final uri = Uri.parse(url);
    final response = await client.get(uri);
    return HttpResponse(
      response.body,
      response.statusCode,
    );
  }
}
