import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
      appBar: AppBar(title: const Text("Cá nhân hóa")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            item("Dark Mode"),
            item("Ghi chú"),
            item("Bản đồ nhà thuốc"),
          ],
        ),
      ),
    );
  }
}