import 'package:httpidl/src/http_option.dart';

abstract class HTTPRequest {
	String method;
	Map<String, String> headers;
	Uri uri;
	Stream bodyStream;

	CachePolicy cachePolicy;//nullable
    NetworkServiceType networkServiceType;//nullable
    double timeoutInterval;//nullable
    bool shouldUsePipelining;//nullable
    bool shouldHandleCookies;//nullable
    bool allowsCellularAccess;//nullable
    bool bodyStreaming;//nullable
	bool chunkedTransfer;//nullable
}

class HTTPBaseRequest extends HTTPRequest {

	HTTPBaseRequest(String method, Uri uri, Map<String, String> headers, Stream bodyStream) {
		this.method =method;
		this.uri =uri;
		this.headers =headers;
		this.bodyStream =bodyStream;
	}

	HTTPBaseRequest.from(HTTPRequest other) {
		HTTPBaseRequest(other.method, other.uri, other.headers, other.bodyStream);
		this.cachePolicy =other.cachePolicy;
		this.networkServiceType =other.networkServiceType;
		this.timeoutInterval =other.timeoutInterval;
		this.shouldUsePipelining =other.shouldUsePipelining;
		this.shouldHandleCookies =other.shouldHandleCookies;
		this.allowsCellularAccess=other.allowsCellularAccess;
		this.chunkedTransfer=other.chunkedTransfer;
	}
}