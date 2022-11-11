class HttpResponse {
  final dynamic data;
  final int statusCode;

  HttpResponse(
    this.data,
    this.statusCode,
  );

  @override
  String toString() {
    return 'HttpResponse(data:$data, statusCode:$statusCode)';
  }
}
