import 'package:cuoiki/main.dart';
import 'package:cuoiki/models/User_Model.dart';
import 'package:cuoiki/pages/HomeStoreStream_Page.dart';
import 'package:cuoiki/pages/SettingUser_Page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';


AuthResponse? response;

class PageStoreLogin extends StatelessWidget {
  const PageStoreLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng nhập"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: Container()),
              SupaEmailAuth(
                onSignInComplete: (res) {
                  response = res;
                  Navigator.of(context).pop();
                },
                onSignUpComplete: (response) {
                  if (response.user != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            PageVerifyOTP(email: response.user!.email!),
                      ),
                    );
                  }
                },
                showConfirmPasswordField: true,
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}

class PageVerifyOTP extends StatelessWidget {
  PageVerifyOTP({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xác thực mã OTP"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OtpTextField(
            numberOfFields: 6,
            borderColor: Color(0xFF512DA8),
            showFieldAsBox: true,
            onCodeChanged: (String code) {},
            onSubmit: (String verificationCode) async {
              final response = await Supabase.instance.client.auth.verifyOTP(
                email: email,
                token: verificationCode,
                type: OtpType.email,
              );

              final user = response.user;

              if (response.session != null && response.user != null) {
                final uuid = user?.id;

                await Supabase.instance.client.from("KhachHang").insert({
                  "id": uuid,
                  "tenKH": "",
                  "soDienThoai": "",
                  "diaChi": ""
                });

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => PageThongTinKH()),
                      (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Xác thực thất bại. Vui lòng thử lại.")),
                );
              }
            },
          ),
          SizedBox(height: 50),
          ElevatedButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Đang gửi mã OTP..."), duration: Duration(seconds: 6)),
              );

              final response = await Supabase.instance.client.auth.signInWithOtp(
                email: email,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Mã OTP đã gửi vào $email của bạn"), duration: Duration(seconds: 3)),
              );
            },
            child: Text("Gửi lại mã OTP"),
          ),
        ],
      ),
    );
  }
}

class PageThongTinKH extends StatefulWidget {
  const PageThongTinKH({super.key});

  @override
  State<PageThongTinKH> createState() => _PageThongTinKHState();
}

class _PageThongTinKHState extends State<PageThongTinKH> {
  KhachHang? khachHang;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchKhachHang();
  }

  Future<void> fetchKhachHang() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final data = await KhachHangSnapShot.getById(user.id);
      setState(() {
        khachHang = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thông Tin Khách Hàng"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : khachHang == null
          ? Center(child: Text("Không tìm thấy thông tin khách hàng."))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person, size: 50, color: Colors.blue),
            ),
            SizedBox(height: 16),
            Text(
              khachHang!.tenKH.isNotEmpty
                  ? khachHang!.tenKH
                  : "Chưa có tên",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Divider(thickness: 1),
            SizedBox(height: 16),
            _buildInfoCard("ID khách hàng", khachHang!.id),
            _buildInfoCard("Số điện thoại",
                khachHang!.soDienThoai.isEmpty ? "Chưa cập nhật" : khachHang!.soDienThoai),
            _buildInfoCard("Địa chỉ",
                khachHang!.diaChi.isEmpty ? "Chưa cập nhật" : khachHang!.diaChi),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        PageUserUpdate(khachHang: khachHang!)));
              },
              icon: Icon(Icons.edit),
              label: Text("Cập nhật thông tin"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => PageHomeStream()),
                        (route) => false);
              },
              icon: Icon(Icons.home),
              label: Text("Quay lại trang chủ để mua hàng"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12),
                side: BorderSide(color: Colors.blue),
                textStyle: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(
          _getIconForLabel(label),
          color: Colors.blue,
        ),
        title: Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(value, style: TextStyle(fontSize: 15)),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case "ID khách hàng":
        return Icons.perm_identity;
      case "Số điện thoại":
        return Icons.phone;
      case "Địa chỉ":
        return Icons.home;
      default:
        return Icons.info;
    }
  }
}


