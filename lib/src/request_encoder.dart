
abstract class Encoder {
  
}

class URLEncodedFormEncoder extends Encoder {
	static final shared =URLEncodedFormEncoder();
}

class URLEncodedQueryEncoder extends Encoder {
	static final shared =URLEncodedQueryEncoder();
}