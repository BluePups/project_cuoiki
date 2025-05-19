import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cuoiki/admin/Product_Admin_Page.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:cuoiki/helper/Supabase_helper.dart';

class PageAddProduct extends StatefulWidget {
  const PageAddProduct({super.key});

  @override
  State<PageAddProduct> createState() => _PageAddProductState();
}

class _PageAddProductState extends State<PageAddProduct> {
  XFile? xFile;
  TextEditingController txtID = TextEditingController();
  TextEditingController txtTen = TextEditingController();
  TextEditingController txtGia = TextEditingController();
  TextEditingController txtMoTa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thêm sản phẩm"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 300,
                child: xFile == null ? Icon(Icons.image, size: 50,) : Image.file(File(xFile!.path)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async{
                        var imagePicker = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if(imagePicker != null) {
                          setState(() {
                            xFile = imagePicker;
                          });
                        }
                      },
                      child: Text("Chọn ảnh")
                  ),
                  SizedBox(width: 15,),
                ],
              ),
              TextField(
                controller: txtID,
                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                decoration: InputDecoration(
                  labelText: "ID",
                ),
              ),
              TextField(
                controller: txtTen,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Tên",
                ),
              ),
              TextField(
                controller: txtGia,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Giá",
                ),
              ),
              TextField(
                controller: txtMoTa,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Mô tả",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      if(xFile != null) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Đang thêm ${txtTen.text}..."),
                                duration: Duration(seconds: 5)
                            )
                        );
                        var imageUrl = await uploadImage(
                          image: File(xFile!.path),
                          bucket: "images",
                          path: "images/product_${txtID.text}.jpg",
                        );
                        Product product = Product(
                          id: int.parse(txtID.text),
                          ten: txtTen.text,
                          gia: int.parse(txtGia.text),
                          moTa: txtMoTa.text,
                          anh: imageUrl,
                        );
                        ProductSnapShot.insert(product);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Đã thêm ${txtTen.text}"),
                              duration: Duration(seconds: 5),
                            )
                        );
                      }
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ProductAdminPage(),)
                      );
                    },
                    child: Text("Thêm"),
                  ),
                  SizedBox(width: 15,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}