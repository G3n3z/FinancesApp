import 'package:finances/data/Data.dart';
import 'package:finances/utils/DialogFunctions.dart';
import 'package:finances/utils/RequestFunctions.dart';
import 'package:flutter/material.dart';

import '../data/Token.dart';

class RegisterPage extends StatefulWidget{


  @override
  State<RegisterPage> createState() => _RegisterPage();

}


class _RegisterPage extends State<RegisterPage>{

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  String? _passwordErrorMessage = null;
  String? _nameErrorMessage = null;
  String? _emailErrorMessage = null;

  void onRegist()async{
    bool error = false;
    if(_email.text.isEmpty){
      setState(() =>  _emailErrorMessage = "Password is empty");

      error = true;
    }
    if(_name.text.isEmpty){
      setState(() =>  _nameErrorMessage = "Password is empty");
      error = true;
    }
    if(_password.text.isEmpty){
      setState(() => _passwordErrorMessage = "Password is empty");

      error = true;
    }
    if(error){
      return;
    }
    Token? token = await register(_email.text, _password.text, _name.text);
    if(token == null){
      showDialogError(context, "Email or Password invalid");
      return;
    }
    Data data = Data(_email.text, _password.text);
    data.token = token;
    Navigator.of(context).pushNamed('/logged', arguments: data);
    //Navigator.of(context).pushNamed('/logged');
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(50),
          child: const Text(
            "Register",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.cyan, fontSize: 30),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _name,
            decoration:  InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
                hintText: 'Enter as valid name',
                errorText: _nameErrorMessage
            ),
            onChanged: (text) {
              if(_nameErrorMessage != null){
                setState(() => _nameErrorMessage = null);
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _email,
            decoration:  InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Email',
                hintText: 'Enter valid mail id as abc@gmail.com',
                errorText: _emailErrorMessage
            ),
            onChanged: (text) {
              if(_emailErrorMessage != null){
                setState(() => _emailErrorMessage = null);
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _password,
            decoration:  InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter correct password',
                errorText: (_passwordErrorMessage)
            ),
            onChanged: (text) {
              if(_passwordErrorMessage != null){
                setState(() => _passwordErrorMessage = null);
              }
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          width: 250,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(20)
          ),
          child: TextButton(
            onPressed: onRegist,
            child: const Text("Register",
            style: TextStyle(color: Colors.white, fontSize: 16),
            )
          )


        )
      ],
    );

  }

}