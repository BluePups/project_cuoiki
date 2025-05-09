import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthController extends GetxController {
  Rx<User?> user = Rx<User?>(Supabase.instance.client.auth.currentUser);

  @override
  void onInit() {
    super.onInit();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      user.value = data.session?.user;
    });
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    user.value = null;
    // Get.offAllNamed('/login');
  }
}