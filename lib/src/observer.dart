import 'package:httpidl/src/error.dart';
import 'package:httpidl/src/http_impl/http_request.dart';
import 'package:httpidl/src/http_impl/http_response.dart';
import 'package:httpidl/src/request.dart';
import 'package:httpidl/src/response.dart';

abstract class Observer {
  	willSend(Request request);
    didSend(Request request);
    willEncode(Request request);
    didEncode(Request request, HTTPRequest encoded);
	receiveError(HIError error, Request request);
    receiveResponse(HTTPResponse rawResponse);
    willDecode(HTTPResponse rawResponse);
    didDecode(HTTPResponse rawResponse, Response decodedResponse);
}