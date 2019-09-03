import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:helloomarket/pages/connect.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:helloomarket/data_folder/data_table.dart';
import 'package:helloomarket/pages/category_products.dart';

class Catagory extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CatagoryList();
  }
}

class CatagoryList extends State<Catagory>{

  List data;
  int isOffline = 2;
  int value;
  var imageList = List<String>();
  var uintList = List<Uint8List>(),list2;
  String path;
  var names = List<String>();
  File files;
  int length;
  List products;
  final http_url = 'https://helloomarket.com/image/';

  Future getState() async {
    var jdata = await Connect().getData();
    switch(jdata){
      case 0:
        return 0;
      default:
          data = jdata;
        return 1;
    }
  }


  Future<Uint8List> setData() async {
    String path;
    for(int i=0; i<data.length;i++){
      var response = await http.get("$http_url${data[i]["image"]}");
      var documentDirectory = await getPath();
      path = '$documentDirectory/${data[i]['name']}.png';
      File file = await File(path);
      file.writeAsBytesSync(response.bodyBytes);
      int id = int.parse(data[i]['category_id']);
      var insert = Market_List(
          catagoryId : id,
          image : path,
          name : data[i]['name'],
          name_am : data[i]['name_am'],
          description : data[i]['description'],
          description_am : data[i]['description_am']
      );
      try{
        DataBase().insertCatagory(insert);
      }catch(e){
        print('error');
      }

    }
  }


  Future getPath() async {
    final directory = await getApplicationDocumentsDirectory();
    path = directory.path;
    return '$path';
  }


  Future getItems() async {
    Future<List<dynamic>> lists = DataBase().getCatagory();
    await lists.then((value) async {
      try{
        List<Market_List> l = value;
        products = value;
        switch(value.length){
          case null:
            return 1;
          default:
            length = value.length;
            for(int i=0; i<length ; i++){
              imageList.add(l[i].image);
              files = await File(imageList[i]);
              list2 = files.readAsBytesSync();
              uintList.add(list2);
              names.add(l[i].name);
        }

        }
      }catch(e){
        return 1;
      }

    });
  }


  @override
  void initState() {
    // TODO: implement initState
    try{
      this.getState().then((value){
          if(value == 1){
            setData().then((value){
              print('here');
              setState(() {
                  isOffline=0;
              });
            });
          }
          else{
            getItems().then((value){
              if(value == 1){
                setState(() {
                  isOffline = 2;
                });
              }
              else {
                setState(() {
                  isOffline = 1;
                });
              }

            });
          }
      });
    }
    catch(e){

    }


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    /*
    );*/

    switch(isOffline){
      case 0:
        return GridView.extent(
              maxCrossAxisExtent: 220,
              children: getOnline(data == null ? 0 : data.length));
      case 1:
        return GridView.extent(
          maxCrossAxisExtent: 220,
          children: getOffline(products == null ? 0 : products.length),);
      case 2:
        return Container(
          child: Center(
            child: Text('No data avialable'),
          ),
        );
    }
  }

  List<Widget> getOffline(num){
    List<Container> container = List<Container>.generate(num,
            (int index){
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: MemoryImage(getImages(index)),fit: BoxFit.contain,)
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(getNames(index)),
            ),
          );
        }
    );
    return container;
  }

  List product;

  List<Widget> getOnline(num){
    getIndex(num);
    List<Container> container = List<Container>.generate(num,
            (int index){
          return Container(
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage("$http_url${data[index]["image"]}"),fit: BoxFit.contain,)
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  print(num);
                },
                child: Text(data[index]['name'],
              )),
            ),
          );
        }
    );
    return container;
  }

  getIndex(int index){
    return index;
  }

  getImages(int index)  {
    return uintList[index];
  }

  getNames(int index){
    return names[index];
  }

  void navigateToNext(int index, List data){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return CatagoryProducts(index,data);
    }));
  }

}