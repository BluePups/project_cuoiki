
import 'package:cuoiki/models/Product_Model.dart';

class ChiTietDonHangModel {
  final int id;
  final int idDonHang;
  final int idSp;
  final int soLuong;
  final int gia_sp;
  Product? sanPham;

  ChiTietDonHangModel({
    required this.id,
    required this.idDonHang,
    required this.idSp,
    required this.soLuong,
    required this.gia_sp,
    this.sanPham,
  });

  factory ChiTietDonHangModel.fromJson(Map<String, dynamic> json, {Product? sanPhamData}) {
    return ChiTietDonHangModel(
      id: json['id'] as int,
      idDonHang: json['id_donHang'] as int,
      idSp: json['id_sp'] as int,
      soLuong: json['soLuong'] as int,
      gia_sp: json['gia_sp'] as int,
      sanPham: sanPhamData,
    );
  }
}