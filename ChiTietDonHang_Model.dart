class ChiTietDonHang {
  final String id;
  final String id_donhang;
  final String ten_sp;
  final int soLuong;
  final double gia;

  ChiTietDonHang({
    required this.id,
    required this.id_donhang,
    required this.ten_sp,
    required this.soLuong,
    required this.gia,
  });

  factory ChiTietDonHang.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHang(
      id: json['id'] as String,
      id_donhang: json['id_donhang'] as String,
      ten_sp: json['ten_sp'] as String,
      soLuong: json['soLuong'] as int,
      gia: (json['gia'] as num).toDouble(),
    );
  }
}
