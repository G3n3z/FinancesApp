import 'dart:async';
import 'dart:convert';

import 'package:finances/data/Account.dart';
import 'package:finances/data/Transaction.dart';
import 'package:finances/data/TransactionResponse.dart';
import 'package:finances/utils/TranslateData.dart';
import 'package:flutter/material.dart';

import '../data/Data.dart';
import '../data/GeneralResponse.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pie_chart/pie_chart.dart';

import '../utils/RequestFunctions.dart';







class TransactionsPage extends StatefulWidget{

  TransactionsPage.data(this.data, {Key? key } ) : super(key: key);

  late Data data;



  @override
  State<TransactionsPage> createState() => _TransactionsPage();

}

class _TransactionsPage extends State<TransactionsPage>{


  List<String> itens = [];
  Account? accountSelected;
  String? _selected;
  String _balance = "loading";
  TransactionResponse? transactionResponse;
  List<Widget> _transactionsWidgets = <Widget>[];

  Color _backgroundTransaction = Color.fromRGBO(159, 197, 225, 1.0);

  DateTime stringToDate(String data){

    List<String> array = data.split("-");
    int year = int.parse(array[0]);
    int month = int.parse(array[1]);
    int day = int.parse(array[2]);

    return DateTime(year, month, day);
  }

  Map<DateTime, List<Transaction2>>? getMapOfTransactionPerData( String selected) {
    Map<DateTime, List<Transaction2>> transactionPerData = {};
    List<Transaction2>? transaction = transactionResponse
        ?.transactionPerAccount[selected];
    if(transaction != null){
      for (Transaction2 t in transaction) {
        DateTime date = stringToDate(t.data);
        if (transactionPerData.containsKey(date)) {
          transactionPerData[date]?.add(t);
        } else {
          List<Transaction2> l = <Transaction2>[];
          l.add(t);
          transactionPerData.putIfAbsent(date, () => l);
        }
      }
    }
    return transactionPerData;
  }


  void upgradeList(String selected) {
    List<Transaction>? transaction = widget.data.getTransactionsPerAccount(selected);

    if(transaction != null){
      transaction.sort((a,b) => a.compareTo(b));
      DateTime? date;
      double space = 0;
      for (int i = 0; i < transaction.length ; i++) {
        if(date == null || (date.day != transaction[i].date.day || date.month != transaction[i].date.month || date.year != transaction[i].date.year)){
          createDivider(TranslateData.translate(transaction[i].date, "pt"));
          createNewTransactionWidget(transaction[i], 0);
          space = 0;
        }
        else{
          createNewTransactionWidget(transaction[i], 15);
          space = 15;
        }
        date = transaction[i].date;

      }}
  }



  @override
  void initState() {
    /*
    createDivider("QUI, 11 AGO");
    createNewTransactionWidget(Transaction.all("Internet", "Casa", "CGD", "MEO", -28.99, DateTime(2022,08,11)), 0);
    createNewTransactionWidget(Transaction.all("Agua", "Casa", "CGD", "Aguas de Coimbra", -26.55, DateTime(2022,08,11)),10);
    createNewTransactionWidget(Transaction.all("Agua", "Casa", "CGD", "Aguas de Coimbra",-26.55, DateTime(2022,08,11)), 15);
    createDivider("QUA, 10 AGO");
    createNewTransactionWidget(Transaction.all("Agua", "Casa", "CGD", "Aguas de Coimbra",-26.55, DateTime(2022,08,11)),0);
    createNewTransactionWidget(Transaction.all("Agua", "Casa", "CGD", "Aguas de Coimbra", -26.55, DateTime(2022,08,11)), 15);
    createNewTransactionWidget(Transaction.all("Agua", "Casa", "CGD",  "Aguas de Coimbra", -26.55, DateTime(2022,08,11)), 15);
    createDivider("TER, 09 AGO");
    createNewTransactionWidget(Transaction.all("Agua", "Casa", "CGD",  "Aguas de Coimbra", -26.55, DateTime(2022,08,11)), 0);
*/
  //  Timer.run(() => _showDialog(context));
    if(widget.data.fetchNeeded){
      initFetch();
    }else{
      _transactionsWidgets = <Widget>[];
      if(widget.data.accounts.isNotEmpty){
        itens = widget.data.accounts.map((e) => e.name).toList();
        accountSelected = widget.data.accounts[0];
        _selected = accountSelected?.name;
        _balance = (accountSelected?.balance.toString())! + "€";
        upgradeList(_selected!);
      }
      //Navigator.of(context).pop();
    }

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.only(top: 60),
                  child: Container(
                      //margin: EdgeInsets.only(left: 40, top: 50),
                      child: const Text("Saldo Atual",
                        style: TextStyle(color: Colors.blue, fontSize: 26),
                        textAlign: TextAlign.left,
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(width: 3, color: Colors.blue)
                        )
                      ),
                      items: itens
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item,textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
                    )).toList(),
                    value: _selected,
                    onChanged: (item) => setState((){
                        _selected = item as String;
                        if(_selected != null) {
                           Account a = widget.data.accounts.where((account) => account.name == _selected).first;
                           accountSelected = a;
                           _balance = (accountSelected?.balance.toString())! + "€";
                           _transactionsWidgets = <Widget>[];
                           upgradeList(_selected!);
                        //print(_balance);
                       }
                    }),
                    ),
                  ),
                ),
                Text(_balance, style: TextStyle(fontSize: 20 ),)
              ],
            ),
          ),


        Container(
          
          child: Expanded(
            child: ListView(
              //padding: EdgeInsets.only(top: 30),

              children: _transactionsWidgets,
              scrollDirection: Axis.vertical,


            ),

          )
        )
      ],
    );
  }












  void initFetch()async {
      Timer.run(() => _showDialog(context));
      GeneralResponse? transactionResponse = await fetchInformations(widget.data);
      List<Widget> list = <Widget>[];

      if(transactionResponse != null){
        setData(widget.data, transactionResponse);
          setState(() {
            _transactionsWidgets = <Widget>[];
            itens = widget.data.accounts.map((e) => e.name).toList();
            accountSelected = widget.data.accounts[0];
            _selected = accountSelected?.name;
            _balance = (accountSelected?.balance.toString())! + "€";
            upgradeList(_selected!);
          });
          //upgradeList(transactionResponse, transactionResponse!.accounts.keys.toList()[1]);
        }
      Navigator.of(context).pop();
    }

    //Navigator.of(context).pop();
      //print(response);

/*
  Future<TransactionResponse?> fetchData({String? month, String? year, int? pageNo}) async {
    if(month == null || year == null){
      month = DateTime.now().month.toString();
      year = DateTime.now().year.toString();
    }
    pageNo ??= 0;
    final response = await http.get(Uri.parse(Data.urlBackend+"/transaction?mth=" + month + "&year=" + year +
        "&ord=desc&pageSize=20&pageNo=" + pageNo.toString()),
    headers: {
        'Content-Type': 'application/json',
        'Authorization': widget.data.token.tokenType + ' ' + widget.data.token.token,
    },
    );

    if(response.statusCode == 200){
      //var body = jsonDecode(response.body);
      TransactionResponse transactionResponse = TransactionResponse();
      transactionResponse.fromJson(jsonDecode(response.body));
      transactionResponse.transformTransactions();
      return transactionResponse;
    }


    return null;
  }

*/



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

  void createNewTransactionWidget(Transaction transaction, double spaceBetween){

    Widget widget =

    Container(
      //padding: EdgeInsets.only(top: ),
      height: 75,
      margin: EdgeInsets.only(left: 15,right: 15, top: spaceBetween),


      child: Card(
        color: _backgroundTransaction,
        child: Center(
          child: ListTile(
            trailing: SizedBox(
              width: 100,

              child: Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container( child: Text(transaction.amount.toString() + "€", style:
                    TextStyle(fontSize: 16, color: (transaction.amount > 0 ? Colors.green : Colors.red))),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Icon(Icons.arrow_forward)),
                ],
              ),
            ),
            onTap: (){
              //Navigator.of(context).pushNamed("/transactions/element", arguments: [this.widget.data, transaction] );
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionDetailsPage.all(this.widget.data, transaction),
                  ));
            },
            title: Row(
              children: [
                Container(
                  child: Text(transaction.name + "\n" + transaction.entity, style: TextStyle(fontSize: 16)),
                ),

              ],
            ),
            ),
        ),

    /*[
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin:  EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          child: Text(transaction.name, style: TextStyle(fontSize: 16)),
                        ),
                        Container(
                          child: Text(transaction.entity, style: TextStyle(fontSize: 16)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 120,
                child: Row(
                  children: [
                    Container(
                      margin:  EdgeInsets.only(left: 15,right: 20),
                      child:
                        Text(transaction.amount.toString() + "€", style: TextStyle(fontSize: 16)),
                    ),
                    Center(
                      child: Icon(Icons.arrow_forward),
                    )
                  ],
                ),
              ),
            ),
          ),
  /*        Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
            children:[
              Container(
                child: Text(transaction.amount.toString() + "€"),
              )
            ]
          ) */
        ],

     */
      ),
    );
    _transactionsWidgets.add(widget);
  }

  void createDivider(String data){
    Widget divider =
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(data, style: TextStyle(fontSize: 16, color: Colors.grey),),
                          ),
                          Divider(
                            height: 2,
                            thickness: 2,
                            color: Colors.grey,
                            indent: 20,
                            endIndent: 20,
                          ),

                        ],
                      ),
                    );
    _transactionsWidgets.add(divider);
  }

}

class TransactionDetailsPage extends StatefulWidget{
  late Data data;
  late Transaction transaction;


  TransactionDetailsPage.all(this.data, this.transaction, {Key? key}) : super(key: key);

  TransactionDetailsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=> _TransactionDetailsPage();
}

class _TransactionDetailsPage extends State<TransactionDetailsPage>{
  List<Widget> widgets = <Widget>[];

  @override
  void initState() {
    addLine("Nome: ", widget.transaction.name);
    addLine("Data: ", widget.transaction.date.toString());
    addLine("Conta: ", widget.transaction.account);
    addLine("Categoria: ", widget.transaction.category);
    addLine("Entidade: ", widget.transaction.entity);
    addLine("Valor: ", widget.transaction.amount.toString());

    super.initState();
  }

  void addLine(String property, String value){
    Widget widget = Container(
      height: 20,

      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(

        children: [
          Expanded(child: Align(
            alignment: Alignment.centerLeft,
            child: Text(property + ": " + value, style: TextStyle(fontSize: 16),),
          )),

        ],
      ),
    );
    widgets.add(widget);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.transaction.name, style: TextStyle(color: Colors.black),),
            leading: GestureDetector(
              onTap: () { Navigator.of(context).pop(); },
              child:
              Icon( Icons.arrow_back, color: Colors.black,  // add custom icons also
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: Container(
            margin: EdgeInsets.only(top: 50, left: 5, right: 5),
            color: Color.fromRGBO(131, 81, 81, 0.11372549019607843),
            height: 400,
            child: Column(
                children: [
                  ...widgets,
                  Container(
                    width: 400,
                    margin: EdgeInsets.only(top: 50, left: 30, right: 30),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(98, 164, 162, 1.0),
                      border: Border.all(color: Colors.green,
                          width: 1),

                    ),

                    child: IconButton(

                      onPressed: () {
                          //TODO
                      },
                      icon: Icon(Icons.delete_forever, size: 30, color: Colors.white,),

                    ),
                  )
                ],
              ),
          ),
          ),

    );
  }

}