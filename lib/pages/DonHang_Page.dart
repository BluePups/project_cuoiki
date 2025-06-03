import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import '../models/DonHang_Model.dart';
import 'ChiTietDH_Page.dart';

class DonhangPage extends StatefulWidget {
  final String id_user;

  const DonhangPage({super.key, required this.id_user});

  @override
  State<DonhangPage> createState() => _DonhangPageState();
}

class _DonhangPageState extends State<DonhangPage> {
  final SupabaseClient _client = Supabase.instance.client;

  // Changed to return a Stream<List<DonHang>> for real-time updates
  Stream<List<DonHang>> fetchDonHangStream() {
    // Using .stream() to listen for real-time changes
    return _client
        .from('DonHang')
        .stream(primaryKey: ['id']) // Specify primary key for efficient streaming
        .eq('id_user', widget.id_user)
        .order('ngayDat', ascending: false)
        .map((maps) => maps.map((e) => DonHang.fromJson(e)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, // Added some styling
        foregroundColor: Colors.white, // Text color for app bar
      ),
      body: StreamBuilder<List<DonHang>>( // Changed from FutureBuilder to StreamBuilder
        stream: fetchDonHangStream(), // Use the stream method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Log the error for debugging
            print('Error fetching orders: ${snapshot.error}');
            return Center(child: Text('Lỗi tải đơn hàng: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có đơn hàng nào.'));
          }

          final donHangs = snapshot.data!;

          return ListView.builder(
            itemCount: donHangs.length,
            itemBuilder: (context, index) {
              final donHang = donHangs[index];
              return Slidable( // Wrap each item with Slidable
                key: ValueKey(donHang.id), // Unique key for each Slidable item
                endActionPane: ActionPane(
                  motion: const DrawerMotion(), // Choose a motion type
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        // Navigate to detail page when "View" is pressed
                        Get.to(() => ChiTietDonHangPage(donHangId: donHang.id.toString()));
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.visibility,
                      label: 'Xem',
                      borderRadius: BorderRadius.circular(8), // Rounded corners for action
                    ),
                  ],
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4, // Added elevation for better visual
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners for the card
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Mã đơn hàng: ${donHang.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.deepPurple, // Styled text
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ngày đặt: ${(donHang.ngayDat)}', // Formatted date
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tổng tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(donHang.tongTien)}', // Formatted currency
                            style: const TextStyle(fontSize: 14, color: Colors.green),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Trạng thái: ${donHang.trangThai}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: donHang.trangThai == 'Hoàn thành' ? Colors.teal : Colors.orange, // Conditional styling
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                    onTap: () {
                      // Navigate to detail page when ListTile is tapped
                      Get.to(() => ChiTietDonHangPage(donHangId: donHang.id.toString()));
                    },
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
