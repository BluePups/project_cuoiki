import 'package:flutter/material.dart';

import '../models/ChiTietDonHang_Model.dart';

class ChiTietDonHangPage extends StatelessWidget {
  final String donHangId;

  const ChiTietDonHangPage({super.key, required this.donHangId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    ),
      body: FutureBuilder<List<ChiTietDonHang>>(
        future: fetchChiTietDonHang(donHangId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('Không có sản phẩm nào.'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              // final thanhTien = (item.gia_sp ?? 0) * (item.soLuong ?? 0);
              final thanhTien = item.gia_sp * item.soLuong;

              return ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: Text("${item.ten_sp}"),
                // subtitle: Text('Số lượng: ${item.soLuong ?? 0} x ${item.gia_sp ?? 0.toStringAsFixed(0)} đ'),
                subtitle: Text('Số lượng: ${item.soLuong} x ${item.gia_sp.toStringAsFixed(0)} đ'),
                trailing: Text(
                  '${thanhTien.toStringAsFixed(0)} đ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
