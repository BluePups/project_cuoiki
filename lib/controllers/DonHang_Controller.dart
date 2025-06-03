import 'package:supabase/supabase.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

final SupabaseClient _supabaseClient = Supabase.instance.client;

Future<void> taoDonHangTuGioHang(String idUser, int tongTien) async {
  try {
    // Tạo đơn hàng mới
    final response = await _supabaseClient
        .from('DonHang')
        .insert({
      'id_user': idUser,
      'tongTien': tongTien,
      'trangThai': 'Đang xử lý',
    })
        .select();

    final donHangId = response[0]['id'];

    final gioHangItems = await _supabaseClient
        .from('GioHang')
        .select()
        .eq('user_id', idUser);

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
        .eq('user_id', idUser);

  } catch (e) {
    throw Exception('Lỗi khi tạo đơn hàng: $e');
  }
}