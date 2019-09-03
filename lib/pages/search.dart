import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:helloomarket/pages/connect.dart';
import 'dart:convert';

class Search extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchList();
  }
}

class SearchList extends State<Search>{
  List data,desc = List<String>(),images = List<String>();
  List products;
  int isOffline = 0;
  int value,total=0;
  int state;
  String description,p_desc,name,p_name,image;
  final http_url = 'https://helloomarket.com/image/';
  List data_2;
  Future getState() async {
    var jdata = await Connect().getData();
    switch(jdata){
      case 0:
        return 0;
      default:
        setState(() {
          data = jdata;
          for(int j=0;j<data.length;j++){
            data_2 = data[j]['products'];
            for(int i=0;i<data_2.length;i++){
              description = data[j]['products'][i]['description'];
              image = data[j]['products'][i]['image'];
              desc.add(description);
              images.add(image);
              total+=desc.length;
            }

          }
        });
        products = desc;
        return 1;
    }
  }
  int counter;
  @override
  void initState() {
    // TODO: implement initState
    this.getState().then((value){
      setState(() {
        if(value == 0){
          isOffline = 0;
        }
        else
          setState((){
            isOffline = 1;
          });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch(isOffline){
      case 1:
        return ListView.builder(
          itemCount: products.length+1,
          itemBuilder: (context , int pos){
            return pos == 0 ? _searchBar() : listView(pos-1);

          },
        );
      case 0:
        return Container(
          child: Center(
            child: Text("No data yet"),
          ),
        );
    }
  }


  _searchBar(){
    return Padding(
        padding: EdgeInsets.all(8),
        child:TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(2)),
              hintText: "search",
              prefixIcon: Icon(Icons.search)
          ),
          onChanged: (value){
            value = value.toLowerCase();
            print(value);
            setState(() {
              products = desc.where((list){
                var tile = list.toLowerCase();
                return tile.contains(value);
              }).toList();
            });
          },
        )
    );
  }



  listView(int pos){
    return Card(
      child: ListTile(
        leading: Image.network("$http_url${images[pos]}",fit: BoxFit.contain,),
        title: Text("${products[pos]}"),
        subtitle: Text("Jewellery"),
      ),
    );
  }

}