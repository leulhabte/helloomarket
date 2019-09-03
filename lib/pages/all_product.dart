import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:helloomarket/pages/description.dart';
import 'package:helloomarket/pages/connect.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:helloomarket/data_folder/data_table.dart';

class All_Products extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProductList();
  }
}

class ProductList extends State<All_Products>{

  List data;
  var values = List<String>();
  int isOffline = 2,state;
  var imageList = List<String>();
  var uintList = List<Uint8List>(),list2;
  String path;
  var name = List<String>();
  File files;
  int length;
  List products;
  var price = List<dynamic>();
  var catagory = List<dynamic>();
  final http_url = 'https://helloomarket.com/image/';
  List sizeOf;


  Future getState() async {
    var jdata = await Connect().getData();
    switch(jdata){
      case 0:
        print('all no data');
        return 0;
      default:
          data = jdata;
        return 1;
    }
  }

  Future<Uint8List> setProduct() async {
    String path;
    print('===========================================================');
    print(data);
    print(data.length);
    for(int i=0; i < 1 ; i++){
      sizeOf = data[i]['products'];
      for(int j=0;j<sizeOf.length;j++){
        var response = await http.get("$http_url${data[i]['products'][j]["image"]}");
        var documentDirectory = await getPath();
        path = '$documentDirectory/${data[i]['products'][j]['product_id']}.png';
        File file = await File(path);
        file.writeAsBytesSync(response.bodyBytes);
        int id = int.parse(data[i]['category_id']);
        int product_id = int.parse(data[i]['products'][j]['product_id']);
        int quantity = int.parse(data[i]['products'][j]['quantity']);
        var price = data[i]['products'][j]['price'];
        var price_before_vat = data[i]['products'][j]['price_before_vat	'];
        var vat = data[i]['products'][j]['vat'];
        print(price.runtimeType);
        var insert = Products_List(
            catagory_name: data[i]['name'],
            catagoryId : id,
            image : path,
            name : data[i]['products'][j]['name'],
            name_am : data[i]['products'][j]['name_am'],
            description : data[i]['products'][j]['description'],
            description_am : data[i]['products'][j]['description_am'],
            manufacture_id : data[i]['products'][j]['manufacturer_id'],
            model : data[i]['products'][j]['model'],
            price : price,
            price_before_vat : price_before_vat,
            product_id : product_id,
            quantity:   quantity,
            vat:  vat
        );
        try{
          DataBase().insertProducts(insert).then((value){
            print('Saved :)');
          });
        }catch(e){
          print('error');
        }


      }

    }

  }

  Future getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    path = directory.path;
    return '$path';
  }


  Future getItems() async {
    Future<List<dynamic>> lists = DataBase().getProducts();
    await lists.then((value) async {
      try{
        List<Products_List> l = value;
        products = value;
        print(products);
        length = value.length;
        print('==================$length!!!!!!!!!!!!!!!!!!!!!!!!');
        for(int i=0; i<length ; i++){
          imageList.add(l[i].image);
          files = await File(imageList[i]);
          list2 = files.readAsBytesSync();
          uintList.add(list2);
          name.add(l[i].description);
          catagory.add(l[i].catagory_name);
          price.add(l[i].price);
        }
      }catch(e){
        return 1;
      }
    });

  }

  /*Future refreshProduct() async {
    await Future.delayed(Duration(seconds: 2));
    getItems().then((value){
      if(value == 1){
        setState(() {
          isOffline = 2;
        });
      }
      else{
        setState(() {
          isOffline = 1;
        });
      }
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    try{
      this.getState().then((value){
        if(value == 1){
          setProduct().then((value){
                setState(() {
                  isOffline = 0;
                });
          });
        }
        else
        {
          getItems().then((value){
            if(value == 1){
              setState(() {
                isOffline = 2;
              });
            }
            else{
              setState(() {
                isOffline = 1;
              });
            }
          });
        }
      });
    }catch(e){

    }

  }

  int count=0,sum;
  String names;
  List size = List<int>();
  List temp;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(isOffline);
    switch(isOffline){
      case 0:
        return Scaffold(
            body: getOnlineList()
        );
      case 1:
        return Scaffold(
            body: getListView()/*RefreshIndicator(child: getListView(), onRefresh: refreshProduct)*/
        );
      case 2:
         return Container(
          child: Center(
            child: Text('No data avalable'),
          ),
        );
    }

  }

  void navigateToNext(String itemCatagory, String itemProduct,var image,var price,int type){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Item_Description(itemCatagory,itemProduct,image,price,type);
    }));
  }

  getListView(){
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: products==null ? 0 : products.length,
        itemBuilder: (BuildContext context , int pos){

          return Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text("${getNames(pos)}"),
                      subtitle: Text("${getCategoryName(pos)}"),
                      onTap: (){
                        navigateToNext(getCategoryName(pos),getNames(pos),getImages(pos),getPrice(pos),0);
                      },
                    ),
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                          image: DecorationImage(image: MemoryImage(getImages(pos)),fit: BoxFit.contain)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15,left: 50,right: 50),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: RaisedButton(
                            child: Text("${getPrice(pos)}",textScaleFactor: 1.5,style: TextStyle(color: Colors.white),),
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

  getOnlineList(){

    List ofmons,list=List<dynamic>();
    int sum = 0,index1=-1,index2=-1,c=0,l=-1;
    for(int i=0;i<data.length;i++){
      ofmons = data[i]['products'];
      list.add(ofmons.length);
      sum=sum+(ofmons.length);
    }
    int sum2=0,tmp=0;
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data==null ? 0 : sum,
        itemBuilder: (BuildContext context , int index){
          index2++;
          if(tmp == 0){
            index1 ++;
            tmp++;
          }
          l++;
          if(l == list[c]){
            print(list[c]);
            c++;
            sum2+=l;
            if(sum2 != sum){
              index1++;
            }
            l=0;
            index2=0;
          }

          return Padding(
              padding: EdgeInsets.all(5),
              child: Card(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text("${data[index1]["products"][index2]["description"]}"),
                      subtitle: Text("${data[index1]["name"]}"),
                      onTap: (){
                        navigateToNext(data[index1]["name"],data[index1]["products"][index2]["description"],"$http_url${data[index1]["products"][index2]["image"]}",data[index1]["products"][index2]["price"],1);
                      },
                    ),
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                          image: DecorationImage(image: NetworkImage("$http_url${data[index1]["products"][index2]["image"]}"),fit: BoxFit.contain)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15,left: 50,right: 50),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: RaisedButton(
                            child: Text("${data[index1]["products"][index2]["price"]}",textScaleFactor: 1.5,style: TextStyle(color: Colors.white),),
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

  getImages(int index)  {
    return uintList[index];
  }

  getNames(int index){
    print('****${name[index]}');
    return name[index];
  }

  getCategoryName(int index){
    return catagory[index];
  }

  getPrice(int index){
    return price[index];
  }
}