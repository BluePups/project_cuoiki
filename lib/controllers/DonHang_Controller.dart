import 'package:supabase/supabase.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../models/DonHang_Model.dart';

final supabase = Supabase.instance.client;

Future<void> taoDonHangTuGioHang(String idUser, int tongTien) async {
  try {
    // Tạo đơn hàng mới
    final response = await supabase
        .from('DonHang')
        .insert({
      'id_user': idUser,
      'tongTien': tongTien,
      'trangThai': 'Đang xử lý',
    })
        .select();

    final donHangId = response[0]['id'];

    final gioHangItems = await supabase
        .from('GioHang')
        .select()
        .eq('user_id', idUser);

    for (var item in gioHangItems) {
      await supabase
          .from('ChiTietDonHang')
          .insert({
        'donhang_id': donHangId,
        'sanpham_id': item['sanpham_id'],
        'so_luong': item['so_luong'],
        'gia': item['gia'],
      });
    }

    await supabase
        .from('GioHang')
        .delete()
        .eq('user_id', idUser);

  } catch (e) {
    throw Exception('Lỗi khi tạo đơn hàng: $e');
  }
}

// Changed to return a Stream<List<DonHang>> for real-time updates
Stream<List<DonHang>> fetchDonHangStream(id_user) {
  // Using .stream() to listen for real-time changes
  return supabase
      .from('DonHang')
      .stream(primaryKey: ['id']) // Specify primary key for efficient streaming
      .eq('id_user',id_user)
      .order('ngayDat', ascending: false)
      .map((maps) => maps.map((e) => DonHang.fromJson(e)).toList());
}