import 'package:cuoiki/controllers/User_Controller.dart';
import 'package:cuoiki/main.dart';
import 'package:cuoiki/models/Product_Model.dart';
import 'package:cuoiki/pages/ChiTietSp_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            id:"gh",
            builder: (controller) => badges.Badge(
              showBadge: controller.slMHGH>0,
              badgeContent: Text('${controller.slMHGH}', style: TextStyle(color: Colors.white),),
              child: Icon(Icons.shopping_cart),
            ),),
          SizedBox(width: 20,)
        ],
      ),
      drawer: Drawer(
        child: Obx(() {
          final authController = Get.find<AuthController>();
          final user = authController.user.value;
          return ListView(
            children: [
              if (user != null)
                UserAccountsDrawerHeader(
                  accountEmail: Text(user.email ?? 'không tìm thấy email người dùng'), accountName: null,
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BuildButton(context, title: "Đăng nhập", destination: PageStoreLogin()),
                ),
              if (user != null)
                BuildButton(context, title: "Thông tin", destination: PageThongTinKH()),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Đăng xuất'),
                  onTap: () async {
                    await authController.signOut();
                  },
                ),

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
                                  child: Image.network(product.anh?? ""),
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
