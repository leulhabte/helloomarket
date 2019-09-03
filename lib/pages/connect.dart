import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

class Connect{
  List data,Jdata;
  Future<dynamic> getData() async {

    var request;
    try{
      request = await http.get("https://helloomarket.com/api/getAllProducts.php",
          headers: {
            "Accept" : "application/json"
          });

      switch(request.statusCode){
        case 200:
          data = await jsonDecode(request.body);
          return data;
        default :
          return 0;
      }

    }catch(e){
      print('Error Connection');
      return 0;
    }


  }

  getJsonList(){
    Jdata = data;
    return Jdata;
  }




}