import 'package:flutter/material.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

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
      appBar: AppBar(title: const Text("Thông báo & nhắc nhở")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            item("Báo thức thông minh"),
            item("Nhắc lại (Snooze)"),
            item("Xác nhận đã uống"),
            item("Cảnh báo hết thuốc"),
          ],
        ),
      ),
    );
  }
}
