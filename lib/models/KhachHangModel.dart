class KhachHangModel {
  final String id;
  final String? tenKH;
  final String? diaChi;
  final String? soDienThoai;

  KhachHangModel({
    required this.id,
    this.tenKH,
    this.diaChi,
    this.soDienThoai,
  });

  factory KhachHangModel.fromJson(Map<String, dynamic> json) {
    return KhachHangModel(
      id: json['id'] as String,
      tenKH: json['tenKH'] as String?,
      diaChi: json['diaChi'] as String?,
      soDienThoai: json['soDienThoai'] as String?,
    );
  }
}