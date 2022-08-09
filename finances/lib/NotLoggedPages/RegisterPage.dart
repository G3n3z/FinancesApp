import 'package:finances/data/Data.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{


  @override
  State<RegisterPage> createState() => _RegisterPage();

}


class _RegisterPage extends State<RegisterPage>{

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _validate = false;

  void onRegist(){
    Data data = Data(_email.text, _password.text);
    Navigator.of(context).pushNamed('/logged', arguments: data);
    //Navigator.of(context).pushNamed('/logged');
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
            controller: _email,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User Name',
                hintText: 'Enter valid mail id as abc@gmail.com'
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _password,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter correct password'
            ),
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