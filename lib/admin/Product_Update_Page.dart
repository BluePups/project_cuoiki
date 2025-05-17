import 'dart:io';

import 'package:cuoiki/admin/Product_Admin_Page.dart';
import 'package:cuoiki/pages/HomeStoreStream_Page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cuoiki/helper/Dialogs.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:cuoiki/helper/Supabase_helper.dart';

class PageUpdateProduct extends StatefulWidget {
  PageUpdateProduct({super.key, required this.product});
  Product product;

  @override
  State<PageUpdateProduct> createState() => _PageUpdateProductState();
}

class _PageUpdateProductState extends State<PageUpdateProduct> {
  XFile? xFile;
  String? imageUrl;
  TextEditingController txtId = TextEditingController();
  TextEditingController txtTen = TextEditingController();
  TextEditingController txtGia = TextEditingController();
  TextEditingController txtMoTa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Product"),
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
                    ? Image.network(widget.product.anh ?? "Link mac dinh")
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
                readOnly: true,
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
                    Product product = widget.product;

                    showSnackBar(context,
                        message: "Đang Cập nhật ${product.ten} ...", seconds: 10);

                    if (xFile != null) {
                      imageUrl = await uploadImage(
                          image: File(xFile!.path),
                          bucket: "images",
                          path: "fruits/Fruit_${txtId.text}.jpg",
                          upsert: true);

                      product.anh = imageUrl;
                    }

                    product.ten = txtTen.text;
                    product.gia = int.parse(txtGia.text);
                    product.moTa = txtMoTa.text;

                    await ProductSnapShot.update(product);
                    showSnackBar(context, message: "Đã cập nhật ${product.ten}");
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PageProductAdmin(),)
                    );
                  },
                  child: Text("Cập nhật")),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtId.text = widget.product.id.toString();
    txtTen.text = widget.product.ten;
    txtGia.text = widget.product.gia.toString();
    txtMoTa.text = widget.product.moTa ?? "";
  }
}