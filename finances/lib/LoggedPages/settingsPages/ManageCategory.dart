import 'package:finances/data/Category.dart';
import 'package:finances/data/Data.dart';
import 'package:flutter/material.dart';

import '../../utils/RequestFunctions.dart';

class ManageCategoryPage extends StatefulWidget{

  late Data data;


  ManageCategoryPage({Key? key}) : super(key: key);

  ManageCategoryPage.data(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManageCategoryPage();

}

class _ManageCategoryPage extends State<ManageCategoryPage>{
  List<Widget> accountsWidgets = <Widget>[];
  Widget body = Container();

  final TextEditingController _name = TextEditingController();

  String _selectCategory = "";
  List<String> categories = <String>[];
  List<Color> colorsMenu = <Color>[Color.fromRGBO(98, 164, 162, 1.0),Colors.white];
  int _selectedMenu = 0;
  @override
  void initState() {
    categories = widget.data.categories.map((account) => account.name).toList();
    _selectCategory = categories[0];
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
          title: Text("Adicionar/Remover Categorias", style: TextStyle(color: Colors.black),),
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
                  labelText: 'Nome da Categoria',
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
              addCategory();
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
                  value: _selectCategory,
                  onChanged: (itemSelected) {
                    if(itemSelected != null) {
                      setState(() {
                        _selectCategory = itemSelected;
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

  void addCategory()async {
    if(_name.text.isEmpty){
      return;
    }


    Category? category = await addCategoryRequest(Category.all(_name.text), widget.data);
    if(category != null){
      _name.text = "";
      widget.data.categories.add(category);
      categories.add(category.name);
      widget.data.fetchNeeded = true;
      setState(() {
        _name.text = "";
      });
    }

  }
}