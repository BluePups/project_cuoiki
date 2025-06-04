// lib/models/chi_tiet_don_hang_model.dart
import 'package:cuoiki/models/Product_Model.dart'; // Giả sử bạn có SanPhamModel

class ChiTietDonHangModel {
  final int id;
  final int idDonHang;
  final int idSp;
  final int soLuong;
  final int gia;
  Product? sanPham; // Để lưu thông tin sản phẩm (tên, ảnh)

  ChiTietDonHangModel({
    required this.id,
    required this.idDonHang,
    required this.idSp,
    required this.soLuong,
    required this.gia,
    this.sanPham,
  });

  factory ChiTietDonHangModel.fromJson(Map<String, dynamic> json, {Product? sanPhamData}) {
    return ChiTietDonHangModel(
      id: json['id'] as int,
      idDonHang: json['id_donHang'] as int,
      idSp: json['id_sp'] as int,
      soLuong: json['soLuong'] as int,
      gia: json['gia'] as int,
      sanPham: sanPhamData, // Gán sản phẩm nếu có
    );
  }
}