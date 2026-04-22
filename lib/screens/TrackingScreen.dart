import 'package:flutter/material.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  Widget item(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Theo dõi & báo cáo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            item("Nhật ký uống thuốc"),
            item("Xuất báo cáo PDF/Excel"),
            item("Theo dõi chỉ số sức khỏe"),
          ],
        ),
      ),
    );
  }
}