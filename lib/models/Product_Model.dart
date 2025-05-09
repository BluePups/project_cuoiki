import 'package:http/http.dart' as http;

import '../helper/Supabase_helper.dart';

class Product {
  int id;
  int? gia;
  String ten;
  String? moTa, anh;
  Product({required this.id, this.gia, required this.ten, this.moTa, this.anh});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] as int,
      gia: json["gia"] as int,
      ten: json["ten"],
      moTa: json["moTa"],
      anh: json["anh"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "gia": this.gia,
      "ten": this.ten,
      "moTa": this.moTa,
      "anh": this.anh,
    };
  }
//
}

class ProductSnapShot {
  Product product;
  ProductSnapShot({required this.product});

  static Future<void> update(Product newProduct) async {
    await supabase.from("SanPham")
        .update(newProduct.toJson())
        .eq("id", newProduct.id);
  }

  static Future<dynamic> delete(int id) async {
    await supabase.from("SanPham")
        .delete()
        .eq("id", id);
    await deleteImage(bucket: "images",path: "images/product_${id}.jpg");
    return;
  }

  static Future<dynamic> insert(Product newProduct) async{
    var data = await supabase
        .from('SanPham')
        .insert(newProduct.toJson());
    return data;
  }

  static Future<Map<int, Product>> getMapProduct() async {
    final data = await supabase.from("SanPham").select();
    var iterable = data.map((e) => Product.fromJson(e),).toList();
    Map<int, Product> _maps = Map.fromIterable(
      iterable, key: (product) => product.id, value: (product) => product,);
    return _maps;
  }

  static Future<Map<int, Product>> getMapProducts() async {
    return getMapData(
        table: "SanPham",
        fromJson: Product.fromJson,
        getId: (t) => t.id);
  }

  static Stream<List<Product>> getProductStream() {
    return getDataStream<Product>(
        table: "SanPham",
        ids: ["id"],
        fromJson: (json) => Product.fromJson(json));
  }

  static listenProductchange(Map<int, Product> maps, {Function()? updateUI}) async {
    return listenDatachange(
        maps,
        channel: "SanPham:public",
        schema: "public",
        table: "SanPham",
        fromJson: Product.fromJson,
        getId: (t) => t.id,
        updateUI: updateUI);
  }
}