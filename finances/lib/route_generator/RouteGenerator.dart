
import 'package:finances/LoggedPages/settingsPages/ManageAccount.dart';
import 'package:finances/LoggedPages/settingsPages/ManageCategory.dart';
import 'package:finances/LoggedPages/settingsPages/ManageEntityPage.dart';
import 'package:finances/LoggedPages/settingsPages/SettingsHomePage.dart';
import 'package:flutter/material.dart';
import 'package:finances/Logged.dart';
import 'package:finances/NotLogged.dart';

import '../data/Data.dart';


class RouteGenerator{


  static Route<dynamic> generateRoute(RouteSettings settings){

    Data data;
    if(settings.arguments is Data){
      data = settings.arguments as Data;
    }else {
      data = Data("username", "email");
    }

    switch(settings.name){
      case '/notLogged':
        return MaterialPageRoute(builder: (_) => NotLoggedPage());
      case '/logged':
        return MaterialPageRoute(builder: (_) => LoggedPage.d(data));
      default:
        return _errorRoute();
    }

  }


  static Route<dynamic> generateSettingsRoute(RouteSettings settings){

    Data data;
    List o;
    BuildContext? backContext = null;
    if(settings.arguments is Data){
      data = settings.arguments as Data;
    }else  {
      o = settings.arguments as List;
      data = o[0];
      backContext = o[1];
    }

    switch(settings.name){
      case '/settings/home':
        return MaterialPageRoute(builder: (_) => SettingsHomePage.dataContext(data, backContext!));
      case '/settings/manageAccount':
        return MaterialPageRoute(builder: (_) => ManageAccount.data(data));
      case "/settings/manageCategories":
        return MaterialPageRoute(builder: (_) => ManageCategoryPage.data(data));
      case "/settings/manageEntities":
        return MaterialPageRoute(builder: (_) => ManageEntityPage.data(data));
      default:
        return _errorRoute();
    }

  }




  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title:  Text("Error")
        ),
        body:  Center(
          child: Text("Error")
        )
      );
    } );
  }
  
}