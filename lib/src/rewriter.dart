import 'package:httpidl/src/error.dart';
import 'package:httpidl/src/http_impl/http_request.dart';
import 'package:httpidl/src/http_impl/http_response.dart';

enum RequestRewriterResultType {
	request,
	response,
	error
}

class RequestRewriterResult {
	RequestRewriterResultType type;
	dynamic value;

	_() {

	}

	RequestRewriterResult.fromRequest(HTTPRequest request) {
		type =RequestRewriterResultType.request;
		value =request;
	}

	RequestRewriterResult.fromResponse(HTTPResponse response) {
		type =RequestRewriterResultType.response;
		value =response;
	}

	RequestRewriterResult.fromError(HIError error) {
		type =RequestRewriterResultType.error;
		value =error;
	}

	asRequest() {
		if (type !=RequestRewriterResultType.request) {
			return null;
		}
		return value;
	}

	asResponse() {
		if (type !=RequestRewriterResultType.response) {
			return null;
		}
		return value;
	}

	asError() {
		if (type !=RequestRewriterResultType.error) {
			return null;
		}
		return value;
	}
}

enum ResponseRewriterResultType {
	response,
	error
}

class ResponseRewriterResult {
	ResponseRewriterResultType type;
	dynamic value;

	_() {

	}

	ResponseRewriterResult.fromResponse(HTTPResponse response) {
		type =ResponseRewriterResultType.response;
		value =response;
	}

	ResponseRewriterResult.fromError(HIError error) {
		type =ResponseRewriterResultType.error;
		value =error;
	}

	asResponse() {
		if (type !=ResponseRewriterResultType.response) {
			return null;
		}
		return value;
	}

	asError() {
		if (type !=ResponseRewriterResultType.error) {
			return null;
		}
		return value;
	}
}

abstract class Rewriter {
	RequestRewriterResult rewriteRequest(HTTPRequest request);
	ResponseRewriterResult rewriteResponse(HTTPResponse response);
}