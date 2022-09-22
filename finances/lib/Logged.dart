import 'package:finances/LoggedPages/Home.dart';
import 'package:finances/LoggedPages/SettingsPage.dart';
import 'package:finances/LoggedPages/TransactionsPage.dart';
import 'package:finances/data/Data.dart';
import 'package:flutter/material.dart';

import 'LoggedPages/AddTransactionPage.dart';



class LoggedPage extends StatefulWidget{
  LoggedPage.d(this.data, {Key? key } ) : super(key: key) ;
  late Data data;


  LoggedPage({Key? key } ) : super(key: key);

  @override
  State<LoggedPage> createState() => _Logged();

}

class _Logged extends State<LoggedPage>{

  int _selectIndex = 0;
  PageController pageController = PageController();

  void onTap(int index){
    setState(() {
      _selectIndex = index;
    });
    pageController.jumpToPage(index);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: PageView(
        controller: pageController,
        children: [
          HomePage.data(widget.data),
          TransactionsPage.data(widget.data),
          AddTransactionPage.data(widget.data),
          SettingsPage.data(widget.data),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar (items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.moving), label: "Movimentos"),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: "Adicionar"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil")
      ],
      currentIndex: _selectIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: onTap,
      ),
    );

  }

}

/*
return Container(
child: Center(
child:
TextButton(
onPressed: () {
Navigator.of(context).pushNamed('/notLogged');
},
child: Text("TEXT BUTTON"),
)
)
);
*/
