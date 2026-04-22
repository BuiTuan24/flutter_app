import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hỗ trợ")),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.smart_toy),
            title: Text("Hỗ trợ AI"),
            subtitle: Text("Chat với AI để được trợ giúp nhanh"),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.support_agent),
            title: Text("Hỗ trợ trực tiếp"),
            subtitle: Text("Liên hệ nhân viên hỗ trợ"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}