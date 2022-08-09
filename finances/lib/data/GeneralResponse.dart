import 'dart:ffi';

class GeneralResponse{

  late Double _amountTotal;
  late Map<String, Double> _costsByCategories;
  late Map<String, Double> _costsByAccount;

  GeneralResponse();

  GeneralResponse.fields(
      this._amountTotal, this._costsByCategories, this._costsByAccount);

  Map<String, Double> get costsByAccount => _costsByAccount;

  set costsByAccount(Map<String, Double> value) {
    _costsByAccount = value;
  }

  Map<String, Double> get costsByCategories => _costsByCategories;

  set costsByCategories(Map<String, Double> value) {
    _costsByCategories = value;
  }

  Double get amountTotal => _amountTotal;

  set amountTotal(Double value) {
    _amountTotal = value;
  }

  factory GeneralResponse.fromJson(Map<String, dynamic> json){

    return GeneralResponse.fields(
      json['amountTotal'],
      json['costsByCategories'],
      json['costsByAccount']
    );
  }

}