
import 'package:finances/data/Token.dart';

class Data{

  late Token _token;
  String _userName;
  String _email;
  static const String _urlBackend = "http://192.168.1.65:8080";

  Data(this._userName, this._email);

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  Token get token => _token;

  set token(Token value) {
    _token = value;
  }

  static String get urlBackend => _urlBackend;
}