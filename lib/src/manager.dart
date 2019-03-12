
import 'package:httpidl/src/configuration.dart';
import 'package:httpidl/src/error.dart';
import 'package:httpidl/src/http_impl/http_client.dart';
import 'package:httpidl/src/http_impl/http_request.dart';
import 'package:httpidl/src/http_impl/http_response.dart';
import 'package:httpidl/src/observer.dart';
import 'package:httpidl/src/request.dart';
import 'package:httpidl/src/response.dart';
import 'package:httpidl/src/response_decoder.dart';
import 'package:httpidl/src/rewriter.dart';

typedef ResponseHandler(params);

abstract class RequestManager {

	RequestManagerConfiguration configuration;

	Future<ResponseType> send<ResponseType extends Response>(Request request, responseHandler(ResponseType response), errorHandler(HIError error), progressHandler(double progress));
	Future<HTTPResponse> sendSimply(Request request, responseHandler(HTTPResponse response), errorHandler(HIError error), progressHandler(double progress));

	addObserver(Observer observer);
	removeObserver(Observer observer);
	addRewriter(Rewriter rewriter);
	removeRewriter(Rewriter rewriter);
}

// TODO:这个类需要保证线程安全
class BaseRequestManager extends RequestManager {

	static final shared =BaseRequestManagerConfiguration();
	DartHTTPClient clientImp =DartHTTPClient.shared;
	RequestManagerConfiguration _configuration;
	RequestManagerConfiguration get configuration {
		if (_configuration ==null) {
			return BaseRequestManagerConfiguration.shared;
		}
		return _configuration;
	}

	set configuration(RequestManagerConfiguration config) {
		_configuration =config;
	}

	List<Observer> observers = [];
	List<Rewriter> rewriters = [];

	@override
	addObserver(Observer observer) {
		observers.add(observer);
		return null;
	}

	@override
	addRewriter(Rewriter rewriter) {
		rewriters.add(rewriter);
		return null;
	}

	@override
	removeObserver(Observer observer) {
		observers.remove(observer);
		return null;
	}

	@override
	removeRewriter(Rewriter rewriter) {
		rewriters.remove(rewriter);
		return null;
	}

	

	@override
	Future<ResponseType> send<ResponseType extends Response>(Request request, Function(ResponseType response) responseHandler, Function(HIError error) errorHandler, Function(double progress) progressHandler) async {
		
	}

	//     public func send<ResponseType>(_ request: Request, responseHandler: ((ResponseType) -> Void)?, errorHandler: ((HIError) -> Void)?, progressHandler: ((Progress) -> Void)?) -> RequestFuture<ResponseType> where ResponseType : Response {
//         let future = RequestFuture<ResponseType>(request: request)
//         future.responseHandler = responseHandler
//         future.errorHandler = errorHandler
//         future.progressHandler = progressHandler
//         do {
//             self.willSend(request: request)
//             self.willEncode(request: request)
//             let requestEncoder = request.configuration.encoder
//             let responseDecoder = request.configuration.decoder
//             var encodedRequest = try requestEncoder.encode(request)
//             self.didEncode(request: request, encoded: encodedRequest)
//             if let rewriterResult = self.rewrite(request: encodedRequest) {
//                 switch rewriterResult {
//                 case .request(let rewritedRequest):
//                     encodedRequest = rewritedRequest
//                 case .response(let response):
//                     self.handle(response: response, responseDecoder: responseDecoder, future: future)
//                     //rewriter已经将request重写成response了，不需要再发请求了
//                     return future
//                 case .error(let error):
//                     self.handle(error: error, future: future)
//                     //rewriter已经将request重写成error了，不需要再发请求了
//                     return future
//                 }
//             }
//             encodedRequest.update(configuration: request.configuration)
//             let outputSteam = request.configuration.decoder.outputStream
//             let futureImpl = session.send(encodedRequest, usingOutput: outputSteam)
//             future.futureImpl = futureImpl
//             futureImpl.progressHandler = { p in
//                 guard let handler = future.progressHandler else {
//                     return
//                 }
//                 handler(p)
//             }
//             futureImpl.responseHandler = { (resp) in
//                 self.handle(response: resp, responseDecoder: responseDecoder, future: future)
//             }
//             futureImpl.errorHandler = { (error) in
//                 self.handle(error: error, future: future)
//             }
//             self.didSend(request: request)
//         } catch let error as HIError {
//             self.handle(error: error, future: future)
//         } catch let error {
//             assert(false, "抓到非 HIError 类型的错误！！！")
//             self.handle(error: BaseRequestManagerError.unknownError(rawError: error), future: future)
//         }
//         return future
//     }

	@override
	Future<HTTPResponse> sendSimply(Request request, Function(HTTPResponse response) responseHandler, Function(HIError error) errorHandler, Function(double progress) progressHandler) {
		// TODO: implement sendSimply
		return null;
	}

	// private 
	_willSend(Request request) {
		observers.forEach((observer) {
			observer.willSend(request);
		});
	}

	_didSend(Request request) {
		observers.forEach((observer) {
			observer.didSend(request);
		});
	}
  
	_willEncode(Request request) {
		observers.forEach((observer) {
			observer.willEncode(request);
		});
	}

	_didEncode(Request request, HTTPRequest encoded) {
		observers.forEach((observer) {
			observer.didEncode(request, encoded);
		});
	}

	_receiveError(HIError error, Request request) {
		observers.forEach((observer) {
			observer.receiveError(error, request);
		});
	}

	_receiveRawResponse(HTTPResponse response) {
		observers.forEach((observer) {
			observer.receiveResponse(response);
		});
	}

	_willDecode(HTTPResponse rawResponse) {
		observers.forEach((observer) {
			observer.willDecode(rawResponse);
		});
	}

	_didDecode(HTTPResponse rawResponse, Response decoded) {
		observers.forEach((observer) {
			observer.didDecode(rawResponse, decoded);
		});
	}

	RequestRewriterResult _rewriteRequest(HTTPRequest request) {
		if (rewriters.isEmpty) {
			return null;
		}
		RequestRewriterResult ret =RequestRewriterResult.fromRequest(request);
		var req =request;
		rewriters.forEach((rewriter) {
			var result =rewriter.rewriteRequest(req);
			ret = result;
			switch (result.type) {
			  	case RequestRewriterResultType.request:
					req = result.asRequest();
					break;
			  	default:
				  	break;
			}
		});
		return ret;
	}

	ResponseRewriterResult _rewriteResponse(HTTPResponse response) {
		if (rewriters.isEmpty) {
			return null;
		}
		ResponseRewriterResult ret =ResponseRewriterResult.fromResponse(response);
		var resp =response;
		rewriters.forEach((rewriter) {
			var rewriterResult =rewriter.rewriteResponse(response);
			ret =rewriterResult;
			switch (rewriterResult.type) {
			  	case ResponseRewriterResultType.response: 
					resp = rewriterResult.asResponse();
				break;
				default:
			  	break;
			}
		});
		return ret;
	}

	_handleTypedResponse<T extends Response>(HTTPResponse response, Decoder responseDecoder, Future<T> future, ResponseBuilder<T> responseBuilder) {
		var resp =response;
		{
			var responseRewriteResult = _rewriteResponse(response);
			if (responseRewriteResult != null) {
				switch (responseRewriteResult.type) {
					case ResponseRewriterResultType.response:
						resp = responseRewriteResult.asResponse();
						break;
					case ResponseRewriterResultType.error:
						_handleError(responseRewriteResult.asError(), future);
						break;
					default:
						break;
				}
			}
		}
		_receiveRawResponse(resp);
		_willDecode(resp);
		try {
			var content =responseDecoder.decode(resp);
			var typedResponse =responseBuilder.fromResponseContent(content, resp);
			_didDecode(resp, typedResponse);
			//TODO: 还没实现完
			//             future.notify(response: httpIdlResponse)
		} catch (error) {
			_handleError(error, future);
		}
	}

	_handleRawResponse(HTTPResponse response, Future<HTTPResponse> future) {
		var resp =response;
		{
			var responseRewriteResult = _rewriteResponse(response);
			if (responseRewriteResult != null) {
				switch (responseRewriteResult.type) {
					case ResponseRewriterResultType.response:
						resp = responseRewriteResult.asResponse();
						break;
					case ResponseRewriterResultType.error:
						_handleError(responseRewriteResult.asError(), future);
						break;
					default:
						break;
				}
			}
		}
//         future.notify(response: resp)
		_receiveRawResponse(resp);
	}

	_handleError(HIError error, Future) {
		// TODO:还没实现完
//         future.notify(error: error)
//         self.receive(error: error, request: future.request)
	}
}
    
//     public func send(_ request: Request, responseHandler: ((HTTPResponse) -> Void)?, errorHandler: ((HIError) -> Void)?, progressHandler: ((Progress) -> Void)?) -> RequestFuture<HTTPResponse> {
//         let future = RequestFuture<HTTPResponse>(request: request)
//         future.responseHandler = responseHandler
//         future.errorHandler = errorHandler
//         future.progressHandler = progressHandler
//         do {
//             self.willSend(request: request)
//             self.willEncode(request: request)
//             let requestEncoder = request.configuration.encoder
//             var encodedRequest = try requestEncoder.encode(request)
//             self.didEncode(request: request, encoded: encodedRequest)
            
//             if let rewriterResult = self.rewrite(request: encodedRequest) {
//                 switch rewriterResult {
//                 case .request(let rewritedRequest):
//                     encodedRequest = rewritedRequest
//                 case .response(let response):
//                     self.handle(response: response, future: future)
//                     //rewriter已经将request重写成response了，不需要再发请求了
//                     return future
//                 case .error(let error):
//                     self.handle(error: error, future: future)
//                     //rewriter已经将request重写成error了，不需要再发请求了
//                     return future
//                 }
//             }
//             encodedRequest.update(configuration: request.configuration)
//             let outputSteam = OutputStream(toMemory: ())
//             let futureImpl = session.send(encodedRequest, usingOutput: outputSteam)
//             future.futureImpl = futureImpl
//             futureImpl.progressHandler = { p in
//                 guard let handler = future.progressHandler else {
//                     return
//                 }
//                 handler(p)
//             }
//             futureImpl.responseHandler = { (resp) in
//                 self.handle(response: resp, future: future)
//             }
//             futureImpl.errorHandler = { (error) in
//                 self.handle(error: error, future: future)
//             }
//             self.didSend(request: request)
//         } catch let error as HIError {
//             self.handle(error: error, future: future)
//         } catch let error {
//             assert(false, "抓到非 HIError 类型的错误！！！")
//             self.handle(error: BaseRequestManagerError.unknownError(rawError: error), future: future)
//         }
//         return future
//     }
// }