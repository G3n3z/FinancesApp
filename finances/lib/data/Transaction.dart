class Transaction{

  late String _name, _category, _account, _entity;
  late double _amount;
  late DateTime _date;

  /// Constructors

  Transaction();

  Transaction.all(this._name, this._category, this._account, this._entity,
      this._amount, this._date);

  Transaction.fromJson(Map<String, dynamic > json){
    _name = json['name'];
    _category = json['category'];
    _account = json['account'];
    _date = stringToDate(json['data']);
    _entity = json['entity'];
    _amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = _name;
    data['category'] = _category;
    data['account'] = _account;
    data['data'] = _date.toString();
    data['entity'] = _entity;
    data['amount'] = _amount;
    return data;
  }


  DateTime stringToDate(String data){

    List<String> array = data.split("-");

    int year = int.parse(array[0]);
    int month = int.parse(array[1]);
    int day = int.parse(array[2].split(" ")[0]);

    return DateTime(year, month, day);
  }
  
  
  /// Getters and Setters
  DateTime get date => _date;


  set date(DateTime value) {
    _date = value;
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  get entity => _entity;

  set entity(value) {
    _entity = value;
  }

  get account => _account;

  set account(value) {
    _account = value;
  }

  get category => _category;

  set category(value) {
    _category = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int compareTo(Transaction b) {
    return -date.compareTo(b.date);
  }
}