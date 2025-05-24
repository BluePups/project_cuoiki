import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class ChiTietDonHang {
  final int id;
  final int id_donHang;
  final int id_sp;
  final int soLuong;
  final int gia_sp;
  final String? ten_sp;

  ChiTietDonHang({
    required this.id,
    required this.id_donHang,
    required this.id_sp,
    required this.soLuong,
    required this.gia_sp,
    this.ten_sp,
  });

  factory ChiTietDonHang.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHang(
      id: json['id'] as int,
      id_donHang: json['id_donHang'] as int,
      id_sp: json['id_sp'] as int,
      soLuong: json['soLuong'] as int,
      gia_sp: json['gia_sp'] as int,
      ten_sp: json['SanPham']?['ten'],
    );
  }
}

Future<List<ChiTietDonHang>> fetchChiTietDonHang(donHangId) async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('ChiTietDonHang')
      .select('id, id_donHang, soLuong, gia_sp, id_sp, SanPham(ten)')
      .eq('id_donHang', donHangId);

  return (response as List<dynamic>)
      .map((e) => ChiTietDonHang.fromJson(e as Map<String, dynamic>))
      .toList();
}
