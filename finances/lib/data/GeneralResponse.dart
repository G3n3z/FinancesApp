import 'dart:ffi';

import 'package:finances/data/Account.dart';
import 'package:finances/data/Category.dart';
import 'package:finances/data/Entity.dart';
import 'package:finances/data/Transaction.dart';

class GeneralResponse{

  late double _amountTotal;
  late Map<String, double> _costsByCategories;
  late Map<String, double> _costsByAccount;
  List<Account>? accounts;
  List<Transaction>? transactions;
  List<Category>? categories;
  List<Entity>? entities;



  GeneralResponse();

  GeneralResponse.fields(
      this._amountTotal, this._costsByCategories, this._costsByAccount);

  Map<String, double> get costsByAccount => _costsByAccount;

  set costsByAccount(Map<String, double> value) {
    _costsByAccount = value;
  }

  Map<String, double> get costsByCategories => _costsByCategories;

  set costsByCategories(Map<String, double> value) {
    _costsByCategories = value;
  }

  double get amountTotal => _amountTotal;

  set amountTotal(double value) {
    _amountTotal = value;
  }

  GeneralResponse.fromJson(Map<String, dynamic> json){

    if(json['amountTotal'] != null){
      _amountTotal = json['amountTotal'];
    }
    if(json['costsByCategories'] != null){
      _costsByCategories =  Map<String, double>.from(json['costsByCategories']);
    }
    if(json['costsByAccount'] != null ){
      _costsByAccount = Map<String, double>.from(json['costsByAccount']);
    }

    if (json['accounts'] != null) {
      accounts = <Account>[];
      json['accounts'].forEach((v) {
        accounts!.add(Account.fromJson(v));
      });
    }
    if (json['transactions'] != null) {
      transactions = <Transaction>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transaction.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }
    if (json['entities'] != null) {
      entities = <Entity>[];
      json['entities'].forEach((v) {
        entities!.add(Entity.fromJson(v));
      });
    }

/*
    return GeneralResponse.fields(
      json['amountTotal'],
      Map<String, double>.from(json['costsByCategories']),
      Map<String, double>.from(json['costsByAccount'])
    );
    */

  }

}