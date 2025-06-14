import 'package:cuoiki/admin/AdminViewAllOdersPage.dart';
import 'package:cuoiki/admin/Product_Admin_Page.dart';
import 'package:cuoiki/pages/HomeStoreStream_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'admin/AdminViewAllCartsPage.dart';
import 'admin/AdminViewAllUsersPage.dart';
import 'controllers/User_Controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://ikdmkoqsurmbycuheihy.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlrZG1rb3FzdXJtYnljdWhlaWh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY0MTYwMTAsImV4cCI6MjA2MTk5MjAxMH0.QcBWtPEIvW5YqNBdyNkCKX9nbuCWlhRUUFbuRVPjIkk");
  // runApp( AppStore());
  Get.put(AuthController());
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
      home: PageHome(),
    );
  }
}

Widget BuildButton(BuildContext context, {required String title, required Widget destination}) {
  return Container(
    width: MediaQuery.of(context).size.width*2/3,
    child: Container(
      child: ElevatedButton(
          onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyProfile(),));
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => destination,));
          },
          child: Text(title)),
    ),
  );
}

class PageHome extends StatelessWidget {
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My App"),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // BuildButton(context, title: "Trang chủ", destination: AppStore()),
              BuildButton(context, title: "Trang chủ Stream", destination: AppStreamStore()),
              BuildButton(context, title: "Trang chủ Admin", destination: PageProductAdmin()),
              BuildButton(context, title: "Giỏ hàng", destination: AdminViewAllCartsPage()),
              BuildButton(context, title: "Đơn hàng", destination: AdminViewAllOrdersPage()),
              BuildButton(context, title: "Khách hàng", destination: AdminViewAllUsersPage()),

            ],
          ),
        ),
      ),
    );
  }
}