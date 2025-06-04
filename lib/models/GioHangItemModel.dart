// lib/models/gio_hang_item_model.dart
import 'package:cuoiki/models/KhachHangModel.dart';
import 'package:cuoiki/models/Product_Model.dart'; // Hoặc SanPhamModel

class GioHangItemModel {
  final int id;
  final String idUser; // uuid
  final int idSp;
  final int soLuong;
  final DateTime thoiGian;
  KhachHangModel? khachHang; // Để lưu thông tin khách hàng
  Product? sanPham;       // Để lưu thông tin sản phẩm

  GioHangItemModel({
    required this.id,
    required this.idUser,
    required this.idSp,
    required this.soLuong,
    required this.thoiGian,
    this.khachHang,
    this.sanPham,
  });

  factory GioHangItemModel.fromJson(Map<String, dynamic> json, {KhachHangModel? khachHangData, Product? sanPhamData}) {
    return GioHangItemModel(
      id: json['id'] as int,
      idUser: json['id_user'] as String,
      idSp: json['id_sp'] as int,
      soLuong: json['soLuong'] as int, // Chú ý 'L' hoa
      thoiGian: DateTime.parse(json['thoiGian'] as String),
      khachHang: khachHangData,
      sanPham: sanPhamData,
    );
  }
}