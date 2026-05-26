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
// VỀ CHÚNG TÔI
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade100, Colors.black],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.groups,
                              size: 70,
                              color: Colors.blue,
                            ),

                            SizedBox(height: 15),

                            Text(
                              "Về Chúng Tôi",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),

                            SizedBox(height: 15),

                            Text(
                              "Công Ty Cổ Phần Công Nghệ Mới Nhú là đội ngũ phát triển phần mềm với hơn 10 năm kinh nghiệm trong lĩnh vực công nghệ và ứng dụng chăm sóc sức khỏe.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),

                            SizedBox(height: 15),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Thành viên nhóm:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),

                            SizedBox(height: 10),

                            Column(
                              children: [
                                Text("• Bùi Tuấn"),
                                Text("• Trung Kiên"),
                                Text("• Duy Quang"),
                                Text("• Đình Thịnh"),
                              ],
                            ),

                            SizedBox(height: 20),

                            Text(
                              "Liên hệ: 032103213",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              "Facebook: (Tự thêm link tại đây)",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),

                            SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Đóng"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 50),
              ),
              child: Text("Về chúng tôi"),
            ),

            SizedBox(height: 15),

// GIỚI THIỆU ỨNG DỤNG
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [Colors.lightBlue.shade100, Colors.black],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.medication,
                              size: 80,
                              color: Colors.blue,
                            ),

                            SizedBox(height: 15),

                            Text(
                              "Giới Thiệu Ứng Dụng",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),

                            SizedBox(height: 20),

                            Text(
                              "Medicine Reminder là ứng dụng hỗ trợ người dùng quản lý và theo dõi lịch uống thuốc hằng ngày.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),

                            SizedBox(height: 15),

                            Text(
                              "Ứng dụng giúp:",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),

                            SizedBox(height: 10),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("✔ Nhắc nhở uống thuốc đúng giờ"),
                                Text("✔ Tạo lịch uống thuốc dễ dàng"),
                                Text("✔ Theo dõi lịch sử sử dụng thuốc"),
                                Text("✔ Giảm nguy cơ quên thuốc"),
                                Text("✔ Hỗ trợ chăm sóc sức khỏe cá nhân"),
                              ],
                            ),

                            SizedBox(height: 20),

                            Text(
                              "Mục tiêu của ứng dụng là mang đến giải pháp hỗ trợ sức khỏe tiện lợi, đơn giản và hiệu quả cho mọi người dùng.",
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Đóng"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
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