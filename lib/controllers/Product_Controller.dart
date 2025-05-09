import 'package:cuoiki/models/Product_Model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ControllerProduct extends GetxController {
  Map<int, Product> _maps = {};
  var gh = <GH_Item>[];

  int get slMHGH => gh.length;
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

    for(var item in gh) {
      if(p.id == item.product.id) {
        item.sl++;
        return;
      }
    }

    gh.add(GH_Item(product: p, sl: 1));
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

class GH_Item {
  Product product;
  int sl;

  GH_Item({required this.product, required this.sl});
}