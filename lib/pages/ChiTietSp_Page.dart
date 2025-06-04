import 'dart:math';
import 'package:cuoiki/controllers/Product_Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:badges/badges.dart' as badges;
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../models/Product_Model.dart';
import 'GioHang_Page.dart';
import 'User_Page.dart';

class PageChitietProduct extends StatelessWidget {
  PageChitietProduct({super.key, required this.product});
  Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${product.ten}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // actions: [
        //   GetBuilder(
        //     init: ControllerProduct.get(),
        //     id: "gh",
        //     builder: (controller) => GestureDetector(
        //       onTap: () {
        //         final currentUser = Supabase.instance.client.auth.currentUser;
        //         if(currentUser != null) {
        //           Get.to(() => PageGioHang());
        //         }
        //         else
        //           Get.to(() => PageStoreLogin());
        //       },
        //       child: badges.Badge(
        //         showBadge: controller.slMHGH.value > 0,
        //         badgeContent: Text('${controller.slMHGH.value}', style: TextStyle(color: Colors.white,
        //           fontSize: 14,
        //           fontWeight: FontWeight.bold,)),
        //         child: Icon(Icons.shopping_cart),
        //       ),
        //     ),
        //   ),
        //   SizedBox(width: 20,)
        // ],
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
          SizedBox(width: 20),
        ],

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size  .width*0.95,
                  child: Image.network(product.anh?? "https://ikdmkoqsurmbycuheihy.supabase.co/storage/v1/object/public/images/images/tui.jpg"),
                ),
              ),
              Text(product.ten, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              Column(
                children: [
                  Row(
                    children: [
                      Text("${product.gia?? 0} vnd", style: TextStyle(color: Colors.red),),
                      SizedBox(width: 30,),
                      Text("${(product.gia?? 0)*1.2} vnd", style: TextStyle(decoration: TextDecoration.lineThrough),)
                    ],
                  ),
                ],
              ),
              Text("${product.moTa?? ""}", style: TextStyle(fontSize: 18),),
              SizedBox(height: 10,),
              Row(
                children: [
                  RatingBarIndicator(
                    rating: 4.75,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 30.0,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(height: 10, width: 20,),
                  Text("4,75", style: TextStyle(color: Colors.red),),
                  SizedBox(height: 10, width: 20,),
                  Text("${1 + Random().nextInt(1000)} đánh giá"),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final currentUser = Supabase.instance.client.auth.currentUser;
          if(currentUser != null) {
            // ControllerProduct.get().themMHGH(product, currentUser.id);
            // print("id là: " + response!.user!.id.toString());
            final controller = ControllerProduct.get();
            await controller.themMHGH(product, currentUser.id);
            // ✅ Tăng số lượng hiện tại lên 1
            controller.slMHGH.value += 1;
            controller.update(["gh"]); // cập nhật giao diện badge
          }
          else
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PageStoreLogin(),)
            );
        },
        child: Icon(Icons.add_shopping_cart_outlined),
      ),
    );
  }
}

double getRating() {
  return Random().nextInt(201)/100 + 3;
}
