import 'dart:async';
import 'dart:convert';

import 'package:finances/LoggedPages/Home.dart';
import 'package:finances/data/Data.dart';
import 'package:finances/data/Token.dart';
import 'package:finances/utils/DialogFunctions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LoginPage extends StatefulWidget{


  @override
  State<LoginPage> createState() => _LoginPage();

}


class _LoginPage extends State<LoginPage>{
  String message = "";
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _validate = false;

  void onLogin()async{

    if(_email.text.isEmpty){
      message = "Está vazio";
      setState(() {
        _validate = true;
      });
    }else{
      setState(() {
        _validate = false;
      });
      bool buttonCancelClicked = false;
      Timer.run(() => showDialogg(context));
      Token? token = await login();
      //print(token!.token);
      Navigator.of(context).pop();
      if(token == null){
        showDialogError(context, "Email or Password Incorrect");
        return;
      }


      Data data = Data( _email.text, _password.text);
      data.token= token;
      Navigator.of(context).pushNamed('/logged', arguments: data);
      //Navigator.of(context).pushNamed('/logged');
    }

  }

  Future<Token?> login()async{

    var body =  jsonEncode(<String, String>{
    'email' : 'daniel@gmail.com',//_email.text,
    'password' : 'abc'});
    final Response respose;
    print(body);
    try {
          respose = await http.post(
          Uri.parse(Data.urlBackend + '/auth/login'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'asdasd'
          },
          body: jsonEncode(<String, String>{
            'email': _email.text,
            'password': _password.text
          },
          )
      );
    }catch(e){
      return null;
    }
    if(respose.statusCode == 200){
      print('Ok');
      return Token.fromJson(jsonDecode(respose.body));
    }else{
      print(respose.statusCode);
    }
    return null;
  }


  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(50),
          child: const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue, fontSize: 30),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: _email,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
                hintText: 'Enter valid mail id as abc@gmail.com',
                errorText: _validate ? message : null,
            ),

          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: _password,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter correct password'
            ),
          ),
        ),
        TextButton(
          onPressed: (){
            //TODO FORGOT PASSWORD SCREEN GOES HERE
          },
          child: const Text(
            'Forgot Password',
            style: TextStyle(color: Colors.blue, fontSize: 15),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 30),
            width: 250,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)
            ),
            child: TextButton(
                onPressed: onLogin,
                child: const Text("Login",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )
            )


        )
      ],
    );

  }

}