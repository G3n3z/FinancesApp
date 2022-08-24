
import 'package:finances/data/Account.dart';
import 'package:finances/data/Category.dart';
import 'package:finances/data/Entity.dart';
import 'package:finances/data/Token.dart';
import 'package:finances/data/Transaction.dart';
import 'package:finances/data/comparators/TransactionComparator.dart';


class Data{

  late Token _token;
  String _userName;
  String _email;
  static const String _urlBackend = "http://192.168.1.65:8080";

  double _amountTotal = 0;
  Map<String, double> costsByCategories = {
    "loading" : 1.0
  };
  Map<String, double> costsByAccount = {
    "loading" : 1.0
  };

  late List<Account> _accounts;
  late List<Entity> _entities;
  late List<Category> _categories;
  late List<Transaction> _transaction;
  bool fetchNeeded = true;


  
  ///Constructors
  Data(this._userName, this._email);


  double get amountTotal => _amountTotal;

  set amountTotal(double value) {
    _amountTotal = value;
  }

  /// Getters and Setters


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

  Map<String, double> get pieDataAccounts => costsByAccount;

  set pieDataAccounts(Map<String, double> value) {
    costsByAccount = value;
  }

  Map<String, double> get pieDataCategories => costsByCategories;

  set pieDataCategories(Map<String, double> value) {
    costsByCategories = value;
  }

  List<Transaction> get transaction => _transaction;

  set transaction(List<Transaction> value) {
    _transaction = value;
  }

  List<Category> get categories => _categories;

  set categories(List<Category> value) {
    _categories = value;
  }

  List<Entity> get entities => _entities;

  set entities(List<Entity> value) {
    _entities = value;
  }

  List<Account> get accounts => _accounts;

  set accounts(List<Account> value) {
    _accounts = value;
  }
  
  
  void orderTransactionsPerData(){
    _transaction.sort((a, b) {
      return a.compareTo(b);
    }
    );
  }

  List<Transaction>? getTransactionsPerAccount(String account){
    return _transaction.where((element) => element.account == account).toList();
  }
  
}