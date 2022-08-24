import 'package:finances/data/Account.dart';
import 'package:finances/data/Data.dart';
import 'package:flutter/material.dart';

import '../../utils/RequestFunctions.dart';

class ManageAccount extends StatefulWidget{
  late Data data;


  ManageAccount.data(this.data, {Key? key}) : super(key: key);


  ManageAccount({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManageAccount();

}

class _ManageAccount extends State<ManageAccount>{


  Widget body = Container(
    child: Text("asddas"),
  );
  final TextEditingController _balance = TextEditingController();
  final TextEditingController _name = TextEditingController();

  String _selectAccount = "";
  List<String> accounts = <String>[];
  List<Color> colorsMenu = <Color>[Color.fromRGBO(98, 164, 162, 1.0),Colors.white];
  int _selectedMenu = 0;
  @override
  void initState() {
    accounts = widget.data.accounts.map((account) => account.name).toList();
    _selectAccount = accounts[0];
    _selectedMenu = 0;
    //createOptionWidget(accountsWidgets, "Adicionar", buildBodyAdd, 0);
    //createOptionWidget(accountsWidgets, "Remover", buildBodyRemove, 1);
    body = buildBodyAdd();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text("Adicionar/Remover Contas", style: TextStyle(color: Colors.black),),
          leading: GestureDetector(
                  onTap: () { Navigator.of(context).pop(); },
                  child:
                    Icon( Icons.arrow_back, color: Colors.black,  // add custom icons also
                    ),
              ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  GestureDetector(
                  child: Container(
                  height: 50,
                    width: 120,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 50, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue,),
                      color: _selectedMenu == 0 ? colorsMenu[0] : colorsMenu[1],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),

                    child: Center(
                      child: Text("Adicionar", style: TextStyle(fontSize: 16),),
                    ),
                  ),
                  onTap: () {
                    print("Aqui");
                    setState(() {
                      colorsMenu.forEach((element) { element = Colors.white;});
                      _selectedMenu = 0;
                      body = buildBodyAdd();
                    });
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 50,
                    width: 120,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 50, left: 10, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue,),
                      color: (_selectedMenu == 1 ? colorsMenu[0] : colorsMenu[1]),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 8,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),

                    child: Center(
                      child: Text("Remover", style: TextStyle(fontSize: 16),),
                    ),
                  ),
                  onTap: () {
                    print("Aqui");
                    setState(() {
                      _selectedMenu = 1;
                      body = buildBodyRemove();
                    });
                  },
                )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 30),
              child: Divider(
                thickness: 2,
                height: 1,
                color: Colors.grey,
                indent: 20,
                endIndent: 20,
              ),
            ),
            Container(
              child: body,
            )
          ],
        ),
        resizeToAvoidBottomInset: false,
      ),
    );
  }


  Widget buildBodyAdd(){

    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.only(top:10 ),
          child: SizedBox(
            width: 350,
            height: 60,
            child: Container(
              child: TextField(
                controller: _name,
                decoration: InputDecoration(
                  enabled: true,

                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 3, color: Colors.blue)
                  ),
                  labelText: 'Nome da conta',
                  //hintText: 'Nome da conta',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2, color: Colors.blue)
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding:  EdgeInsets.only(top:30),
          child: SizedBox(
            width: 350,
            child: Container(
              child: TextField(
                controller: _balance,
                decoration: InputDecoration(
                  enabled: true,

                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 3, color: Colors.blue)
                  ),
                  labelText: 'Quantia Inicial',
                 // hintText: 'Valor da transação',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(width: 2, color: Colors.blue)
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
              ),
            ),
          ),
        ),
        Container(
          width: 400,
          margin: EdgeInsets.only(top: 20, left: 30, right: 30),
          decoration: BoxDecoration(
            color: Color.fromRGBO(98, 164, 162, 1.0),
            border: Border.all(color: Colors.green,
                width: 1),

          ),

          child: IconButton(

            onPressed: () {
              addAccount();
            },
            icon: Icon(Icons.add, size: 30, color: Colors.white,),

          ),
        )
      ],
    );

  }
  Widget buildBodyRemove(){
    return Column(
      children: [
        Padding(
          padding:  EdgeInsets.only(top: 30),
          child: SizedBox(
            width: 350,
            height: 70,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  itemHeight: 50,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Conta",
                    labelStyle: TextStyle(fontSize: 24, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(width: 3, color: Colors.blue)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(width: 2, color: Colors.blue)
                    ),
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return accounts.map<Widget>((String item) {
                      return Container(
                          alignment: Alignment.centerLeft,
                          width: 180,
                          child: Text(item, textAlign: TextAlign.left, style: TextStyle(fontSize: 18))
                      );
                    }).toList();
                  },
                  items: accounts
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,textAlign: TextAlign.left, style: TextStyle(fontSize: 18),),
                  )).toList(),
                  value: _selectAccount,
                  onChanged: (itemSelected) {
                    if(itemSelected != null) {
                      setState(() {
                        _selectAccount = itemSelected;
                      });
                    }
                  },
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
        ),

        Container(
          width: 400,
          margin: EdgeInsets.only(top: 20, left: 30, right: 30),
          decoration: BoxDecoration(
            color: Color.fromRGBO(98, 164, 162, 1.0),
            border: Border.all(color: Colors.green,
                width: 1),

          ),

          child: IconButton(

            onPressed: () {

            },
            icon: Icon(Icons.delete_forever, size: 30, color: Colors.white,),

          ),
        )
      ],
    );

  }

  void addAccount()async {
    if(_name.text.isEmpty){
      return;
    }
    if(_balance.text.isEmpty){
      return;
    }
    double? balance = double.tryParse(_balance.text);
    if(balance == null){
      return;
    }

    Account? account = await addAccountRequest(Account(_name.text, balance), widget.data);
    if(account != null){
      widget.data.accounts.add(account);
      accounts.add(account.name);
      widget.data.fetchNeeded = true;
      setState(() {
        _name.text = "";
        _balance.text = "";
      });
    }

  }

}