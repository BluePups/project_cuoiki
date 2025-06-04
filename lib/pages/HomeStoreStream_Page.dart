import 'package:cuoiki/controllers/User_Controller.dart';
import 'package:cuoiki/main.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:cuoiki/pages/ChiTietSp_Page.dart';
import 'package:cuoiki/pages/GioHang_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../controllers/Product_Controller.dart';
import 'package:badges/badges.dart' as badges;
import 'User_Page.dart';

class AppStreamStore extends StatelessWidget {
  const AppStreamStore({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsHomeProductStore(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: PageHomeStream(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class PageHomeStream extends StatelessWidget {
  PageHomeStream({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("🛒 Store Stream", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          GetBuilder<ControllerProduct>(
            init: ControllerProduct.get(),
            id: "gh",
            builder: (controller) => GestureDetector(
              onTap: () {
                final currentUser = Supabase.instance.client.auth.currentUser;
                if (currentUser != null) {
                  Get.to(() => PageGioHang());
                } else {
                  Get.to(() => PageStoreLogin());
                }
              },
              child: badges.Badge(
                showBadge: controller.slMHGH.value > 0,
                badgeContent: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    '${controller.slMHGH.value}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.cyan.shade700.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),
        ],
      ),

      drawer: Drawer(
        child: Obx(() {
          final authController = Get.find<AuthController>();
          final user = authController.user.value;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              if (user != null) ...[
                UserAccountsDrawerHeader(
                  accountEmail: Text(user.email ?? "Không tìm thấy email"),
                  accountName: const Text(""),
                  currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text("Thông tin cá nhân"),
                  onTap: () => Get.to(() => const PageThongTinKH()),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Đăng xuất"),
                  onTap: () async {
                    await authController.signOut();
                    final controllerProduct = ControllerProduct.get();
                    controllerProduct.slMHGH.value = 0;
                    controllerProduct.update(["gh"]);
                    Get.back(); // đóng Drawer
                  },
                ),
              ] else ...[
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text("Đăng nhập"),
                  onTap: () async {
                    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PageStoreLogin()));
                    Navigator.of(context).pop();
                  },
                ),
              ]
            ],
          );
        }),
      ),

      body: StreamBuilder(
        stream: ProductSnapShot.getProductStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}", style: textTheme.bodyLarge));
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Đang tải dữ liệu..."),
                ],
              ),
            );
          }

          final products = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  onTap: () => Get.to(PageChitietProduct(product: product)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            product.anh ?? "https://ikdmkoqsurmbycuheihy.supabase.co/storage/v1/object/public/images/images/tui.jpg",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(product.ten, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text("${product.gia ?? 0} VND", style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

