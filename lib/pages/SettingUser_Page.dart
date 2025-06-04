import 'package:flutter/material.dart';
import 'package:cuoiki/models/User_Model.dart';
import 'package:cuoiki/pages/User_Page.dart';
import '../helper/Dialogs.dart';

class PageUserUpdate extends StatefulWidget {
  final KhachHang khachHang;

  const PageUserUpdate({super.key, required this.khachHang});

  @override
  State<PageUserUpdate> createState() => _PageUserUpdateState();
}

class _PageUserUpdateState extends State<PageUserUpdate> {
  late TextEditingController txtID;
  late TextEditingController txtTen;
  late TextEditingController txtDiaChi;
  late TextEditingController txtSoDienThoai;

  @override
  void initState() {
    super.initState();
    txtID = TextEditingController(text: widget.khachHang.id);
    txtTen = TextEditingController(text: widget.khachHang.tenKH);
    txtDiaChi = TextEditingController(text: widget.khachHang.diaChi);
    txtSoDienThoai = TextEditingController(text: widget.khachHang.soDienThoai);
  }

  @override
  void dispose() {
    txtID.dispose();
    txtTen.dispose();
    txtDiaChi.dispose();
    txtSoDienThoai.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa thông tin"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildTextField(txtID, "Mã khách hàng", readOnly: true),
                  const SizedBox(height: 16),
                  _buildTextField(txtTen, "Họ và tên"),
                  const SizedBox(height: 16),
                  _buildTextField(txtDiaChi, "Địa chỉ"),
                  const SizedBox(height: 16),
                  _buildTextField(txtSoDienThoai, "Số điện thoại", keyboardType: TextInputType.phone),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _updateCustomerInfo,
                        icon: const Icon(Icons.save),
                        label: const Text("Cập nhật"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool readOnly = false, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: readOnly ? Colors.grey.shade200 : Colors.white,
      ),
    );
  }

  Future<void> _updateCustomerInfo() async {
    showSnackBar(context, message: "Đang cập nhật thông tin...", seconds: 8);
    final updatedKhachHang = widget.khachHang
      ..tenKH = txtTen.text
      ..diaChi = txtDiaChi.text
      ..soDienThoai = txtSoDienThoai.text;

    await KhachHangSnapShot.update(updatedKhachHang);

    showSnackBar(context, message: "Đã cập nhật thông tin.");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const PageThongTinKH()),
    );
  }
}
