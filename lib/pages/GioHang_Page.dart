import 'package:cuoiki/controllers/GioHang_Controller.dart';
import 'package:cuoiki/models/GioHang_Model.dart';
import 'package:cuoiki/pages/HomeStoreStream_Page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class PageGioHang extends StatefulWidget {
  PageGioHang({super.key});

  @override
  State<PageGioHang> createState() => _PageGioHangStreamState();

}

class _PageGioHangStreamState extends State<PageGioHang> {
  final currentUser = Supabase.instance.client.auth.currentUser;
  final gioHangController = Get.put(ControllerGioHang());

  int tinhTongTien(List<GioHangSanPham> items) {
    return items
        .where((item) => gioHangController.selectedIds.contains(item.id))
        .map((item) => (item.gia_sp ?? 0) * (item.soLuong ?? 1))
        .fold(0, (a, b) => a + b);
  }

  void xuLyThanhToan() async {
    final supabase = Supabase.instance.client;

    for (var id in gioHangController.selectedIds) {
      await supabase.from('GioHang').delete().eq('id', id);
    }

    gioHangController.selectedIds.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Đã thanh toán")),
    );
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PageHomeStream(),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng của bạn"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
        stream: GioHangSanPhamSnapshot.getDataGioHangSanPham(currentUser!.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var gioHangs = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: gioHangs.length,
                  itemBuilder: (context, index) {
                    final item = gioHangs[index];
                    return Obx(() {
                      final isSelected = gioHangController.selectedIds.contains(item.id);
                      return GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            gioHangController.selectedIds.remove(item.id);
                          } else {
                            gioHangController.selectedIds.add(item.id);
                          }
                        },
                        child: Card(
                          color: isSelected
                              ? Colors.green.shade100
                              : Colors.white,
                          margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                                      Text(
                                        item.ten_sp ?? "",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text("Số lượng: ${item.soLuong}"),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${item.gia_sp ?? 0} đ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
              Obx(() {
                final tongTien = gioHangController.tinhTongTien(gioHangs);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng tiền: ${tongTien} đ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        onPressed: gioHangController.selectedIds.isEmpty ? null : xuLyThanhToan,
                        child: Text("Thanh toán"),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
