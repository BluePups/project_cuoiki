import 'package:cuoiki/models/GioHang_Model.dart';
import 'package:get/get.dart';

class ControllerGioHang extends GetxController {
  Map<int, GioHang> _maps = {};
  RxSet<int> selectedIds = <int>{}.obs;

  static ControllerGioHang get() => Get.find();
  Iterable<GioHang> get gioHangs => _maps.values;

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
}

class BindingsGioHang extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => ControllerGioHang(),
    );
  }
}