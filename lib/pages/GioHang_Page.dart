import 'package:cuoiki/controllers/GioHang_Controller.dart';
import 'package:cuoiki/models/GioHang_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class PageGioHang extends StatelessWidget {
  PageGioHang({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageGioHangStream(),
    );
  }
}

class PageGioHangStream extends StatelessWidget {
  final currentUser = Supabase.instance.client.auth.currentUser;
  PageGioHangStream({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng của bạn á hẹ hẹ hẹ"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
        stream: GioHangSanPhamSnapshot.getDataGioHangSanPham(currentUser!.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var gioHangs = snapshot.data!;
          return GridView.extent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 0.75,
            children: gioHangs.map((item) {
              return Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(item.anh_sp?? ""),
                    ),
                    Text(item.ten_sp?? "Sản phẩm", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("${item.gia_sp?? 0} VND"),
                    Text("Số lượng: ${item.soLuong?? 1}")
                  ],
                ),
              );
            }).toList(),
          );
        },
      )
,
    );
  }
}
