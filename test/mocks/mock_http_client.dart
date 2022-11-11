import 'package:flutter_clean_architecture/core/http_client/http_client_implementation.dart';
import 'package:flutter_clean_architecture/core/http_client/http_client_interface.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements IHttpClient {}
