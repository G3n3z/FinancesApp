import 'package:finances/data/Data.dart';
import 'package:finances/data/Entity.dart';
import 'package:flutter/material.dart';

import '../../utils/RequestFunctions.dart';

class ManageEntityPage extends StatefulWidget{
  late Data data;

  ManageEntityPage({Key? key}) : super(key: key);

  ManageEntityPage.data(this.data, {Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _ManageEntityPage();

}


class _ManageEntityPage extends State<ManageEntityPage>{

  Widget body = Container(
    child: Text("asddas"),
  );
  final TextEditingController _balance = TextEditingController();
  final TextEditingController _name = TextEditingController();

  String _selectEntity = "";
  List<String> entities = <String>[];
  List<Color> colorsMenu = <Color>[Color.fromRGBO(98, 164, 162, 1.0),Colors.white];
  int _selectedMenu = 0;
  @override
  void initState() {
    entities = widget.data.entities.map((account) => account.name).toList();
    _selectEntity = entities[0];
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
          title: Text("Adicionar/Remover Entidades", style: TextStyle(color: Colors.black),),
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
                  labelText: 'Nome da Entidade',
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
                  value: _selectEntity,
                  onChanged: (itemSelected) {
                    if(itemSelected != null) {
                      setState(() {
                        _selectEntity = itemSelected;
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
    Entity? entity = await addEntityRequest(Entity.all(_name.text), widget.data);
    if(entity != null){
      widget.data.entities.add(entity);
      entities.add(entity.name);
      widget.data.fetchNeeded = true;
    }

  }

}