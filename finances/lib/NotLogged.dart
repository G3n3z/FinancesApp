import 'dart:ffi';

import 'package:flutter/material.dart';

import 'NotLoggedPages/LoginPage.dart';
import 'NotLoggedPages/RegisterPage.dart';

class NotLoggedPage extends StatefulWidget{
  const NotLoggedPage({Key? key}) : super(key: key);
  
 @override
  State<NotLoggedPage> createState() => _NotLogged();

}

class _NotLogged extends State<NotLoggedPage>{

  int _selectIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index){
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
          RegisterPage(),
          LoginPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.app_registration), label: "Registar"),
        BottomNavigationBarItem(icon: Icon(Icons.login), label: "Login")
      ],
      currentIndex: _selectIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: onTapped),
    );
  }

}