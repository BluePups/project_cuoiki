import 'package:du_an_cuoi_ki/controllers/GioHang_Controller.dart';
import 'package:du_an_cuoi_ki/models/GioHang_Model.dart';
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
          return ListView.builder(
            itemCount: gioHangs.length,
            itemBuilder: (context, index) {
              final item = gioHangs[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(item.anh_sp ?? ""),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.ten_sp ?? "", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                            SizedBox(height: 4),
                            Text("Số lượng: ${item.soLuong}"),
                          ],
                        ),
                      ),
                      Text("${item.gia_sp ?? 0} đ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red,),),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}