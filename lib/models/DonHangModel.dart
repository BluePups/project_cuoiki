import 'package:cuoiki/models/KhachHangModel.dart';
import 'package:cuoiki/models/ChiTietDonHangModel.dart';

class DonHangModel {
  final int id;
  final String idUser; // uuid
  final DateTime ngayDat;
  final int tongTien;
  final String trangThai;
  KhachHangModel? khachHang;
  List<ChiTietDonHangModel> chiTietDonHang;

  DonHangModel({
    required this.id,
    required this.idUser,
    required this.ngayDat,
    required this.tongTien,
    required this.trangThai,
    this.khachHang,
    this.chiTietDonHang = const [],
  });

  factory DonHangModel.fromJson(Map<String, dynamic> json, {KhachHangModel? khachHangData, List<ChiTietDonHangModel> chiTietData = const []}) {
    return DonHangModel(
      id: json['id'] as int,
      idUser: json['id_user'] as String,
      ngayDat: DateTime.parse(json['ngayDat'] as String),
      tongTien: json['tongTien'] as int,
      trangThai: json['trangThai'] as String,
      khachHang: khachHangData,
      chiTietDonHang: chiTietData,
    );
  }
}