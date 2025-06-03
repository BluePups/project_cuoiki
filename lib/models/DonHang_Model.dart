class DonHang {
  final int id;
  final String? id_user;
  final DateTime ngayDat;
  final int tongTien;
  final String? trangThai;

  DonHang({
    required this.id,
    required this.id_user,
    required this.ngayDat,
    required this.tongTien,
    required this.trangThai,

  });

  factory DonHang.fromJson(Map<String, dynamic> json) {
    return DonHang(
      id: json['id'] as int,
      id_user: json['id_user'],
      ngayDat: DateTime.parse(json['ngayDat']),
      tongTien: json['tongTien'] as int,
      trangThai: json['trangThai'],
    );
  }
}
