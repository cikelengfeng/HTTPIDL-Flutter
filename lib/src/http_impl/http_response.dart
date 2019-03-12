import 'package:httpidl/src/http_impl/http_request.dart';

abstract class HTTPResponse {
	int statusCode;
	Map<String, String> headers;
	Stream bodyStream;
	HTTPRequest request;
}

class HTTPBaseResponse extends HTTPResponse {
	HTTPBaseResponse(int statusCode, Map<String, String> headers, Stream bodyStream, HTTPRequest request) {
		this.statusCode =statusCode;
		this.headers =headers;
		this.bodyStream =bodyStream;
		this.request =request;
	}
}