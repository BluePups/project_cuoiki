import 'package:du_an_cuoi_ki/models/User_Model.dart';
import 'package:du_an_cuoi_ki/pages/User_Page.dart';
import 'package:flutter/material.dart';
import '../helper/Dialogs.dart';

class PageUserUpdate extends StatefulWidget {
  PageUserUpdate({super.key, required this.khachHang});
  KhachHang khachHang;

  @override
  State<PageUserUpdate> createState() => _PageUserUpdateState();
}

class _PageUserUpdateState extends State<PageUserUpdate> {
  TextEditingController txtID = TextEditingController();
  TextEditingController txtTen = TextEditingController();
  TextEditingController txtDiaChi = TextEditingController();
  TextEditingController txtSoDienThoai = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chỉnh sửa thông tin"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                readOnly: true,
                controller: txtID,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "ID",
                ),
              ),
              TextField(
                controller: txtTen,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Họ và tên",
                ),
              ),
              TextField(
                controller: txtDiaChi,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Địa chỉ",
                ),
              ),
              TextField(
                controller: txtSoDienThoai,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Số điện thoại",
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async{
                      KhachHang khachHang = widget.khachHang;
                      showSnackBar(context, message: "Đang cập nhật thông tin của bạn...", seconds: 10);
                      khachHang.tenKH = txtTen.text;
                      khachHang.diaChi = txtDiaChi.text;
                      khachHang.soDienThoai = txtSoDienThoai.text;
                      await KhachHangSnapShot.update(khachHang);
                      showSnackBar(context, message: "Đã cập nhật");
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PageThongTinKH(),)
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
  void initState() {
    super.initState();
    txtID.text = widget.khachHang.id;
    txtTen.text = widget.khachHang.tenKH;
    txtDiaChi.text = widget.khachHang.diaChi;
    txtSoDienThoai.text = widget.khachHang.soDienThoai;
  }
}