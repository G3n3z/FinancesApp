import 'dart:async';

import 'package:flutter/material.dart';

import '../data/Data.dart';
import '../data/GeneralResponse.dart';

import 'package:pie_chart/pie_chart.dart';

import '../utils/RequestFunctions.dart';
import 'package:finances/utils/DialogFunctions.dart';

class HomePage extends StatefulWidget{
  HomePage({Key? key } ) : super(key: key);

  HomePage.data(this.data, {Key? key } ) : super(key: key);

  late Data data;

  @override
  State<HomePage> createState() => _HomePage();

}

class _HomePage extends State<HomePage>{

  String _balance = "0";
  Map<String, double> _pieDataCategories = {};
  Map<String, double> _defaultpieDataCategories = {"Nao existem dados" : 1.0};
  Map<String, double> _pieDataAccounts = {};
  Map<String, double> _defaultpieDataAccounts = {"Nao existem dados" : 1.0};
  void atualizeBalance(String newBalance){
    setState(() {
      _balance = newBalance;
    });
  }

 @override
 void initState() {
    //atualizeBalance("1000.00€");

    _balance = "Loading";
    _pieDataCategories = widget.data.pieDataCategories;
    _pieDataAccounts = widget.data.pieDataAccounts;
    if(widget.data.fetchNeeded){
      Timer.run(() => showDialogg(context));
      initFetch();

    }else{
      _balance = widget.data.amountTotal.toString() + "€";
      _pieDataCategories = widget.data.costsByCategories;
      _pieDataAccounts = widget.data.costsByAccount;
    }

    super.initState();
    //load info

  }

  @override
  Widget build(BuildContext context) {

      return ListView(
      children:
        <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(left: 40, top: 50),
                child: const Text("Saldo Atual",
                  style: TextStyle(color: Colors.blue, fontSize: 26),
                  textAlign: TextAlign.left,
                )
              ),
              Container(
                  margin: EdgeInsets.only(left: 40, top: 10),
                  child: Text(_balance,
                    style: TextStyle(color: Colors.black54, fontSize: 26),
                    textAlign: TextAlign.left,
                  ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(right: 60),

                child: Text("Gastos por Categorias",
                  style: TextStyle(color: Colors.blue, fontSize: 26),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: PieChart(dataMap: ((_pieDataCategories.isNotEmpty) ? _pieDataCategories : _defaultpieDataCategories),
                  animationDuration:  Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  centerText: "",
                  legendOptions:  LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    legendLabels: {"aaa" : "aaa"}
                  ),
                  chartValuesOptions:   ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: true,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,

                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(right: 60),

                child: Text("Gastos por Contas",
                  style: TextStyle(color: Colors.blue, fontSize: 26),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: PieChart(dataMap: _pieDataAccounts.isNotEmpty ? _pieDataAccounts : _defaultpieDataAccounts,
                  animationDuration:  Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  centerText: "",
                  legendOptions:  LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions:  ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: false,
                    decimalPlaces: 1,
                  ),
                ),
              ),
            ],
          ),
        )

      ],
    );


  }

  void initFetch() async {

    GeneralResponse? response = await fetchInformations(widget.data);
    if(response != null){
      setData(widget.data, response);
    }

    setState(() {
      _balance = widget.data.amountTotal.toString() + "€";
      if(widget.data.costsByCategories.isNotEmpty) {
        _pieDataCategories = widget.data.costsByCategories;
      }else{
        _pieDataCategories = {"Nao existem dados" : 1.0};
      }
      if(widget.data.costsByAccount.isNotEmpty) {
        _pieDataAccounts = widget.data.costsByAccount;
      }else{
        _pieDataAccounts = {"Nao existem dados" : 1.0};
      }
    });

    Navigator.of(context).pop();


  }
  /*
  void _showDialog(BuildContext context) {
    showDialog(

        context: context,
        barrierDismissible: false,
        builder: (context)  {
          return Dialog(
        // The background color
            backgroundColor: Colors.white,

            child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        // The loading indicator
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 15,
                          width: 50,
                        ),
                        // Some text
                        Text('Carregando...')
                      ],
                    ),
                  ),
          );
        },
        );
  }


   */

/*
  Future<GeneralResponse?> fetchInformations()async{
    String month = DateTime.now().month.toString();
    String year = DateTime.now().year.toString();
    print('will fetch');

    final response = await http.get(Uri.parse(Data.urlBackend + '/client/general?mth=' + month + '&year='+ year),
    headers:
      {'Content-Type': 'application/json',
        'Authorization': widget.data.token.tokenType + ' ' + widget.data.token.token,
      },
    );

    if(response.statusCode == 200){
      widget.data.fetchNeeded = false;
      return GeneralResponse.fromJson(jsonDecode(response.body));
    }

    return null;
  }

   */

}
