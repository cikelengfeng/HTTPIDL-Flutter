import 'package:httpidl/src/request_content.dart';
import 'package:httpidl/src/response_content.dart';

class HTTPData implements RequestContentConvertible, ResponseContentConvertible<HTTPData> {
	List<int> data;
	String fileName;
	String mimeType;

	HTTPData(List<int> data, String fileName, String mimeType) {
		this.data =data;
		this.fileName =fileName;
		this.mimeType =mimeType;
	}

	@override
	RequestContent asRequestContent() {
		return RequestContent.data(this);
	}

	@override
	HTTPData fromResponseContent(ResponseContent responseContent) {
		var value =responseContent.asData();
		if (value !=null) {
			return value;
		}
		var httpFile =responseContent.asFile();
		if (httpFile ==null) {
			return null;
		}	
		var file =httpFile.file;
		if (file ==null) {
			return null;
		}
		List<int> data = file.readAsBytesSync();
		return HTTPData(data, httpFile.fileName, httpFile.mimeType);
	}

}
