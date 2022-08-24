import 'package:finances/LoggedPages/settingsPages/SettingsHomePage.dart';
import 'package:finances/data/Data.dart';
import 'package:finances/route_generator/RouteGenerator.dart';
import 'package:flutter/material.dart';
class SettingsPage extends StatefulWidget{

  late Data data;


  SettingsPage({Key? key}) : super(key: key);

  SettingsPage.data(this.data, {Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPage();

}


class _SettingsPage extends State<SettingsPage>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/settings/home",
      onGenerateInitialRoutes: (String initialRouteName) {
        return [
          RouteGenerator.generateSettingsRoute(
              RouteSettings(name: initialRouteName, arguments: <Object>[widget.data, context])
          )
        ];
      },
      onGenerateRoute: RouteGenerator.generateSettingsRoute,

    );
  }

}