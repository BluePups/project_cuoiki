import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cuoiki/admin/Product_Admin_Page.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:cuoiki/helper/Supabase_helper.dart';
import 'package:cuoiki/helper/Dialogs.dart';

class PageUpdateProduct extends StatefulWidget {
  PageUpdateProduct({super.key, required this.product});
  Product product;

  @override
  State<PageUpdateProduct> createState() => _PageUpdateProductState();
}

class _PageUpdateProductState extends State<PageUpdateProduct> {
  XFile? xFile;
  TextEditingController txtID = TextEditingController();
  TextEditingController txtTen = TextEditingController();
  TextEditingController txtGia = TextEditingController();
  TextEditingController txtMoTa = TextEditingController();
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa sản phẩm"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 300,
                child: xFile == null ? Image.network(widget.product.anh?? "Linh mac dinh") : Image.file(File(xFile!.path)),
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
                readOnly: true,
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
                      Product product = widget.product;
                      showSnackBar(context, message: "Đang cập nhật ${product.ten}...", seconds: 10);
                      if(xFile != null) {
                        imageUrl = await uploadImage(
                          image: File(xFile!.path),
                          bucket: "images",
                          path: "images/product_${txtID.text}.jpg",
                          upsert: true,
                        );
                        product.anh = imageUrl;
                      }
                      product.ten = txtTen.text;
                      product.gia = int.parse(txtGia.text);
                      product.moTa = txtMoTa.text;
                      await ProductSnapShot.update(product);
                      showSnackBar(context, message: "Đã cập nhật");
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ProductAdminPage(),)
                      );
                    },
                    child: Text("Cập nhật"),
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

  @override
  void initState() { //initState() đã khởi tạo đầy đủ
    //Tốt — đảm bảo dữ liệu cũ được hiển thị để chỉnh sửa.
    super.initState();
    txtID.text = widget.product.id.toString();
    txtTen.text = widget.product.ten;
    txtGia.text = widget.product.gia.toString();
    txtMoTa.text = widget.product.moTa?? "";
  }
}