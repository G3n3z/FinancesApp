
import 'package:finances/data/Transaction.dart';
import 'package:finances/utils/RequestFunctions.dart';
import 'package:flutter/material.dart';

import '../data/Data.dart';

class AddTransactionPage extends StatefulWidget{

  late Data _data;


  AddTransactionPage({Key? key}) : super(key: key);

  AddTransactionPage.data(this._data, {Key? key}) : super(key: key);


  Data get data => _data;

  set data(Data value) {
    _data = value;
  }
  List<String> transactionType = <String>["Despesa", "Receita"];

  @override
  State<AddTransactionPage> createState() => _AddTransactionPage();


  
}

class _AddTransactionPage extends State<AddTransactionPage>{

  String _selectedType = "";
  String _selectedCategory = "";
  String _selectedEntity = "";
  String _selectedAccount = "";
  late List<String>categories = <String>[];
  late List<String>entities = <String>[];
  late List<String>accounts = <String>[];
  double spaceBetweenFields = 30;
  final _amount = TextEditingController();
  final _name = TextEditingController();

  @override
  void initState(){


    categories =  widget.data.categories.map((cat) => cat.name).toList();
    entities = widget.data.entities.map((e) => e.name).toList();
    accounts = widget.data.accounts.map((e) => e.name).toList();
    _selectedType = widget.transactionType.first;
    _selectedCategory = widget.data.categories.first.name;
    _selectedEntity = widget.data.entities.first.name;
    _selectedAccount = widget.data.accounts.first.name;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          alignment: Alignment.center,
          child: Text("Adicionar Transação", style: TextStyle(color: Colors.blue, fontSize: 26),),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(

            children: [
              SizedBox(
                width: 350,
                height: 70,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      itemHeight: 50,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Tipo",
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
                      items: widget.transactionType
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item,textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
                      )).toList(),
                      value: _selectedType,
                      onChanged: (itemSelected) {
                        setState(() {
                          _selectedType = itemSelected!;
                        });
                      },
                      alignment: Alignment.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(top: spaceBetweenFields),
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
                        value: _selectedAccount,
                        onChanged: (itemSelected) {
                          setState(() {
                            _selectedAccount = itemSelected!;
                          });
                        },
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(top: spaceBetweenFields),
                child: SizedBox(
                  width: 350,
                  height: 70,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        itemHeight: 50,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: "Categoria",
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
                          return categories.map<Widget>((String item) {
                            return Container(
                                alignment: Alignment.centerLeft,
                                width: 180,
                                child: Text(item, textAlign: TextAlign.left, style: TextStyle(fontSize: 18))
                            );
                          }).toList();
                        },
                        items: categories
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item,textAlign: TextAlign.left, style: TextStyle(fontSize: 18),),
                        )).toList(),
                        value: _selectedCategory,
                        onChanged: (itemSelected) {
                          setState(() {
                            _selectedCategory = itemSelected!;
                          });
                        },
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(top: spaceBetweenFields),
                child: SizedBox(
                  width: 350,
                  height: 70,
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        itemHeight: 50,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: "Entidade",
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
                          return entities.map<Widget>((String item) {
                            return Container(
                              alignment: Alignment.centerLeft,
                              width: 180,
                              child: Text(item, textAlign: TextAlign.left, style: TextStyle(fontSize: 18))
                            );
                          }).toList();
                        },
                        items: entities
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item,textAlign: TextAlign.left, style: TextStyle(fontSize: 18),),
                        )).toList(),
                        value: _selectedEntity,
                        onChanged: (itemSelected) {
                          if(itemSelected != null) {
                            setState(() {
                              _selectedEntity = itemSelected;
                            });
                          }
                        },
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(top:spaceBetweenFields),
                child: SizedBox(
                  width: 350,
                  child: Container(
                    child: TextField(
                      controller: _name,

                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Nome da transação',
                        alignLabelWithHint: true,
                        hintText: 'Nome da transação',

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(width: 3, color: Colors.blue)
                        ),
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
                padding:  EdgeInsets.only(top:spaceBetweenFields ),
                child: SizedBox(
                  width: 350,
                  child: Container(
                    child: TextField(
                      controller: _amount,
                      decoration: InputDecoration(
                        enabled: true,

                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(width: 3, color: Colors.blue)
                        ),
                        labelText: 'Valor da transação',
                        hintText: 'Valor da transação',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(width: 2, color: Colors.blue)
                        ),
                      ),
                      keyboardType: TextInputType.numberWithOptions(signed: true, decimal: false),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: 200,

          margin: EdgeInsets.only(top: 20, left: 30, right: 30),
          //color: Color.fromRGBO(98, 164, 162, 1.0),
          //color: Color.fromRGBO(98, 164, 162, 1.0),
          decoration: BoxDecoration(

            color: Color.fromRGBO(98, 164, 162, 1.0),
            border: Border.all(color: Colors.green,
                width: 1),
            borderRadius: BorderRadius.circular(12),


          ),

          child: IconButton(

            onPressed: () {
              addTransaction();
            },
            icon: Icon(Icons.add, size: 30, color: Colors.white,),

          ),
        )
      ],
    );
  }

  void addTransaction()async{
    Transaction t = Transaction();
    if(_name.text == null || _name.text.isEmpty){
      return;
    }
    t.name = _name.text;
    t.date = DateTime.now();
    if(_selectedAccount.isEmpty){
      return;
    }
    t.account = _selectedAccount;
    t.entity = _selectedEntity;
    t.category = _selectedCategory;
    if(_amount.text.isEmpty){
      return;
    }
    if(_selectedType == "Despesa"){
      t.amount = (-double.parse(_amount.text));
    }
    else{
      t.amount = double.parse(_amount.text);
    }
    Transaction? response = await sendTransaction(t, widget.data);
    if(response!= null){
      widget.data.fetchNeeded = true;
      _name.text = "";
      _amount.text = "";
    }
  }
  
}