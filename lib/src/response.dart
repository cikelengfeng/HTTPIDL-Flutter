import 'package:httpidl/src/http_impl/http_response.dart';
import 'package:httpidl/src/response_content.dart';

abstract class ResponseBuilder<T extends Response> {
	T fromResponseContent(ResponseContent respContent, HTTPResponse rawResponse);
}

abstract class Response {
	
}