import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen_model/DosageScreen.dart';
import 'package:flutter_application_1/screen_model/MedicationListScreen.dart';
class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

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
      appBar: AppBar(title: const Text("Lịch trình uống thuốc")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 👉 Thiết lập liều lượng
            ListTile(
              leading: Icon(Icons.medication),
              title: Text("Thiết lập liều lượng"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DosageScreen(),
                  ),
                );
              },
            ),

            // 👉 Quét mã vạch
            ListTile(
              leading: Icon(Icons.qr_code_scanner),
              title: Text("Quét mã vạch"),
              onTap: () {
                // TODO: mở scanner
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("Danh sách lịch nhắc"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicationListScreen(
                      selectedDate: DateTime.now(),
                      completedLogs: {},
                      onDone: (date, time) {}, onProgressChanged: (double p1) {  },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
