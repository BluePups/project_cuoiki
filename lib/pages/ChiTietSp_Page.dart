import 'dart:math';
import 'package:cuoiki/controllers/Product_Controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:badges/badges.dart' as badges;
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../models/Product_Model.dart';
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
        onPressed: () {
          final currentUser = Supabase.instance.client.auth.currentUser;
          if(currentUser != null) {
            ControllerProduct.get().themMHGH(product, currentUser.id);
            print("id là: " + response!.user!.id.toString());
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
