import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cuoiki/admin/Product_Admin_Page.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:cuoiki/helper/Supabase_helper.dart';
import 'package:cuoiki/helper/Dialogs.dart';

class PageUpdateProduct extends StatefulWidget {
  final Product product;
  PageUpdateProduct({super.key, required this.product});

  @override
  State<PageUpdateProduct> createState() => _PageUpdateProductState();
}

class _PageUpdateProductState extends State<PageUpdateProduct> {
  XFile? xFile;
  late TextEditingController txtID;
  late TextEditingController txtTen;
  late TextEditingController txtGia;
  late TextEditingController txtMoTa;
  String? imageUrl;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // initState() dùng để khởi tạo dữ liệu khi widget được tạo ra.
    //
    //gán dữ liệu sản phẩm hiện tại vào các TextEditingController để hiển thị lên giao diện
    super.initState();
    txtID = TextEditingController(text: widget.product.id.toString());
    txtTen = TextEditingController(text: widget.product.ten);
    txtGia = TextEditingController(text: widget.product.gia.toString());
    txtMoTa = TextEditingController(text: widget.product.moTa ?? "");
  }

  @override
  void dispose() {
    txtID.dispose();
    txtTen.dispose();
    txtGia.dispose();
    txtMoTa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa sản phẩm", style: TextStyle(color: Colors.white),),
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
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.product.anh != null && widget.product.anh!.isNotEmpty
                      ? Image.network(widget.product.anh!, fit: BoxFit.cover)
                      : const Icon(Icons.image_outlined, size: 100, color: Colors.grey),
                )
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
                    final imagePicker = await ImagePicker().pickImage(source: ImageSource.gallery);
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

              // ID (khóa, không cho chỉnh sửa)
              TextFormField(
                controller: txtID,
                readOnly: true,
                //Tại sao trường ID không cho sửa?
                // Trả lời:
                // Vì ID là định danh duy nhất (primary key) của sản phẩm trong database.
                // Thay đổi ID có thể gây lỗi hoặc làm mất tính toàn vẹn dữ liệu, nên dùng readOnly: true.
                decoration: InputDecoration(
                  labelText: "ID",
                  prefixIcon: const Icon(Icons.confirmation_num),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 16),

              // Tên sản phẩm
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

              // Giá
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

              // Mô tả
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

              // Nút Cập nhật
              //Khi người dùng nhấn nút “Cập nhật”, chuyện gì xảy ra?
              // Trả lời chi tiết:
              //
              // Gửi SnackBar báo đang cập nhật.
              //
              // Nếu có ảnh mới, tải ảnh mới lên và cập nhật URL.
              //
              // Cập nhật tên, giá, mô tả.
              //
              // Gọi ProductSnapShot.update(product) để lưu thay đổi vào Supabase.
              //
              // Hiển thị thông báo thành công và chuyển về PageProductAdmin.
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    showSnackBar(context, message: "Đang cập nhật ${txtTen.text}...", seconds: 10);

                    if (xFile != null) {
                      imageUrl = await uploadImage(
                        image: File(xFile!.path),
                        bucket: "images",
                        path: "images/product_${txtID.text}.jpg",
                        upsert: true,
                        //Hàm uploadImage() làm gì và tại sao có upsert: true?
                        // Trả lời:
                        //
                        // uploadImage() là hàm tải ảnh lên Supabase storage.
                        //
                        // upsert: true giúp ghi đè file ảnh cũ nếu đã tồn tại → tránh tạo nhiều ảnh thừa.
                      );
                      widget.product.anh = imageUrl;
                    }

                    widget.product.ten = txtTen.text.trim();
                    widget.product.gia = int.parse(txtGia.text);
                    widget.product.moTa = txtMoTa.text.trim();

                    await ProductSnapShot.update(widget.product);

                    showSnackBar(context, message: "Đã cập nhật sản phẩm");

                    Navigator.of(context).pop(); // Quay lại trang admin
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  child: const Text(
                    "Cập nhật sản phẩm",
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
