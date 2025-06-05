import 'package:cuoiki/models/GioHangItemModel.dart';
import 'package:cuoiki/models/KhachHangModel.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminViewAllCartsPage extends StatefulWidget {
  const AdminViewAllCartsPage({super.key});

  @override
  State<AdminViewAllCartsPage> createState() => _AdminViewAllCartsPageState();
}

class _AdminViewAllCartsPageState extends State<AdminViewAllCartsPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<List<GioHangItemModel>>? _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = _fetchAllCartItems();
  }

  Future<List<GioHangItemModel>> _fetchAllCartItems() async {
    try {
      // 1. Lấy tất cả item từ GioHang
      final cartResponse = await _supabase.from('GioHang').select();
      if (cartResponse == null) throw Exception("Không thể tải giỏ hàng");

      final List<dynamic> cartData = cartResponse as List<dynamic>;
      List<GioHangItemModel> fullCartItems = [];

      for (var itemJson in cartData) {
        Map<String, dynamic> itemMap = itemJson as Map<String, dynamic>;

        // 2. Lấy thông tin khách hàng
        KhachHangModel? khachHang;
        if (itemMap['id_user'] != null) {
          final khResponse = await _supabase
              .from('KhachHang')
              .select()
              .eq('id', itemMap['id_user'] as String)
              .maybeSingle();
          if (khResponse != null) {
            khachHang = KhachHangModel.fromJson(khResponse as Map<String, dynamic>);
          }
        }

        // 3. Lấy thông tin sản phẩm
        Product? sanPham; // Hoặc SanPhamModel?
        if (itemMap['id_sp'] != null) {
          final spResponse = await _supabase
              .from('SanPham')
              .select()
              .eq('id', itemMap['id_sp'] as int)
              .maybeSingle();
          if (spResponse != null) {
            sanPham = Product.fromJson(spResponse as Map<String, dynamic>);
          }
        }
        fullCartItems.add(GioHangItemModel.fromJson(itemMap, khachHangData: khachHang, sanPhamData: sanPham));
      }
      return fullCartItems;
    } catch (e) {
      debugPrint('Lỗi khi tải item giỏ hàng: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải dữ liệu giỏ hàng: ${e.toString()}')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
    final NumberFormat currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh Sách Giỏ Hàng Users"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<GioHangItemModel>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có sản phẩm nào trong giỏ hàng của users."));
          }

          final items = snapshot.data!;
          Map<String, List<GioHangItemModel>> itemsByUser = {};
          for (var item in items) {
            String userName = item.khachHang?.tenKH ?? item.idUser;
            if (!itemsByUser.containsKey(userName)) {
              itemsByUser[userName] = [];
            }
            itemsByUser[userName]!.add(item);
          }

          List<String> userNames = itemsByUser.keys.toList();

          return ListView.builder(
            itemCount: userNames.length,
            itemBuilder: (context, userIndex) {
              String userName = userNames[userIndex];
              List<GioHangItemModel> userCartItems = itemsByUser[userName]!;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: ExpansionTile(
                  title: Text("Giỏ hàng của: ${userName}", style: TextStyle(fontWeight: FontWeight.bold)),
                  children: userCartItems.map((item) {
                    return ListTile(
                      leading: item.sanPham?.anh != null
                          ? Image.network(item.sanPham!.anh!, width: 50, height: 50, fit: BoxFit.cover)
                          : SizedBox(width: 50, height: 50, child: Icon(Icons.image_not_supported)),
                      title: Text(item.sanPham?.ten ?? 'Sản phẩm không xác định'),
                      subtitle: Text(
                          "SL: ${item.soLuong}\n"
                              "Giá SP: ${item.sanPham?.gia != null ? currencyFormatter.format(item.sanPham!.gia) : 'N/A'}\n"
                              "Thêm lúc: ${dateFormatter.format(item.thoiGian)}"
                      ),
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