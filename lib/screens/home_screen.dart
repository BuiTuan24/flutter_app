import 'package:flutter/material.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medical_services, size: 80, color: Colors.blue),
            SizedBox(height: 20),

            Text(
              "Medicine Reminder",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),
            Text(
              "Ứng dụng nhắc nhở uống thuốc đúng giờ",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),

            SizedBox(height: 40),

            // ĐĂNG NHẬP
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 50),
              ),
              child: Text("Đăng nhập tài khoản"),
            ),

            SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 50),
              ),
              child: Text("Về chúng tôi"),
            ),

            SizedBox(height: 15),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 50),
              ),
              child: Text("Giới thiệu ứng dụng"),
            ),
          ],
        ),
      ),
    );
  }
}