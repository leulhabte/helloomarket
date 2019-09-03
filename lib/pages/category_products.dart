import 'package:flutter/material.dart';

class CatagoryProducts extends StatefulWidget{
  List data;
  int index;
  CatagoryProducts(int index,List data){
    this.data = data;
    this.index = index;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Products(index,data);
  }
}

class Products extends State<CatagoryProducts>{
  List data;
  int index2;
  final http_url = 'https://helloomarket.com/image/';
  Products(int index , List data){
    this.data = data;
    this.index2 = index;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: getOnlineList()/*RefreshIndicator(child: getListView(), onRefresh: refreshProduct)*/
    );

  }

  getOnlineList(){

    List products = data[index2]['products'];

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: products==null ? 0 : products.length,
        itemBuilder: (BuildContext context , int index){
          return Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text("${data[index2]["products"][index]["description"]}"),
                      subtitle: Text("${data[index2]["name"]}"),
                    ),
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage("$http_url${data[index2]["products"][index]["image"]}"),fit: BoxFit.contain)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15,left: 50,right: 50),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: RaisedButton(
                            child: Text("${data[index2]["products"][index]["price"]}",textScaleFactor: 1.5,style: TextStyle(color: Colors.white),),
                            color: Colors.lightGreen,
                            elevation: 6,
                            onPressed: (){
                            },

                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          );
        });

  }
}
