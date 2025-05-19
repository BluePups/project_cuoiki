import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_thicuoiky/pages/ChiTietDonHang_Page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/DonHang_Model.dart';

class DonhangPage extends StatefulWidget {
  final String userId;

  const DonhangPage({super.key, required this.userId});

  @override
  State<DonhangPage> createState() => _DonhangPageState();
}

class _DonhangPageState extends State<DonhangPage> {
  final SupabaseClient _client = Supabase.instance.client;
  Future<List<DonHang>> fetchDonHang() async{
    final response = await _client
        .from('DonHang')
        .select()
        .eq('id_user', widget.userId)
        .order('ngayDat', ascending: false);

    return (response as List)
        .map((e) => DonHang.fromJson(e as Map<String, dynamic>))
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
      ),
      body: FutureBuilder<List<DonHang>>(
          future: fetchDonHang(),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }if(snapshot.hasError){
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            }
            final donHangs = snapshot.data!;
            if(donHangs.isEmpty){
              return const Center(child: Text('Chưa có đơn hàng nào.'));
            }
            return ListView.builder(
              itemCount: donHangs.length,
                itemBuilder: (context, index){
                final donHang = donHangs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      'Mã đơn hàng: ${donHang.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ngày đặt: ${DateFormat('dd/MM/yyyy HH:mm').format(donHang.ngayDat)}'),
                        Text('Tổng tiền: ${donHang.tongTien.toStringAsFixed(0)} d'),
                        Text('Trạng thái: ${donHang.trangThai}'),
                      ],
                    ),
                    onTap: (){
                      //mo trang chi tiet don hang
                      Get.to(ChiTietDonHangPage(donHangId: ''));
                    },
                  ),
                );
                }

            );
          }
      ),
    );
  }
}
