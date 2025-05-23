// import 'package:cuoiki/controllers/GioHang_Controller.dart';
// import 'package:cuoiki/controllers/Product_Controller.dart';
// import 'package:cuoiki/pages/ChiTietSp_Page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:badges/badges.dart' as badges;
// import 'package:get/get.dart';
//
// class AppStore extends StatelessWidget {
//   const AppStore({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       initialBinding: BindingsHomeProductStore(),
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
//         useMaterial3: true,
//       ),
//       home: PageHomeStore(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class PageHomeStore extends StatelessWidget {
//   const PageHomeStore({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Store"),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         actions: [
//           GetBuilder(
//             init: ControllerProduct.get(),
//             id:"gh",
//             builder: (controller) => badges.Badge(
//               showBadge: controller.slMHGH!>0,
//               badgeContent: Text('${controller.slMHGH?? 10}', style: TextStyle(color: Colors.white),),
//               child: Icon(Icons.shopping_cart),
//             ),
//           ),
//           SizedBox(width: 20,),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: [
//             UserAccountsDrawerHeader(
//               accountName: Text("data"),
//               accountEmail: Text("data"))
//           ],
//         ),
//       ),
//       body: GetBuilder(
//         init: ControllerProduct.get(),
//         id: "Products",
//         builder: (controller) {
//           var products = controller.products;
//           return GridView.extent(
//             maxCrossAxisExtent: 300,
//             mainAxisSpacing: 9,
//             crossAxisSpacing: 5,
//             childAspectRatio: 0.75,
//             children: products.map(
//               (e) {
//               return Card(
//                 child: GestureDetector(
//                   child: Column(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           child: Image.network(e.anh?? "https://ikdmkoqsurmbycuheihy.supabase.co/storage/v1/object/public/images/images/tui.jpg"),
//                         ),
//                       ),
//                       Text(e.ten),
//                       Text("${e.gia?? 0} vnd"),
//                     ],
//                   ),
//                   onTap: () => {
//                     Get.to(PageChitietProduct(product: e))
//                   },
//                 ),
//               );
//             }
//             ).toList(),
//           );
//         }),
//     );
//   }
// }