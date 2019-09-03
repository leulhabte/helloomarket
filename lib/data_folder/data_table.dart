import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DataBase{
  static DataBase _dataBase;
  static Database _database;
  DataBase.creteInstance(){}

  factory DataBase(){
    if(_dataBase == null){
      _dataBase = DataBase.creteInstance();
    }
    return _dataBase;
  }

  Future<Database> get database async {
    if(_database == null){
      _database = await getDataBase();
    }

    return _database;
  }

  Future<Database> getDataBase() async {
    final database = openDatabase(
        join(await getDatabasesPath(),"hellooMarket049.db"),
        onCreate: (db,version){
          return _onCreate(db,version);
        },
        version: 20

    );

    return database;
  }

  void _onCreate(Database db , int version) async {
    await db.execute("CREATE TABLE category(catagoryId INTEGER PRIMARY KEY, image TEXT, name TEXT, name_am TEXT, description TEXT, description_am TEXT)");
    await db.execute("CREATE TABLE products(catagory_name TEXT,catagoryId, image TEXT, name TEXT, name_am TEXT, description TEXT, description_am TEXT,"
        "manufacture_id	TEXT, model TEXT, price REAL, price_before_vat	TEXT, product_id INTEGER PRIMARY KEY, quantity INTEGER, vat REAL)");
  }

  Future<void> insertCatagory(Market_List market_list) async {
    final Database db = await this.database;
    try{
      await db.insert('category', market_list.toMap(),conflictAlgorithm: ConflictAlgorithm.abort);
    }catch(e){
      print("Exsist");
    }

  }

  Future<void> insertProducts(Products_List products_list) async {
    final Database db = await this.database;
    try{
      await db.insert('products', products_list.toMap(),conflictAlgorithm: ConflictAlgorithm.abort).then((v){
        print('Success');
      });
    }catch(e){
      print("Exsist");
    }

  }

  Future<List<Market_List>> getCatagory() async {
    final Database db = await this.database;

    List<Map<String , dynamic>> list =await db.query('category');
    switch(list.isEmpty){
      case true :
        return null;
      case false :
        return List.generate(list.length,
                (i){
              return Market_List(
                  catagoryId : list[i]['catagoryId'],
                  image : list[i]['image'],
                  name : list[i]['name'],
                  name_am : list[i]['name_am'],
                  description : list[i]['description'],
                  description_am : list[i]['description_am']
              );
            });
    }

  }

  Future<List<Products_List>> getProducts() async {
    final Database db = await this.database;
    try{
      List<Map<String , dynamic>> list =await db.query('products');
      switch(list.isEmpty){
        case true :
          return null;
        case false :
          return List.generate(list.length,
                  (i){
                return Products_List(
                    catagory_name: list[i]['catagory_name'],
                    catagoryId : list[i]['catagoryId'],
                    image : list[i]['image'],
                    name : list[i]['name'],
                    name_am : list[i]['name_am'],
                    description : list[i]['description'],
                    description_am : list[i]['description_am'],
                    manufacture_id : list[i]['manufacture_id'],
                    model : list[i]['model'],
                    price : list[i]['price'],
                    price_before_vat : list[i]['price_before'],
                    product_id: list[i]['produc_id'],
                    quantity : list[i]['quantity'],
                    vat : list[i]['vat']
                );
              });
      }
    }
    catch(error){
      print('No data');
    }

  }

}



class Market_List{

  int catagoryId;
  String image;
  String name;
  String name_am;
  String description;
  String description_am;

  Market_List({this.catagoryId,this.image,this.name,this.name_am,this.description,this.description_am});

  Map<String , dynamic>toMap(){
    return{
      'catagoryId' : catagoryId,
      'image' : image,
      'name' : name,
      'name_am' : name_am,
      'description' : description,
      'description_am' : description_am
    };
  }

  @override
  String toString() {
    return 'Market_List{catagoryId : $catagoryId, image : $image, name : $name,name_am : $name_am, description : $description, description_am : $description_am}';
  }

}

class Products_List{

  String catagory_name;
  int catagoryId;
  String image;
  String name;
  String name_am;
  String description;
  String description_am;
  String manufacture_id;
  String model;
  var price;
  String price_before_vat;
  int product_id;
  int quantity;
  var vat;

  Products_List({this.catagory_name,this.catagoryId,this.image,this.name,this.name_am,this.description,this.description_am,this.manufacture_id,this.model,this.price,this.price_before_vat,this.product_id,this.quantity,this.vat});

  Map<String , dynamic>toMap(){
    return{
      'catagory_name' : catagory_name,
      'catagoryId' : catagoryId,
      'image' : image,
      'name' : name,
      'name_am' : name_am,
      'description' : description,
      'description_am' : description_am,
      'manufacture_id' : manufacture_id,
      'model' : model,
      'price' : price,
      'price_before_vat' : price_before_vat,
      'product_id' : product_id,
      'quantity' : quantity,
      'vat' : vat
    };
  }

  @override
  String toString() {
    return 'Products_List{catagory_name : $catagory_name,catagoryId : $catagoryId, image : $image, name : $name,name_am : $name_am, description : $description, description_am : $description_am'
        'manufacture_id : $manufacture_id,model : $model,price : $price,price_before : $price_before_vat,quantity : $quantity,vat : $vat}';
  }

}