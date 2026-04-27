
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen_model/MedicationListScreen.dart';
import 'package:flutter_application_1/screen_model/profile_screen.dart';

import '../screen_model/DosageScreen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double currentProgress = 0.0;
  Key listKey = UniqueKey();
  int getTotalTimes(List medications) {
    int total = 0;

    for (var item in medications) {
      if (item['times'] is List) {
        total += (item['times'] as List).length;
      }
    }

    return total;
  }

  int getDoneTimes(String dateKey) {
    return completedLogs[dateKey]?.length ?? 0;
  }

  double getProgress(String dateKey, List medications) {
    int total = getTotalTimes(medications);
    int done = getDoneTimes(dateKey);

    if (total == 0) return 0.0;

    return done / total;
  }

  DateTime selectedDate = DateTime.now();

  void updateProgress(double value) {
    setState(() {
      currentProgress = value;
    });
  }

  int currentIndex = 0; // 0: nhắc nhở, 1: hồ sơ
  Map<String, List<String>> completedLogs = {};
  void markAsDone(String date, String time) {
    setState(() {
      completedLogs.putIfAbsent(date, () => []);

      if (completedLogs[date]!.contains(time)) {
        completedLogs[date]!.remove(time); // bỏ tick
      } else {
        completedLogs[date]!.add(time); // tick
      }
    });
  }

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: pickDate,
            child: Row(
              children: [
                Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.arrow_drop_down)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWeekBar() {
    DateTime today = DateTime.now();

    List<String> weekdays = [
      "CN", "T2", "T3", "T4", "T5", "T6", "T7"
    ];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          DateTime day = today.add(Duration(days: index));

          bool isSelected =
              day.day == selectedDate.day &&
                  day.month == selectedDate.month;

          bool isToday = index == 0;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = day;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  // 👇 THỨ + HÔM NAY
                  Text(
                    weekdays[day.weekday % 7],
                    style: const TextStyle(fontSize: 12),
                  ),

                  if (isToday)
                    const Text(
                      "Hôm nay",
                      style: TextStyle(fontSize: 10, color: Colors.blue),
                    ),

                  const SizedBox(height: 4),

                  // 👇 VÒNG TRÒN + PROGRESS
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: CircularProgressIndicator(
                          value: currentProgress,
                          strokeWidth: 4,
                          backgroundColor: Colors.grey.shade300,
                          valueColor:
                          const AlwaysStoppedAnimation(Colors.blue),
                        ),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isSelected
                            ? Colors.blue
                            : isToday
                            ? Colors.blue.shade100
                            : Colors.grey.shade200,
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                            color:
                            isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Thêm thuốc"),
                  onTap: () {
                    Navigator.pop(context); // đóng menu trước

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DosageScreen()),
                    ).then((_) {
                      setState((){
                        listKey = UniqueKey();
                      }); // reload lại list
                    });
                  },
                ),

                const ListTile(title: Text("Quét mã")),
                const ListTile(title: Text("Tùy chọn khác")),
              ],
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget buildBottomBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => setState(() => currentIndex = 0),
            child: Text(
              "Nhắc nhở",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: currentIndex == 0 ? Colors.blue : Colors.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => currentIndex = 1),
            child: Text(
              "Hồ sơ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: currentIndex == 1 ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildReminderTab() {
    return Column(
      children: [
        buildHeader(),
        buildWeekBar(),
        const SizedBox(height: 10),
        Expanded(
          child: MedicationListScreen(
            key: listKey,
            selectedDate: selectedDate,
            completedLogs: completedLogs,
            onDone: markAsDone, onProgressChanged: (double p1) {  },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFAB(),
      body: SafeArea(
        child: currentIndex == 0
            ? buildReminderTab()
            : ProfileScreen(),
      ),
      bottomNavigationBar: buildBottomBar(),
    );
  }
}