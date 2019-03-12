import 'package:httpidl/src/http_impl/http_request.dart';
import 'package:httpidl/src/http_impl/http_response.dart';

abstract class HTTPClient {
	Future<HTTPResponse> send(HTTPRequest request, Stream outputStream);
}	

class DartHTTPClient {
	static final shared =DartHTTPClient();
}