import '../helper/Supabase_helper.dart';

class KhachHang {
  String id;
  String tenKH;
  String diaChi;
  String soDienThoai;
  KhachHang({required this.id ,required this.tenKH, required this.diaChi, required this.soDienThoai});

  factory KhachHang.fromJson(Map<String, dynamic> json) {
    return KhachHang(
      id: json["id"] as String,
      tenKH: json["tenKH"] as String,
      diaChi: json["diaChi"] as String,
      soDienThoai: json["soDienThoai"] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "tenKH": this.tenKH,
      "diaChi": this.diaChi,
      "soDienThoai": this.soDienThoai,
    };
  }
}

class KhachHangSnapShot {
  KhachHang khachHang;
  KhachHangSnapShot({required this.khachHang});

  static Future<void> update(KhachHang newUser) async {
    await supabase.from("KhachHang")
        .update(newUser.toJson())
        .eq("id", newUser.id);
  }
  static Future<KhachHang?> getById(String id) async {
    try {
      final data = await supabase.from('KhachHang').select().eq('id', id).single();
      return KhachHang.fromJson(data);
    } catch (e) {
      print("Lỗi lấy User: $e");
      return null;
    }
  }
}
