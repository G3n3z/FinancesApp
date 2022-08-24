class Account{
  late String _name;
  late double _balance;

  Account(this._name, this._balance);

  Account.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _balance = json['balance'];
  }

  double get balance => _balance;

  set balance(double value) {
    _balance = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = _name;
    data['balance'] = _balance;
    return data;
  }
}