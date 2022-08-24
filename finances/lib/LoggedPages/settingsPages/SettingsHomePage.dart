import 'package:finances/data/Data.dart';
import 'package:flutter/material.dart';

class SettingsHomePage  extends StatefulWidget{
  late Data data;
  late BuildContext backContext;

  SettingsHomePage({Key? key}) : super(key: key);

  SettingsHomePage.data(this.data, {Key? key}) : super(key: key);


  SettingsHomePage.dataContext(this.data, this.backContext, {Key? key,}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsHomePage();

}


class _SettingsHomePage extends State<SettingsHomePage>{
  List<Field> fields = <Field>[Field.all("Adicionar/Remover Conta"), Field.all("Adicionar/Remover Categoria"), Field.all("Adicionar/Remover Entidade"), 
    Field.all("Perfil"), Field.all("Terminar Sessão")];



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Column(
        children : [
          Container(
            margin: EdgeInsets.only(top: 50),
            child: Text("Perfil", style: TextStyle(color: Colors.blue, fontSize: 26, decoration: TextDecoration.none),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: fields.length,
              itemBuilder: (BuildContext context, int index){
                return Card(
                  child: ListTile(
                    title: Text(fields[index].nameOfOption),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: (){
                      tap(fields[index], index);
                    },
                  ),

                );
              },

            ),
          ),
        ],
      )
    );
  }

  void tap(Field field, int index) {
    switch(index){
      case 0 : Navigator.of(context).pushNamed("/settings/manageAccount", arguments: widget.data);
               break;
      case 1 : Navigator.of(context).pushNamed("/settings/manageCategories", arguments: widget.data);
               break;
      case 2 : Navigator.of(context).pushNamed("/settings/manageEntities", arguments: widget.data);
               break;
      case 4 : Navigator.of(widget.backContext).pop();
    }
  }

}

class Field{
  late String nameOfOption;


  Field();

  Field.all(this.nameOfOption);
}