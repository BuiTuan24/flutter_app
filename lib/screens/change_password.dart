import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đổi mật khẩu")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: oldPass,
              decoration: InputDecoration(labelText: "Mật khẩu cũ"),
              obscureText: true,
            ),
            TextField(
              controller: newPass,
              decoration: InputDecoration(labelText: "Mật khẩu mới"),
              obscureText: true,
            ),
            TextField(
              controller: confirmPass,
              decoration: InputDecoration(labelText: "Nhập lại mật khẩu"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (oldPass.text.isEmpty ||
                    newPass.text.isEmpty ||
                    confirmPass.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Vui lòng nhập đầy đủ")),
                  );
                  return;
                }

                if (newPass.text != confirmPass.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Mật khẩu không khớp")),
                  );
                  return;
                }

                if (newPass.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Mật khẩu phải >= 6 ký tự")),
                  );
                  return;
                }

                // tạm thời chưa gọi API
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Đổi mật khẩu thành công (demo)")),
                );

                Navigator.pop(context);
              },
              child: Text("Xác nhận"),
            )     
          ],
        ),
      ),
    );
  }
}