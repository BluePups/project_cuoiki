import 'package:cuoiki/controllers/GioHang_Controller.dart';
import 'package:cuoiki/models/GioHang_Model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class PageGioHang extends StatelessWidget {
  PageGioHang({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageGioHangStream(),
    );
  }
}

class PageGioHangStream extends StatelessWidget {
  final currentUser = Supabase.instance.client.auth.currentUser;
  PageGioHangStream({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giỏ hàng của bạn á hẹ hẹ hẹ"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
        stream: GioHangSnapshot.getDataGioHang(currentUser!.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error: ${snapshot.error}");
            return Center(child: Text("Lỗi: ${snapshot.error}" + "${currentUser!.id}"));
          }
          if(!snapshot.hasData) {
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
          var gioHangs = snapshot.data!;
          return GridView.extent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 0.75,
            children: gioHangs.map(
                    (gioHang) {
                  return Card(
                    child: GestureDetector(
                      child: Column(
                          children: [
                            Text("${gioHang.id}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                            Text("${gioHang.soLuong}"),
                            Text("${gioHang.id_sp}"),
                          ]
                      ),
                    ),
                  );
                }
            ).toList(),
          );
        },
      ),
    );
  }
}
