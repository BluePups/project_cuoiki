import 'dart:io';

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
  final TextEditingController txtID = TextEditingController();
  final TextEditingController txtTen = TextEditingController();
  final TextEditingController txtGia = TextEditingController();
  final TextEditingController txtMoTa = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Thêm key cho form validation

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm sản phẩm", style: TextStyle(color: Colors.white),),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Ảnh sản phẩm
              Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: xFile == null
                    ? const Icon(Icons.image_outlined, size: 100, color: Colors.grey)
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(File(xFile!.path), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),

              // Nút chọn ảnh
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    var imagePicker = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (imagePicker != null) {
                      setState(() {
                        xFile = imagePicker;
                      });
                    }
                  },
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Chọn ảnh"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Các trường nhập liệu
              TextFormField(
                controller: txtID,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "ID",
                  prefixIcon: const Icon(Icons.confirmation_num),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ID';
                  }
                  if (int.tryParse(value) == null) {
                    return 'ID phải là số nguyên';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: txtTen,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Tên sản phẩm",
                  prefixIcon: const Icon(Icons.label),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên sản phẩm';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: txtGia,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Giá",
                  prefixIcon: const Icon(Icons.monetization_on),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Giá phải là số';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: txtMoTa,
                keyboardType: TextInputType.text,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Mô tả",
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  alignLabelWithHint: true,
                ),
              ),

              const SizedBox(height: 30),

              // Nút Thêm sản phẩm
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return; // Nếu validation fail thì không submit
                    }

                    if (xFile == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng chọn ảnh sản phẩm')),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Đang thêm ${txtTen.text}..."),
                        duration: const Duration(seconds: 5),
                      ),
                    );

                    var imageUrl = await uploadImage(
                      image: File(xFile!.path),
                      bucket: "images",
                      path: "images/product_${txtID.text}.jpg",
                    );

                    Product product = Product(
                      id: int.parse(txtID.text),
                      ten: txtTen.text.trim(),
                      gia: int.parse(txtGia.text),
                      moTa: txtMoTa.text.trim(),
                      anh: imageUrl,
                    );

                    await ProductSnapShot.insert(product);

                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Đã thêm ${txtTen.text}"),
                        duration: const Duration(seconds: 3),
                      ),
                    );

                    Navigator.of(context).pop(); // Trở về trang admin list
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  child: const Text(
                    "Thêm sản phẩm",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
