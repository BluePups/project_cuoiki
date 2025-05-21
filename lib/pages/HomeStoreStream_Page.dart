import 'package:du_an_cuoi_ki/controllers/User_Controller.dart';
import 'package:du_an_cuoi_ki/main.dart';
import 'package:du_an_cuoi_ki/models/Product_Model.dart';
import 'package:du_an_cuoi_ki/pages/ChiTietSp_Page.dart';
import 'package:du_an_cuoi_ki/pages/GioHang_Page.dart';
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
  const PageHomeStream({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Store Stream"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          GetBuilder(
            init: ControllerProduct.get(),
            id: "gh",
            builder: (controller) => GestureDetector(
              onTap: () {
                final currentUser = Supabase.instance.client.auth.currentUser;
                if(currentUser != null) {
                  Get.to(() => PageGioHang());
                }
                else
                  Get.to(() => PageStoreLogin());
              },
              child: badges.Badge(
                showBadge: controller.slMHGH! > 0,
                badgeContent: Text('${controller.slMHGH}', style: TextStyle(color: Colors.red)),
                child: Icon(Icons.shopping_cart),
              ),
            ),
          ),
          SizedBox(width: 20),
        ],

      ),
      drawer: Drawer(
        child: Obx(() {
          final authController = Get.find<AuthController>();
          final user = authController.user.value;
          return ListView(
            children: [
              if (user != null) ...[
                UserAccountsDrawerHeader(
                  accountEmail: Text(user.email ?? 'không tìm thấy email người dùng'),
                  accountName: null,
                ),
                BuildButton(context, title: "Thông tin", destination: PageThongTinKH()),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Đăng xuất'),
                  onTap: () async {
                    await authController.signOut();
                    // print("ID la: " + user!.id.toString());
                    // Navigator.of(context).pop();
                  },
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListTile(
                    leading: Icon(Icons.login),
                    title: Text("Đăng nhập"),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => PageStoreLogin()),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
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
              print("Error: ${snapshot.error}");
              return Center(child: Text("Lỗi: ${snapshot.error.toString()}"));
            }

            if(!snapshot.hasData) {
              print(snapshot.data); // Xem dữ liệu từ Supabase
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text("Loading.............."),
                  ],
                ),
              );
            }
            var products = snapshot.data!;
            return GridView.extent(
              maxCrossAxisExtent: 300,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.75,
              children: products.map(
                      (product) {
                    return Card(
                      child: GestureDetector(
                        child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Image.network(product.anh?? "https://ikdmkoqsurmbycuheihy.supabase.co/storage/v1/object/public/images/images/tui.jpg"),
                                ),
                              ),
                              Text(product.ten, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                              Text("${product.gia ?? 0} vnd")
                            ]
                        ),
                        onTap: () => {
                          Get.to(PageChitietProduct(product: product))
                        },
                      ),
                    );
                  }
              ).toList(),
            );
          }
      ),
    );
  }
}