
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DosageScreen extends StatefulWidget {
  final dynamic existingMed;

  const DosageScreen({super.key, this.existingMed});

  @override
  State<DosageScreen> createState() => _DosageScreenState();
}

class _DosageScreenState extends State<DosageScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  List<TimeOfDay> times = [];

  // 🔥 NEW
  String scheduleType = "WEEKLY";
  List<String> selectedDays = [];
  DateTime? startDate;
  DateTime? endDate;

  final List<String> allDays = ["T2","T3","T4","T5","T6","T7","CN"];

  @override
  void initState() {
    super.initState();
    if (widget.existingMed != null) {
      loadExisting();
    }
  }


  void loadExisting() {
    final med = widget.existingMed;

    nameController.text = med['name'] ?? "";
    dosageController.text = med['dosage'] ?? "";
    noteController.text = med['note'] ?? "";

    scheduleType = med['scheduleType'] ?? "WEEKLY";

    // weekdays
    if (med['weekdays'] != null) {
      if (med['weekdays'] is String) {
        selectedDays = convertDaysBack(jsonDecode(med['weekdays']));
      } else {
        selectedDays = convertDaysBack(med['weekdays']);
      }
    }

    // times
    if (med['times'] != null) {
      List<String> t;

      if (med['times'] is String) {
        t = List<String>.from(jsonDecode(med['times']));
      } else {
        t = List<String>.from(med['times']);
      }

      times = t.map((e) {
        final parts = e.split(":");
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }).toList();
    }

    // dates
    if (med['startDate'] != null) {
      startDate = DateTime.parse(med['startDate']);
    }
    if (med['endDate'] != null) {
      endDate = DateTime.parse(med['endDate']);
    }
  }

  void addTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        times.add(picked);
      });
    }
  }

  void removeTime(int index) {
    setState(() {
      times.removeAt(index);
    });
  }

  String formatTime(TimeOfDay t) {
    return "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
  }

  List<String> convertDaysBack(List<dynamic> days) {
    const map = {
      2: "T2",
      3: "T3",
      4: "T4",
      5: "T5",
      6: "T6",
      7: "T7",
      1: "CN",
    };

    return days.map((d) => map[d] ?? "").toList();
  }
  List<int> convertDays(List<String> days) {
    const map = {
      "T2": 2,
      "T3": 3,
      "T4": 4,
      "T5": 5,
      "T6": 6,
      "T7": 7,
      "CN": 1, // ⚠️ đổi nếu backend bạn dùng CN = 7
    };

    return days.map((d) => map[d]!).toList();
  }
  Future<void> save() async {
    if (nameController.text.isEmpty || times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nhập tên thuốc và ít nhất 1 giờ")),
      );
      return;
    }

    if (scheduleType == "WEEKLY" && selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chọn ít nhất 1 ngày trong tuần")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userId");

    print("USER ID: $userId");

    if (userId == null) return;

    final data = {
      "userId": userId,
      "name": nameController.text,
      "dosage": dosageController.text,
      "times": times.map((t) => formatTime(t)).toList(),
      "note": noteController.text,
      "scheduleType": scheduleType,
      "weekdays": convertDays(selectedDays),
    };

    if (startDate != null) {
      data["startDate"] = startDate!.toIso8601String();
    }
    if (endDate != null) {
      data["endDate"] = endDate!.toIso8601String();
    }

    final url = widget.existingMed == null
        ? "http://10.0.2.2:8080/medications"
        : "http://10.0.2.2:8080/medications/${widget.existingMed['id']}";

    final res = widget.existingMed == null
        ? await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data))
        : await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data));

    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    if (res.statusCode == 200 || res.statusCode == 201) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${res.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingMed == null
            ? "Thêm thuốc"
            : "Chỉnh sửa thuốc"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // TÊN
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Tên thuốc",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // LIỀU
              TextField(
                controller: dosageController,
                decoration: const InputDecoration(
                  labelText: "Liều lượng",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // TIME
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Giờ uống",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: addTime,
                    child: const Text("+"),
                  )
                ],
              ),

              Wrap(
                spacing: 8,
                children: List.generate(times.length, (i) {
                  return Chip(
                    label: Text(formatTime(times[i])),
                    onDeleted: () => removeTime(i),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // SCHEDULE TYPE
              const Text("Lịch uống",
                  style: TextStyle(fontWeight: FontWeight.bold)),

              RadioListTile(
                title: const Text("Theo thứ"),
                value: "WEEKLY",
                groupValue: scheduleType,
                onChanged: (v) => setState(() => scheduleType = v!),
              ),
              RadioListTile(
                title: const Text("Khi cần"),
                value: "AS_NEEDED",
                groupValue: scheduleType,
                onChanged: (v) => setState(() => scheduleType = v!),
              ),
              RadioListTile(
                title: const Text("Cách ngày"),
                value: "ALTERNATE",
                groupValue: scheduleType,
                onChanged: (v) => setState(() => scheduleType = v!),
              ),

              // WEEKDAYS
              if (scheduleType == "WEEKLY") ...[
                Wrap(
                  spacing: 8,
                  children: allDays.map((day) {
                    final selected = selectedDays.contains(day);

                    return ChoiceChip(
                      label: Text(day),
                      selected: selected,
                      selectedColor: Colors.blue,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            selectedDays.add(day);
                          } else {
                            selectedDays.remove(day);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 16),

              // DATE RANGE
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setState(() => startDate = picked);
                        }
                      },
                      child: Text(startDate == null
                          ? "Bắt đầu"
                          : startDate.toString().split(" ")[0]),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (picked != null) {
                          setState(() => endDate = picked);
                        }
                      },
                      child: Text(endDate == null
                          ? "Kết thúc"
                          : endDate.toString().split(" ")[0]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // NOTE
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Ghi chú",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              // SAVE
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: save,
                  child: const Text("Lưu"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}