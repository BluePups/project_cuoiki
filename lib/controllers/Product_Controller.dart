import 'package:cuoiki/models/Product_Model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ControllerProduct extends GetxController {
  Map<int, Product> _maps = {};
  int slMHGH = 0;

  static ControllerProduct get() => Get.find();
  Iterable<Product> get products => _maps.values;


  @override
  void onReady() async {
    super.onReady();

    _maps = await ProductSnapShot.getMapProduct();
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

}

class BindingsHomeProductStore extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => ControllerProduct(),
    );
  }
}