class Token {
  String _token;
  String _tokenType;

  Token(this._token, this._tokenType);

  String get tokenType => _tokenType;

  set tokenType(String value) {
    _tokenType = value;
  }

  String get token => _token;

  set token(String value) {
    _token = value;
  }

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        json['token'],
        json['tokenType']
    );
  }

}