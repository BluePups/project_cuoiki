import 'dart:io';

import 'package:cuoiki/admin/Product_Admin_Page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cuoiki/helper/Dialogs.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:cuoiki/helper/Supabase_helper.dart';

class PageAddProduct extends StatefulWidget {
  const PageAddProduct({super.key});

  @override
  State<PageAddProduct> createState() => _PageAddProductState();
}

class _PageAddProductState extends State<PageAddProduct> {
  XFile? xFile;
  TextEditingController txtId = TextEditingController();
  TextEditingController txtTen = TextEditingController();
  TextEditingController txtGia = TextEditingController();
  TextEditingController txtMoTa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 300,
                child: xFile == null
                    ? Icon(
                  Icons.image,
                  size: 50,
                )
                    : Image.file(File(xFile!.path)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        var imagePicker = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);

                        if (imagePicker != null) {
                          setState(() {
                            xFile = imagePicker;
                          });
                        }
                      },
                      child: Text("Chọn ảnh")),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              TextField(
                controller: txtId,
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                decoration: InputDecoration(labelText: "Id"),
              ),
              TextField(
                controller: txtTen,
                decoration: InputDecoration(labelText: "Tên"),
              ),
              TextField(
                controller: txtGia,
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                decoration: InputDecoration(labelText: "Giá"),
              ),
              TextField(
                controller: txtMoTa,
                decoration: InputDecoration(labelText: "Mô tả"),
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (xFile != null) {
                      showSnackBar(context,
                          message: "Đang thêm ${txtTen.text} ...",
                      );
                      var imageUrl = await uploadImage(
                          image: File(xFile!.path),
                          bucket: "images",
                          path: "products/Product_${txtId.text}.jpg"
                      );
                      Product product = Product(
                          id: int.parse(txtId.text),
                          ten: txtTen.text,
                          anh: imageUrl,
                          gia: int.parse(txtGia.text),
                          moTa: txtMoTa.text
                      );
                      ProductSnapShot.insert(product);
                      showSnackBar(context,
                          message: "Đã thêm ${txtTen.text}",);
                    }
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PageProductAdmin(),)
                    );
                  },
                  child: Text("Thêm")),
            ],
          ),
        ),
      ),
    );
  }
}