import 'package:cuoiki/controllers/GioHang_Controller.dart';
import 'package:cuoiki/models/GioHang_Model.dart';
import 'package:cuoiki/pages/DonHang_Page.dart';
import 'package:cuoiki/pages/HomeStoreStream_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../controllers/Product_Controller.dart';

class PageGioHang extends StatefulWidget {
  PageGioHang({super.key});

  @override
  State<PageGioHang> createState() => _PageGioHangState();
}

class _PageGioHangState extends State<PageGioHang> {
  final currentUser = Supabase.instance.client.auth.currentUser;
  final gioHangController = Get.put(ControllerGioHang());
  late Future<List<GioHangSanPham>> futureGioHang;

  @override
  void initState() {
    super.initState();
    futureGioHang = GioHangSanPhamSnapshot.fetchGioHangSanPham(currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng của bạn"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PageHomeStream()));
            },
            child: Icon(Icons.home),
          ),
        ],
      ),
      body: FutureBuilder<List<GioHangSanPham>>(
        future: futureGioHang,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: \${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var gioHangs = snapshot.data!;

          if (gioHangs.isEmpty) {
            return Center(child: Text("Giỏ hàng của bạn đang trống, hãy vào trang chủ và mua gì đó"));
          }

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
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text("Số lượng: "),
                                          IconButton(
                                              onPressed: () {
                                                if((item.soLuong ?? 1) > 1) {
                                                  gioHangController.capNhatSoLuong(item.id, (item.soLuong ?? 1) - 1);
                                                  setState(() {
                                                    futureGioHang = GioHangSanPhamSnapshot.fetchGioHangSanPham(currentUser!.id);
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.remove)
                                          ),
                                          Text("${item.soLuong}", style: TextStyle(fontSize: 16),),
                                          IconButton(
                                              onPressed: () {
                                                gioHangController.capNhatSoLuong(item.id, (item.soLuong ?? 1) + 1);
                                                setState(() {
                                                  futureGioHang = GioHangSanPhamSnapshot.fetchGioHangSanPham(currentUser!.id);
                                                });
                                              },
                                              icon: Icon(Icons.add)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${item.gia_sp ?? 0} đ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        await gioHangController.xoaSanPhamKhoiGioHang(item.id);

                                        setState(() {
                                          futureGioHang = GioHangSanPhamSnapshot.fetchGioHangSanPham(currentUser!.id);
                                        });
                                        // 🔻 Kiểm tra nếu không còn sản phẩm, reset số badge
                                        final controllerProduct = ControllerProduct.get();
                                        final gioHangList = await GioHangSanPhamSnapshot.fetchGioHangSanPham(currentUser!.id);
                                        if (gioHangList.isEmpty) {
                                          controllerProduct.slMHGH.value = 0;
                                          controllerProduct.update(["gh"]);
                                        }

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Đã xóa sản phẩm")),
                                        );
                                      },
                                      icon: Icon(Icons.delete, size: 18),
                                      label: Text("Xóa", style: TextStyle(fontSize: 14)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        textStyle: TextStyle(fontSize: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ],
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
                        onPressed: () {
                          if (gioHangController.selectedIds.isEmpty) {
                            return;
                          } else {
                            gioHangController.xuLyThanhToan(tongTien, currentUser!.id);
                            // ➕ Reset badge sau thanh toán
                            final controllerProduct = ControllerProduct.get();
                            controllerProduct.slMHGH.value = 0;
                            controllerProduct.update(["gh"]);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Đã thanh toán")),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Đã thanh toán")),
                            );
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => DonhangPage(id_user: currentUser!.id))
                            );
                          }
                        },
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