import 'package:cuoiki/models/GioHang_Model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import '../pages/HomeStoreStream_Page.dart';

class ControllerGioHang extends GetxController {
  Map<int, GioHang> _maps = {};
  RxSet<int> selectedIds = <int>{}.obs;

  static ControllerGioHang get() => Get.find();
  Iterable<GioHang> get gioHangs => _maps.values;

  BuildContext? get context => null;

  @override
  void onReady() async{
    super.onReady();

    _maps = await GioHangSnapshot.getMapGioHangs();
    update(["gioHangs"]);
    GioHangSnapshot.listenGioHangchange(
      _maps,
      updateUI: () => update(["gioHangs"]),
    );
  }

  int tinhTongTien(List<dynamic> items) {
    return items
        .where((item) => selectedIds.contains(item.id))
        .map((item) => (item.gia_sp ?? 0) * (item.soLuong ?? 1))
        .fold(0, (a, b) => (a + b).toInt());
  }

  void clearSelected() {
    selectedIds.clear();
  }

  void xuLyThanhToan() async {
    final supabase = Supabase.instance.client;

    for (var id in selectedIds) {
      await supabase.from('GioHang').delete().eq('id', id);
    }

    selectedIds.clear();
  }
}

class BindingsGioHang extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => ControllerGioHang(),
    );
  }
}