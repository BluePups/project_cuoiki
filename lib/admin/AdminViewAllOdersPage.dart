import 'package:cuoiki/models/DonHangModel.dart';
import 'package:cuoiki/models/KhachHangModel.dart';
import 'package:cuoiki/models/ChiTietDonHangModel.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminViewAllOrdersPage extends StatefulWidget {
  const AdminViewAllOrdersPage({super.key});

  @override
  State<AdminViewAllOrdersPage> createState() => _AdminViewAllOrdersPageState();
}

class _AdminViewAllOrdersPageState extends State<AdminViewAllOrdersPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<List<DonHangModel>>? _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchAllOrdersWithDetails();
  }

  // Hàm chính để lấy tất cả đơn hàng và chi tiết của chúng
  Future<List<DonHangModel>> _fetchAllOrdersWithDetails() async {
    try {
      // 1. Lấy tất cả đơn hàng
      final ordersResponse = await _supabase.from('DonHang').select();
      if (ordersResponse == null) throw Exception("Không thể tải đơn hàng");

      final List<dynamic> ordersData = ordersResponse as List<dynamic>;
      List<DonHangModel> fullOrders = [];

      for (var orderJson in ordersData) {
        Map<String, dynamic> orderMap = orderJson as Map<String, dynamic>;

        // 2. Lấy thông tin khách hàng cho từng đơn hàng
        KhachHangModel? khachHang;
        if (orderMap['id_user'] != null) {
          final khachHangResponse = await _supabase
              .from('KhachHang')
              .select()
              .eq('id', orderMap['id_user'] as String)
              .maybeSingle(); // Lấy 1 hoặc null
          if (khachHangResponse != null) {
            khachHang = KhachHangModel.fromJson(khachHangResponse as Map<String, dynamic>);
          }
        }

        // 3. Lấy chi tiết đơn hàng (các sản phẩm) cho từng đơn hàng
        List<ChiTietDonHangModel> chiTietList = [];
        final chiTietResponse = await _supabase
            .from('ChiTietDonHang')
            .select('id, id_donHang, id_sp, soLuong, gia_sp')
            .eq('id_donHang', orderMap['id'] as int);

        if (chiTietResponse != null) {
          final List<dynamic> chiTietDataList = chiTietResponse as List<dynamic>;
          for (var ctJson in chiTietDataList) {
            Map<String, dynamic> ctMap = ctJson as Map<String, dynamic>;
            // 4. Lấy thông tin sản phẩm cho từng chi tiết
            Product? sanPham;
            if (ctMap['id_sp'] != null) {
              final spResponse = await _supabase
                  .from('SanPham')
                  .select()
                  .eq('id', ctMap['id_sp'] as int)
                  .maybeSingle();
              if (spResponse != null) {
                sanPham = Product.fromJson(spResponse as Map<String, dynamic>);
              }
            }
            chiTietList.add(ChiTietDonHangModel.fromJson(ctMap, sanPhamData: sanPham));
          }
        }
        fullOrders.add(DonHangModel.fromJson(orderMap, khachHangData: khachHang, chiTietData: chiTietList));
      }
      return fullOrders;
    } catch (e) {
      debugPrint('Lỗi khi tải chi tiết đơn hàng: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải đơn hàng: ${e.toString()}')),
      );
      rethrow; // Ném lại lỗi để FutureBuilder bắt được
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
    final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh Sách Đơn Hàng"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<DonHangModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải đơn hàng: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có đơn hàng nào."));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(10.0),
                child: ExpansionTile( // Sử dụng ExpansionTile để hiển thị chi tiết
                  title: Text(
                    "ĐH #${order.id} - ${order.khachHang?.tenKH ?? 'N/A'}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Ngày: ${dateFormatter.format(order.ngayDat)}\n"
                          "Tổng: ${currencyFormatter.format(order.tongTien)}\n"
                          "Trạng thái: ${order.trangThai}"
                  ),
                  children: order.chiTietDonHang.map((item) {
                    return ListTile(
                      leading: item.sanPham?.anh != null
                          ? Image.network(item.sanPham!.anh!, width: 50, height: 50, fit: BoxFit.cover)
                          : SizedBox(width: 50, height: 50, child: Icon(Icons.image_not_supported)),
                      title: Text(item.sanPham?.ten ?? 'Sản phẩm không xác định'),
                      subtitle: Text("SL: ${item.soLuong} - Giá: ${currencyFormatter.format(item.gia_sp)}"),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}