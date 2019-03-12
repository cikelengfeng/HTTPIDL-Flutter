import 'dart:io' show File;

import 'package:httpidl/src/request_content.dart';
import 'package:httpidl/src/response_content.dart';

class HTTPFile implements RequestContentConvertible, ResponseContentConvertible<HTTPFile> {
	File file;
	String fileName;
	String mimeType;

	HTTPFile(String path, String fileName, String mimeType) {
		this.file =File(path);
		this.fileName =fileName;
		this.mimeType =mimeType;
	}

	@override
	RequestContent asRequestContent() {
		return RequestContent.file(this);
	}

	@override
	HTTPFile fromResponseContent(ResponseContent responseContent) {
		return responseContent.asFile();
	}

}