import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class DonHang {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<void> taoDonHangTuGioHang(String id_user) async {
    try {
      // Tạo đơn hàng mới
      final response = await _supabaseClient
          .from('DonHang')
          .insert({
        'id_user': id_user,
        'ngayDat': DateTime.now().toIso8601String(),
        'tongTien': 0,
        'trangThai': 'Đang xử lý',
      })
          .select();

      final donHangId = response[0]['id'];

      final gioHangItems = await _supabaseClient
          .from('GioHang')
          .select()
          .eq('user_id', id_user);

      for (var item in gioHangItems) {
        await _supabaseClient
            .from('ChiTietDonHang')
            .insert({
          'donhang_id': donHangId,
          'sanpham_id': item['sanpham_id'],
          'so_luong': item['so_luong'],
          'gia': item['gia'],
        });
      }

      await _supabaseClient
          .from('GioHang')
          .delete()
          .eq('user_id', id_user);

    } catch (e) {
      throw Exception('Lỗi khi tạo đơn hàng: $e');
    }
  }
}

class DonHangBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DonHang());
  }
}
