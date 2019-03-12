

import 'package:httpidl/src/configuration.dart';
import 'package:httpidl/src/request_content.dart';

abstract class Request {
    String method;
    RequestConfiguration  configuration;
    String  uri;
    RequestContent content;//nullable
}

class PlainRequest extends Request {
    String method;
    RequestConfiguration configuration;
    String uri;
    RequestContent content;//nullable
    
    PlainRequest(String method, String uri, RequestConfiguration configuration, RequestContent content) {
        method = method;
		configuration = configuration;
        uri = uri;
        content = content;
    }
}