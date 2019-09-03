import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Item_Description extends StatefulWidget{
  String itemCatagory,itemCode,itemProduct;
  final http_url = 'https://helloomarket.com/image/';
  var price,image;
  int type;
  Item_Description(String itemCatagory , String itemProdcut,var image,var price,int type){
    this.itemCatagory = itemCatagory;
    this.itemProduct = itemProdcut;
    this.image = image;
    this.price = price;
    this.type = type;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    switch(type){
      case 1:
        return Item(itemCatagory,itemProduct,image,price);
      case 0:
        return Item_offline(itemCatagory,itemProduct,image,price);
    }
  }

}

class Item extends State<Item_Description>{
  List data;
  Future<List> getData() async {
    var req = await http.get("https://helloomarket.com/api/getAllProducts.php",
        headers: {
          "Accept" : "application/json"
        });

    data = jsonDecode(req.body);
    print(data[0]["name"]);
    return data;
  }
  String itemCatagory,itemCode,itemProduct;
  var price,image;

  Item(String itemCatagory  , String itemProdcut , String image, var price){
    this.itemCatagory = itemCatagory;
    this.itemProduct = itemProdcut;
    this.image = image;
    this.price = price;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("HelloMarket"),
          backgroundColor: Colors.lightGreen,
        ),
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 20),
                child:  Card(
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(image),fit:BoxFit.contain)
                    ),
                  ),
                )
            ),
            /* */
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 5,left: 10),
                    child: Align(
                      child: Text("Category = $itemCatagory",style: TextStyle(fontSize: 20,color: Colors.lightGreen),),
                      alignment:Alignment.centerLeft,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 5,left: 10),
                    child: Align(
                      child: Text("Name = $itemProduct",style: TextStyle(fontSize: 20,color: Colors.lightGreen)),
                      alignment:Alignment.centerLeft,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 5,left: 10),
                    child: Align(
                      child: Text("Price = $price",style: TextStyle(fontSize: 20,color: Colors.lightGreen)),
                      alignment:Alignment.centerLeft,
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15,left: 50,right: 50),
              child: Row(
                children: <Widget>[
                  Expanded(child: RaisedButton(
                    child: Text("Order Now",textScaleFactor: 1.5,style: TextStyle(color: Colors.white),),
                    color: Colors.lightGreen,
                    elevation: 6,
                    onPressed: (){
                      launch('+251983064336');
                    },

                  )),
                ],
              ),
            ),

          ],
        )
    );
  }

}


class Item_offline extends State<Item_Description>{
  List data;
  String itemCatagory,itemCode,itemProduct;
  var price,image;

  Item_offline(String itemCatagory  , String itemProdcut , var image, var price){
    this.itemCatagory = itemCatagory;
    this.itemProduct = itemProdcut;
    this.image = image;
    this.price = price;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("HelloMarket"),
          backgroundColor: Colors.lightGreen,
        ),
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 20),
                child:  Card(
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        image: DecorationImage(image: MemoryImage(image),fit:BoxFit.contain)
                    ),
                  ),
                )
            ),
            /* */
            Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 5,left: 10),
                    child: Align(
                      child: Text("Category = $itemCatagory",style: TextStyle(fontSize: 20,color: Colors.lightGreen),),
                      alignment:Alignment.centerLeft,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 5,left: 10),
                    child: Align(
                      child: Text("Name = $itemProduct",style: TextStyle(fontSize: 20,color: Colors.lightGreen)),
                      alignment:Alignment.centerLeft,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5, top: 5,left: 10),
                    child: Align(
                      child: Text("Price = $price",style: TextStyle(fontSize: 20,color: Colors.lightGreen)),
                      alignment:Alignment.centerLeft,
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 15,left: 50,right: 50),
              child: Row(
                children: <Widget>[
                  Expanded(child: RaisedButton(
                    child: Text("Order Now",textScaleFactor: 1.5,style: TextStyle(color: Colors.white),),
                    color: Colors.lightGreen,
                    elevation: 6,
                    onPressed: (){
                    },

                  )),
                ],
              ),
            ),

          ],
        )
    );
  }

}