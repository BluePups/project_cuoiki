class DonHang {
  final String id;
  final String id_user;
  final DateTime ngayDat;
  final double tongTien;
  final String trangThai;

  DonHang({
    required this.id,
    required this.id_user,
    required this.ngayDat,
    required this.tongTien,
    required this.trangThai,

  });

  factory DonHang.fromJson(Map<String, dynamic> json) {
    return DonHang(
      id: json['id'] as String,
      id_user: json['id_user'] as String,
      ngayDat: DateTime.parse(json['ngayLap']),
      tongTien: (json['tongTien'] as num).toDouble(),
      trangThai: json['trangThai'] as String,
    );
  }
}
