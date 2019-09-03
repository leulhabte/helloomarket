import 'package:flutter/material.dart';
import 'package:helloomarket/pages/catagory.dart' as catagory;
import 'package:helloomarket/pages/all_product.dart' as allProducts;
import 'package:helloomarket/pages/search.dart' as search;
import 'package:helloomarket/data_folder/data_table.dart';
import 'package:helloomarket/pages/connect.dart';
import 'package:helloomarket/pages/description.dart' as desc;
import 'dart:async';


void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
      theme: ThemeData(
      ),
    ));


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MainClass();
  }

}

class MainClass extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WidgetClass();
  }
}

class WidgetClass extends State<MainClass> with SingleTickerProviderStateMixin{
  TabController controller;
  int selectedPage = 0;
  final pageOption = [
    catagory.Catagory(),
    allProducts.All_Products(),
    search.Search(),
    // desc.Item_Description()
  ];

  List Jdata;
  int state;

  @override
  void initState() {
    // TODO: implement initState
    //search.SearchList().getData();
    DataBase db = DataBase();
    super.initState();
    controller = TabController(length: 3 , vsync: this);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[

          ],
          title: Text("HelloMarket"),
          backgroundColor: Colors.lightGreen,
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.lightGreen,
            currentIndex: selectedPage,
            onTap: (int index){
              setState(() {
                selectedPage = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.aspect_ratio,color: Colors.white,),
                  title: Text("Catagory",style: TextStyle(color: Colors.white),)
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home,color: Colors.white),
                  title: Text("All Products",style: TextStyle(color: Colors.white))
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search,color: Colors.white),
                  title: Text("Search",style: TextStyle(color: Colors.white))
              ),
            ]),
        drawer: Drawer(
          child: Card(
            margin: EdgeInsets.all(0),
            color: Color.fromARGB(255, 44, 49, 52),
            child: ListView(
              children: <Widget>[
                DrawerHeader(child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/header2.jpg"),fit: BoxFit.contain)
                  ),
                )
                  ,),
                ListTile(
                  leading: Icon(Icons.image,color: Colors.lightGreenAccent,),
                  title: Text("Catagory",style: TextStyle(color: Colors.white),),
                  onTap: (){
                    selectedPage = 0;
                    main();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings_input_antenna,color: Colors.lightGreenAccent,),
                  title: Text("All Products",style: TextStyle(color: Colors.white)),
                  onTap: (){
                    selectedPage = 1;
                    main();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.search,color: Colors.lightGreenAccent,),
                  title: Text("Search",style: TextStyle(color: Colors.white)),
                  onTap: (){
                    selectedPage = 2;
                    main();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info_outline,color: Colors.lightGreenAccent,),
                  title: Text("Information",style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: Icon(Icons.replay_5,color: Colors.lightGreenAccent,),
                  title: Text("Help",style: TextStyle(color: Colors.white)),
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app,color: Colors.lightGreenAccent,),
                  title: Text("exit",style: TextStyle(color: Colors.white)))
              ],
            ),
          ),
        ),
        body: pageOption[selectedPage]
    );
  }


  void navigateToNext(Object object){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return object;
    }));
  }


}
