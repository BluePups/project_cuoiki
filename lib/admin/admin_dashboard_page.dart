import 'package:cuoiki/admin/Product_Admin_Page.dart'; // Đảm bảo đường dẫn này đúng đến file PageProductAdmin của bạn
// Nếu PageProductAdmin nằm cùng thư mục admin thì có thể là:
// Import các page admin khác sẽ tạo sau (tạm thời comment lại)
import 'package:cuoiki/admin/AdminViewAllCartsPage.dart';
import 'package:cuoiki/admin/AdminViewAllOrdersPage.dart';
import 'package:cuoiki/admin/AdminViewAllUsersPage.dart';
import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PageProductAdmin()), // Sử dụng PageProductAdmin bạn đã có
                  );
                },
                child: const Text("Quản lý Sản phẩm"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminViewAllCartsPage()),
                  );
                },
                child: const Text("Xem Giỏ Hàng Users"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminViewAllOrdersPage()),
                  );
                },
                child: const Text("Xem Đơn Hàng Users"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Tạm thời hiển thị SnackBar, sau này sẽ điều hướng
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => const AdminViewAllUsersPage()),
                   );
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Chức năng Xem Danh Sách Khách Hàng"))
                  );
                },
                child: const Text("Xem Danh Sách Khách Hàng"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}