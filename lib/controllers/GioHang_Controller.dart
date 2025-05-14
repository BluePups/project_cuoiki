import 'package:cuoiki/models/GioHang_Model.dart';
import 'package:get/get.dart';

class ControllerGioHang extends GetxController {
  Map<int, GioHang> _maps = {};

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
}

class BindingsGioHang extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => ControllerGioHang(),
    );
  }
}