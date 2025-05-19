import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/ChiTietDonHang_Model.dart';

class ChiTietDonHangPage extends StatelessWidget {
  final String donHangId;

  const ChiTietDonHangPage({super.key, required this.donHangId});

  Future<List<ChiTietDonHang>> fetchChiTietDonHang() async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('ChiTietDonHang')
        .select('id, donhang_id, so_luong, gia, SanPham(ten)')
        .eq('donhang_id', donHangId);

    return (response as List<dynamic>)
        .map((e) => ChiTietDonHang.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
      body: FutureBuilder<List<ChiTietDonHang>>(
        future: fetchChiTietDonHang(),
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
              final thanhTien = item.gia * item.soLuong;

              return ListTile(
                leading: const Icon(Icons.shopping_cart),
                title: Text(item.ten_sp),
                subtitle: Text('Số lượng: ${item.soLuong} x ${item.gia.toStringAsFixed(0)} đ'),
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
