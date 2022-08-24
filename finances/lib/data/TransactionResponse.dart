

class TransactionResponse{

  late Map<String, double> accounts = {};
  late List<Transaction2> transactionResponses;
  Map<String, List<Transaction2>> transactionPerAccount = {};
  late int size;
  late bool lastPage;
  late bool pagination;

  TransactionResponse();

  TransactionResponse.response(this.accounts, this.transactionResponses, this.lastPage, this.pagination, this.size){
     transformTransactions();
  }
  
  void transformTransactions(){
    for (Transaction2 transaction in transactionResponses) {
      if(!transactionPerAccount.keys.contains(transaction.account)){
        List<Transaction2> list = List.of({transaction});
        transactionPerAccount.putIfAbsent(transaction.account, ()=> list);
      }else{
        transactionPerAccount.forEach((key, value) {
          if(key == transaction.account){
            value.add(transaction);
          }
        });
      }
    }
  }

  void fromJson(Map<String, dynamic> json) {
    accounts = {};
    if(json['accounts'] != null) {
      json['accounts'].forEach((v) {
        Map<String, dynamic> json2 = v;
        accounts.putIfAbsent(json2['name'], () => json2['balance']);
      });
    }
    size = json['size'];
    if(json['transactionResponses'] != null){

      //transactionResponses = List.filled(size, Transaction());
      transactionResponses = <Transaction2>[];
      json['transactionResponses'].forEach((v){
        transactionResponses.add(Transaction2.fromJson(v));
      });
    }
    size = json['size'];
    lastPage = json['lastPage'];
    pagination = json['pagination'];

  }
  
}

class Transaction2 {

  late String _name, _category, _account, _data, _entity;
  late double _amount;

  Transaction2();

  Transaction2.all(this._name, this._category, this._account, this._data,
      this._entity, this._amount);

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
  }

  get entity => _entity;

  set entity(value) {
    _entity = value;
  }

  get data => _data;

  set data(value) {
    _data = value;
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

  factory Transaction2.fromJson(Map<String, dynamic> v) {

    return Transaction2.all(
      v['name'],
      v['category'],
      v['account'],
      v['data'],
      v['entity'],
      v['amount']
    );

  }

}