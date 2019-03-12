import 'dart:core';
import 'package:httpidl/src/http_option.dart';
import 'package:httpidl/src/request.dart';
import 'package:httpidl/src/request_encoder.dart';
import 'package:httpidl/src/response_decoder.dart';

typedef Encoder EncoderStrategy(Request request);
typedef Decoder DecoderStrategy(Request request);

abstract class RequestManagerConfiguration {
    String baseURLString;
    Map<String, String> headers;
    // var callbackQueue: DispatchQueue {get set}
    EncoderStrategy encoderStrategy;
    DecoderStrategy decoderStrategy;
    
    append(Map<String, String> headers);
}

abstract class RequestConfiguration {
    String baseURLString;
    Map<String, String> headers;
    // var callbackQueue: DispatchQueue {get set}
    Encoder encoder;
    Decoder decoder;
    CachePolicy cachePolicy;//nullable
    NetworkServiceType networkServiceType;//nullable
    double timeoutInterval;//nullable
    bool shouldUsePipelining;//nullable
    bool shouldHandleCookies;//nullable
    bool allowsCellularAccess;//nullable
    bool bodyStreaming;//nullable
    
    append(Map<String, String> headers);
}

class BaseRequestManagerConfiguration extends RequestManagerConfiguration {
  
static final shared = BaseRequestManagerConfiguration(); 

    BaseRequestManagerConfiguration() {
        baseURLString = "";
        headers = {};
		st(Request request) {
			Set<String> methodSet ={"PUT", "POST", "PATCH"};
			if (methodSet.contains(request.method)) {
				return URLEncodedFormEncoder.shared;
			}
			return URLEncodedQueryEncoder.shared;
		}
        encoderStrategy = st;
		decoderStrategy = (Request request) => JSONDecoder.shared;	
    }

    @override
    append(Map<String, String> headers) {
		this.headers.addAll(headers);
    }
  
}

class BaseRequestConfiguration extends RequestConfiguration {

	BaseRequestConfiguration() {
		baseURLString = "";
		headers = {};
	}

	@override
	append(Map<String, String> headers) {
		this.headers.addAll(headers);
	}

	factory BaseRequestConfiguration.fromManagerConfiguration(RequestManagerConfiguration managerConfiguration, Request request) {
		var config =BaseRequestConfiguration();
		config.baseURLString = managerConfiguration.baseURLString;
		config.headers = managerConfiguration.headers;
		config.encoder = managerConfiguration.encoderStrategy(request);
		config.decoder =managerConfiguration.decoderStrategy(request);
		return config;
	}
  
}