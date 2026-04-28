
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'DosageScreen.dart';

class MedicationListScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Function(double) onProgressChanged;
  int getToday() {
    return DateTime.now().weekday;
    // ⚠️ Dart: 1 = Monday, 7 = Sunday
  }
  const MedicationListScreen({
    super.key,
    required this.selectedDate,
    required this.onProgressChanged,
  });

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List medications = [];
  Map<String, List<String>> completedLogs = {};
  bool isLoading = true;
  int? userId;

  String get dateKey =>
      "${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}";

  // 🔥 parse times
  List<String> parseTimes(dynamic times) {
    if (times is List) return List<String>.from(times);
    return times.toString().replaceAll('[', '').replaceAll(']', '').split(',');
  }

  bool shouldShowMedication(dynamic med) {
    DateTime selected = widget.selectedDate;

    // 🔥 parse start / end
    DateTime? start =
    med['startDate'] != null ? DateTime.parse(med['startDate']) : null;

    DateTime? end =
    med['endDate'] != null ? DateTime.parse(med['endDate']) : null;

    // ❌ ngoài khoảng ngày
    if (start != null && selected.isBefore(start)) return false;
    if (end != null && selected.isAfter(end)) return false;

    String type = med['scheduleType'] ?? "WEEKLY";

    // 🟢 1. Theo thứ
    if (type == "WEEKLY") {
      if (med['weekdays'] == null) return true;

      List days = med['weekdays'] is String
          ? jsonDecode(med['weekdays'])
          : med['weekdays'];

      List<String> map = ["CN","T2","T3","T4","T5","T6","T7"];

      int today = selected.weekday; // 1-7 (Mon-Sun)
      return days.contains(today);
    }

    // 🟡 2. Khi cần
    if (type == "AS_NEEDED") {
      return true;
    }

    // 🔵 3. Cách ngày
    if (type == "ALTERNATE") {
      if (start == null) return true;

      int diff = selected.difference(start).inDays;
      return diff % 2 == 0;
    }

    return true;
  }

  Widget buildSection(String title, List items, bool isDoneSection) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          isDoneSection ? "" : "Hôm nay đã uống hết 🎉",
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map((e) => buildItem(e, isDoneSection)).toList(),
      ],
    );
  }

  Widget buildItem(Map e, bool isDone) {
    final med = e["med"];
    final time = e["time"];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDone ? Colors.green : Colors.blue,
          child: Icon(
            isDone ? Icons.check : Icons.access_time,
            color: Colors.white,
          ),
        ),
        title: Text(
          med['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration:
            isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text("Liều: ${med['dosage']} • $time"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            // ✅ DONE / UNDO
            IconButton(
              icon: Icon(
                isDone ? Icons.undo : Icons.check_circle,
                color: isDone ? Colors.orange : Colors.green,
              ),
              onPressed: () {
                toggleDone(med['id'], time);
              },
            ),

            // ✏️ EDIT → chuyển sang DosageScreen
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                print("MED: $med"); // 👈 thêm dòng này
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DosageScreen(existingMed: med),
                  ),
                ).then((_) {
                  fetchMedications();
                  loadLogs();
                });
              },
            ),

            // 🗑️ DELETE
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await deleteMedication(med['id']);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void didUpdateWidget(covariant MedicationListScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedDate != widget.selectedDate) {
      loadLogs(); // 🔥 đổi ngày → load lại logs
    }
  }


  Future<void> deleteMedication(int id) async {
    await http.delete(
      Uri.parse("http://10.0.2.2:8080/medications/$id"),
    );

    await fetchMedications(); // reload list
    await loadLogs(); // update progress luôn
  }

  Future<void> initData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId");

    await fetchMedications();
    await loadLogs();
  }

  Future<void> fetchMedications() async {
    final res = await http.get(
      Uri.parse("http://10.0.2.2:8080/medications?userId=$userId"),
    );

    if (res.statusCode == 200) {
      medications = jsonDecode(res.body);
    }

    setState(() => isLoading = false);
  }

  Future<void> loadLogs() async {
    final res = await http.get(
      Uri.parse(
          "http://10.0.2.2:8080/logs?userId=$userId&date=$dateKey"),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      completedLogs[dateKey] = [];

      for (var log in data) {
        if (log['done'] == true || log['isDone'] == true) {
          completedLogs[dateKey]!.add(log['time']);
        }
      }
    }

    calculateProgress();
    setState(() {});
  }

  void calculateProgress() {
    int total = 0;
    int done = 0;

    for (var med in medications) {

      List<String> times = parseTimes(med['times']);

      for (var t in times) {
        total++;
        if (completedLogs[dateKey]?.contains(t.trim()) ?? false) {
          done++;
        }
      }
    }

    double progress = total == 0 ? 0 : done / total;
    widget.onProgressChanged(progress);
  }

  Future<void> toggleDone(int medId, String time) async {
    // 🔥 update UI ngay
    completedLogs.putIfAbsent(dateKey, () => []);

    if (completedLogs[dateKey]!.contains(time)) {
      completedLogs[dateKey]!.remove(time);
    } else {
      completedLogs[dateKey]!.add(time);
    }

    calculateProgress();
    setState(() {});

    // 🔥 call API
    await http.post(
      Uri.parse("http://10.0.2.2:8080/logs"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "medicationId": medId,
        "userId": userId,
        "date": dateKey,
        "time": time,
        "done": completedLogs[dateKey]!.contains(time),
      }),
    );
    await loadLogs();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (medications.isEmpty) {
      return const Center(child: Text("Chưa có thuốc nào"));
    }

    List pending = [];
    List done = [];

    for (var med in medications) {
      if (!shouldShowMedication(med)) continue;
      List<String> times = parseTimes(med['times']);

      for (var t in times) {
        bool isDone =
            completedLogs[dateKey]?.contains(t.trim()) ?? false;

        var item = {
          "med": med,
          "time": t.trim(),
        };

        if (isDone) {
          done.add(item);
        } else {
          pending.add(item);
        }
      }
    }

    return ListView(
      children: [
        buildSection("💊 Chưa uống", pending, false),
        buildSection("✅ Đã uống", done, true),
      ],
    );
  }
}