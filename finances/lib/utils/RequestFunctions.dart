

import 'package:finances/data/Account.dart';
import 'package:finances/data/Category.dart';
import 'package:finances/data/Entity.dart';
import 'package:finances/data/Transaction.dart';

import '../data/Data.dart';
import '../data/GeneralResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../data/Token.dart';

Future<GeneralResponse?> fetchInformations(Data data)async{
  String month = DateTime.now().month.toString();
  String year = DateTime.now().year.toString();
  print('will fetch');

  final response = await http.get(Uri.parse(Data.urlBackend + '/client/general?mth=' + month + '&year='+ year),
    headers:
    {'Content-Type': 'application/json',
      'Authorization': data.token.tokenType + ' ' + data.token.token,
    },
  );

  if(response.statusCode == 200){
    data.fetchNeeded = false;
    return GeneralResponse.fromJson(jsonDecode(response.body));
  }

  return null;
}

void setData(Data data, GeneralResponse response) async{
  data.amountTotal = response.amountTotal;
  data.pieDataCategories = response.costsByCategories;
  data.pieDataAccounts = response.costsByAccount;
  data.transaction = response.transactions!;
  data.accounts = response.accounts!;
  data.categories = response.categories!;
  data.entities = response.entities!;
}

Future<Transaction?> sendTransaction(Transaction transaction, Data data) async{
  final response = await http.post(Uri.parse(Data.urlBackend + '/transaction'),
    headers:
    {'Content-Type': 'application/json',
      'Authorization': data.token.tokenType + ' ' + data.token.token,
    },
    body: jsonEncode(transaction.toJson())
  );

  if(response.statusCode == 201){
    Map<String,dynamic> json = jsonDecode(response.body);
    return Transaction.fromJson(json['transation']);
  }
  return null;
}

Future<Account?> addAccountRequest(Account account, Data data)async{

  final http.Response response = await http.post(Uri.parse(Data.urlBackend + '/account'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': data.token.tokenType + ' ' + data.token.token,
    },
    body: jsonEncode(account.toJson())
  );

  if(response.statusCode == 201){
    return account;
  }
  else{
    return null;
  }
}


Future<Category?> addCategoryRequest(Category category, Data data) async{
  final http.Response response = await http.post(Uri.parse(Data.urlBackend + '/category'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': data.token.tokenType + ' ' + data.token.token,
      },
      body: jsonEncode(category.toJson())
  );

  if(response.statusCode == 201){
    return category;
  }
  else{
    return null;
  }
}

Future<Entity?> addEntityRequest(Entity entity, Data data) async{
  final http.Response response = await http.post(Uri.parse(Data.urlBackend + '/entity'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': data.token.tokenType + ' ' + data.token.token,
      },
      body: jsonEncode(entity.toJson())
  );

  if(response.statusCode == 201){
    return entity;
  }
  else{
    return null;
  }
}

Future<Token?> register(String email, String password, String name)async{

  var body =  jsonEncode(<String, String>{
    'email' : 'daniel@gmail.com',//_email.text,
    'password' : 'abc'});
  final http.Response response;
  print(body);
  try {
    response = await http.post(
        Uri.parse(Data.urlBackend + '/auth/register'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'asdasd'
        },
        body: jsonEncode(<String, String>{
          'name' : name,
          'email': email,
          'password': password,
        },
        )
    );
  }catch(e){
    return null;
  }
  if(response.statusCode == 201){
    print('Ok');
    return Token.fromJson(jsonDecode(response.body));
  }else{
    print(response.statusCode);
  }
  return null;
}
