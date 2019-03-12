import 'package:httpidl/src/http_data.dart';
import 'package:httpidl/src/http_file.dart';

abstract class RequestContentKeyType {
    String asHTTPParamterKey();
}

abstract class RequestContentConvertible {
    RequestContent asRequestContent();
}

enum RequestContentType {
	number,
	string,
	file,
	data,
	array,
	dictionary
}

class RequestContent {
	RequestContentType type;
	dynamic value;

	RequestContent(RequestContentType type, dynamic value) {
		this.type =type;
		this.value =value;
	}

	factory RequestContent.number(num value) {
		return RequestContent(RequestContentType.number, value);
	}

	factory RequestContent.string(String value) {
		return RequestContent(RequestContentType.string, value);
	}

	factory RequestContent.file(HTTPFile value) {
		return RequestContent(RequestContentType.file, value);
	}

	factory RequestContent.data(HTTPData value) {
		return RequestContent(RequestContentType.data, value);
	}

	factory RequestContent.array(List<RequestContent> value) {
		return RequestContent(RequestContentType.array, value);
	}

	factory RequestContent.dictionary(Map<RequestContentKeyType, RequestContent> value) {
		return RequestContent(RequestContentType.dictionary, value);
	}

	num asNumber() {
		if (this.type ==RequestContentType.number) {
			return value;
		}
		return null;
	}

	String asString() {
		if (this.type ==RequestContentType.string) {
			return value;
		}	
		return null;
	}

	HTTPFile asFile() {
		if (this.type ==RequestContentType.file) {
			return value;
		}	
		return null;
	}

	HTTPData asData() {
		if (this.type ==RequestContentType.data) {
			return value;
		}	
		return null;
	}

	List<RequestContent> asArray() {
		if (this.type ==RequestContentType.array) {
			return value;
		}	
		return null;
	}

	Map<RequestContentKeyType, RequestContent> asDictionary() {
		if (this.type ==RequestContentType.dictionary) {
			return value;
		}	
		return null;
	}
}