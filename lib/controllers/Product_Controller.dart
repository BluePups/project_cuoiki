import 'package:cuoiki/models/Product_Model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ControllerProduct extends GetxController {
  Map<int, Product> _maps = {};
  RxInt slMHGH = 0.obs;

  static ControllerProduct get() => Get.find();
  Iterable<Product> get products => _maps.values;

  @override
  void onReady() async {
    super.onReady();

    _maps = await ProductSnapShot.getMapProducts();
    update(["products"]);
    ProductSnapShot.listenProductchange(
      _maps,
      updateUI: () => update(["products"]),
    );
  }

  Future<void> themMHGH(Product p, String userId) async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from("GioHang")
        .select()
        .eq("id_user", userId)
        .eq("id_sp", p.id)
        .maybeSingle();

    if (response != null) {
      await supabase
          .from("GioHang")
          .update({"soLuong": response["soLuong"] + 1})
          .eq("id", response["id"]);
    } else {
      await supabase
          .from("GioHang")
          .insert({
        "id_user": userId,
        "id_sp": p.id,
        "soLuong": 1,
      });
    }
  }
  Future<void> capNhatSoLuongMatHangGioHang(String userId) async {
    final supabase = Supabase.instance.client;

    final list = await supabase
        .from("GioHang")
        .select("id_sp")
        .eq("id_user", userId);

    final uniqueIdSp = list.map((e) => e["id_sp"]).toSet();

    // slMHGH = uniqueIdSp.length as RxInt;
    slMHGH.value = uniqueIdSp.length;

    update(["gh"]);
  }

}

class BindingsHomeProductStore extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => ControllerProduct(),
    );
  }
}