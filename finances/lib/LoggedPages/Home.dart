import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/Data.dart';
import '../data/GeneralResponse.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HomePage extends StatefulWidget{
  HomePage({Key? key } ) : super(key: key);

  HomePage.data(this.data, {Key? key } ) : super(key: key);

  late Data data;



  @override
  State<HomePage> createState() => _HomePage();

}

class _HomePage extends State<HomePage>{

  String _balance = "0";

  void atualizeBalance(String newBalance){
    setState(() {
      _balance = newBalance;
    });
  }

 @override
  Future<void> initState() async {
    //atualizeBalance("1000.00€");
/*
   GeneralResponse? response = await fetchInformations();
   if(response != null){
     _balance = response.amountTotal.toString();
   }
*/
    _balance = "1000.00€";
    super.initState();
    //load info

  }

  Future<GeneralResponse?> fetchInformations()async{
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString();
    final response = await http.get(Uri.parse(Data.urlBackend + '/client/general?mth=' + month + '&year='+ year),
    headers:
      {'Content-Type': 'application/json',
        'Authorization': widget.data.token.tokenType + ' ' + widget.data.token.token,
      },
    );
    
    if(response.statusCode == 200){
      return GeneralResponse.fromJson(jsonDecode(response.body));
    }

    return null;
  }



  @override
  Widget build(BuildContext context) {
    return  ListView(
      children: <Widget>[
        Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 30),
              child: const Text("Saldo Atual",
                style: TextStyle(color: Colors.blue, fontSize: 26),
                textAlign: TextAlign.left,
              )
            ),
            Container(
                margin: EdgeInsets.only(left: 20, top: 10),
                child: Text(_balance,
                  style: TextStyle(color: Colors.black54, fontSize: 26),
                  textAlign: TextAlign.left,
                ),
            )
          ],
        )
      ],
    );
  }

}
