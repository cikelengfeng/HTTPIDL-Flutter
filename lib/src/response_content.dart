import 'package:httpidl/src/http_data.dart';
import 'package:httpidl/src/http_file.dart';

abstract class ResponseContentConvertible<T> {
	T fromResponseContent(ResponseContent responseContent);
}	

abstract class ResponseContentKeyType<T> {
    T fromString(String string);
}

enum ResponseContentType {
	number,
	string,
	file,
	data,
	array,
	dictionary
}

class ResponseContent {
	ResponseContentType type;
	dynamic value;

	ResponseContent(ResponseContentType type, dynamic value) {
		this.type =type;
		this.value =value;
	}

	factory ResponseContent.number(num value) {
		return ResponseContent(ResponseContentType.number, value);
	}

	factory ResponseContent.string(String value) {
		return ResponseContent(ResponseContentType.string, value);
	}

	factory ResponseContent.file(HTTPFile value) {
		return ResponseContent(ResponseContentType.file, value);
	}

	factory ResponseContent.data(HTTPData value) {
		return ResponseContent(ResponseContentType.data, value);
	}

	factory ResponseContent.array(List<ResponseContent> value) {
		return ResponseContent(ResponseContentType.array, value);
	}

	factory ResponseContent.dictionary(Map<ResponseContentType, ResponseContent> value) {
		return ResponseContent(ResponseContentType.dictionary, value);
	}

	num asNumber() {
		if (this.type ==ResponseContentType.number) {
			return value;
		}
		return null;
	}

	String asString() {
		if (this.type ==ResponseContentType.string) {
			return value;
		}	
		return null;
	}

	HTTPFile asFile() {
		if (this.type ==ResponseContentType.file) {
			return value;
		}	
		return null;
	}

	HTTPData asData() {
		if (this.type ==ResponseContentType.data) {
			return value;
		}	
		return null;
	}

	List<ResponseContent> asArray() {
		if (this.type ==ResponseContentType.array) {
			return value;
		}	
		return null;
	}

	Map<ResponseContentKeyType, ResponseContent> asDictionary() {
		if (this.type ==ResponseContentType.dictionary) {
			return value;
		}	
		return null;
	}
}