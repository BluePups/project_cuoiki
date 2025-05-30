import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../helper/Supabase_helper.dart';


class GioHang {
  int id;
  String id_user;
  int id_sp;
  int soLuong;
  String thoiGian;

  GioHang({required this.id,required this.id_user, required this.id_sp, required this.soLuong, required this.thoiGian});

  factory GioHang.fromJson(Map<String, dynamic> json) {
    return GioHang(
      id: json["id"] as int,
      id_user: json["id_user"],
      id_sp: json["id_sp"] as int,
      soLuong: json["soLuong"] as int,
      thoiGian: json["thoiGian"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "id_user": this.id_user,
      "id_sp": this.id_sp,
      "soLuong": this.soLuong,
      "thoiGian": this.thoiGian,
    };
  }
}

class GioHangSnapshot {
  GioHang gioHang;
  GioHangSnapshot({required this.gioHang});

  static Stream<List<GioHang>> getDataGioHang(String idUser) {
    final stream = Supabase.instance.client
        .from('GioHang')
        .stream(primaryKey: ['id'])
        .eq('id_user', idUser); // lọc theo id_user

    return stream.map((list) =>
        list.map((item) => GioHang.fromJson(item)).toList());
  }

  static Future<Map<int, GioHang>> getMapGioHangs() async {
    return getMapData(
        table: "GioHang",
        fromJson: GioHang.fromJson,
        getId: (t) => t.id);
  }

  static listenGioHangchange(Map<int, GioHang> maps, {Function()? updateUI}) async {
    return listenDatachange(
        maps,
        channel: "SanPham:public",
        schema: "public",
        table: "SanPham",
        fromJson: GioHang.fromJson,
        getId: (t) => t.id,
        updateUI: updateUI);
  }
}

class GioHangSanPham {
  int id;
  String id_user;
  int id_sp;
  int? soLuong;
  String? ten_sp;
  String? anh_sp;
  int? gia_sp;

  GioHangSanPham({
    required this.id,
    required this.id_user,
    required this.id_sp,
    required this.soLuong,
    this.ten_sp,
    this.anh_sp,
    this.gia_sp,
  });

  factory GioHangSanPham.fromJson(Map<String, dynamic> json) {
    return GioHangSanPham(
      id: json['id'] as int,
      id_user: json['id_user'],
      id_sp: json['id_sp'] as int,
      soLuong: json['soLuong'],
      ten_sp: json['SanPham']?['ten'],
      anh_sp: json['SanPham']?['anh'],
      gia_sp: json['SanPham']?['gia'],
    );
  }
}

class GioHangSanPhamSnapshot {
  static Stream<List<GioHangSanPham>> getDataGioHangSanPham(String userID) {
    final stream = Supabase.instance.client
        .from("GioHang")
        .stream(primaryKey: ['id'])
        .eq('id_user', userID);

    return stream.map((list) =>
        list.map((item) => GioHangSanPham.fromJson(item)).toList());
  }
  static Future<List<GioHangSanPham>> fetchGioHangSanPham(String userID) async {
    final response = await Supabase.instance.client
        .from("GioHang")
        .select('id, id_user, id_sp, soLuong, SanPham(ten, anh, gia)')
        .eq('id_user', userID);

    return (response as List)
        .map((e) => GioHangSanPham.fromJson(e as Map<String, dynamic>))
        .toList();
  }

}
