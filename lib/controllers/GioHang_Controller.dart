import 'package:cuoiki/models/GioHang_Model.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

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

  void xuLyThanhToan(int tongTien, String idUser) async {
    final supabase = Supabase.instance.client;

    final gioHangItems = await supabase
        .from('GioHang')
        .select()
        .inFilter('id', selectedIds.toList());

    final response = await supabase
        .from('DonHang')
        .insert({
      'id_user': idUser,
      'tongTien': tongTien,
      'trangThai': 'Đang xử lý',
    })
        .select();

    final donHangId = response[0]['id'];

    for (var item in gioHangItems) {
      final sp = await supabase
          .from('SanPham')
          .select('gia')
          .eq('id', item['id_sp'])
          .single();

      final giaSp = sp['gia'];

      await supabase.from('ChiTietDonHang').insert({
        'id_donHang': donHangId,
        'id_sp': item['id_sp'],
        'soLuong': item['soLuong'],
        'gia_sp': giaSp,
      });
    }


    for (var id in selectedIds) {
      await supabase.from('GioHang').delete().eq('id', id);
    }
    selectedIds.clear();
  }


  Future<void> capNhatSoLuong(int idGioHang, int soLuongMoi) async {
    final supabase = Supabase.instance.client;

    await supabase
        .from("GioHang")
        .update({"soLuong": soLuongMoi})
        .eq("id", idGioHang);

    update();
    refresh();
  }

  Future<void> xoaSanPhamKhoiGioHang(int id) async {
    await Supabase.instance.client.from('GioHang').delete().eq('id', id);

    update();
    // refresh();
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