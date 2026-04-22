import 'package:flutter/material.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

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
      appBar: AppBar(title: const Text("Kết nối & an toàn")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            item("Người giám hộ"),
            item("Tương tác thuốc"),
            item("Lưu trữ đám mây"),
          ],
        ),
      ),
    );
  }
}
