import 'package:cuoiki/models/KhachHangModel.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminViewAllUsersPage extends StatefulWidget {
  const AdminViewAllUsersPage({super.key});

  @override
  State<AdminViewAllUsersPage> createState() => _AdminViewAllUsersPageState();
}

class _AdminViewAllUsersPageState extends State<AdminViewAllUsersPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  Future<List<KhachHangModel>>? _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<List<KhachHangModel>> _fetchUsers() async {
    try {
      final response = await _supabase
          .from('KhachHang')
          .select('id, tenKH, diaChi, soDienThoai');

      if (response == null) {
        debugPrint('Lỗi khi fetch users: response is null');
        throw Exception('Lỗi khi tải dữ liệu khách hàng (null response)');
      }

      final List<dynamic> data = response as List<dynamic>;

      if (data.isEmpty) {
        return [];
      }

      return data.map((item) => KhachHangModel.fromJson(item as Map<String, dynamic>)).toList();

    } catch (e) {
      debugPrint('Lỗi khi fetch users: $e');
      throw Exception('Lỗi khi tải dữ liệu khách hàng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh Sách Khách Hàng"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<KhachHangModel>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Đã xảy ra lỗi: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có khách hàng nào."));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.tenKH ?? "Chưa có tên",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text("ID: ${user.id}"),
                      const SizedBox(height: 4),
                      Text("Địa chỉ: ${user.diaChi ?? 'N/A'}"),
                      const SizedBox(height: 4),
                      Text("SĐT: ${user.soDienThoai != null && user.soDienThoai!.isNotEmpty ? user.soDienThoai : 'N/A'}"),
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