import 'package:httpidl/src/http_impl/http_response.dart';
import 'package:httpidl/src/response_content.dart';

abstract class Decoder {
  	Stream outputStream;
    ResponseContent decode(HTTPResponse response);
}

class JSONDecoder extends Decoder {
	static final shared =JSONDecoder();

  @override
  ResponseContent decode(HTTPResponse response) {
    // TODO: implement decode
    return null;
  }
}