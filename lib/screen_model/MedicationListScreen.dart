import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MedicationListScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Map<String, List<String>> completedLogs;
  final Function(String date, String time) onDone;
  final Function(double) onProgressChanged;

  const MedicationListScreen({
    super.key,
    required this.selectedDate,
    required this.completedLogs,
    required this.onDone,
    required this.onProgressChanged,
  });

  @override
  _MedicationListScreenState createState() =>
      _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List medications = [];
  bool isLoading = true;

  // 🔥 helper xử lý times
  List<String> parseTimes(dynamic times) {
    if (times is List) return List<String>.from(times);
    return times.toString().split(',');
  }

  void calculateProgress() {
    String dateKey =
        "${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}";

    int total = 0;
    int done = 0;

    for (var item in medications) {
      List<String> times = parseTimes(item['times']);

      total += times.length;

      for (var t in times) {
        if (widget.completedLogs[dateKey]?.contains(t) ?? false) {
          done++;
        }
      }
    }

    double progress = total == 0 ? 0.0 : done / total;

    widget.onProgressChanged(progress);
  }

  @override
  void initState() {
    super.initState();
    fetchMedications();
  }

  Future<void> fetchMedications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("userId");

      if (userId == null) {
        setState(() => isLoading = false);
        return;
      }

      final res = await http.get(
        Uri.parse("http://10.0.2.2:8080/medications?userId=$userId"),
      );

      if (res.statusCode == 200) {
        setState(() {
          medications = jsonDecode(res.body);
          isLoading = false;
        });

        calculateProgress(); // 🔥 gọi sau setState
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteMedication(int id) async {
    await http.delete(
      Uri.parse("http://10.0.2.2:8080/medications/$id"),
    );

    fetchMedications();
  }

  Future<void> updateMedication(int id, Map data) async {
    await http.put(
      Uri.parse("http://10.0.2.2:8080/medications/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    fetchMedications();
  }

  @override
  Widget build(BuildContext context) {
    String dateKey =
        "${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}";

    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách thuốc")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : medications.isEmpty
          ? const Center(child: Text("Chưa có thuốc nào"))
          : Builder(
        builder: (context) {
          // 🔥 FILTER PHẢI Ở NGOÀI
          var filtered = medications.where((item) {
            List<String> times = parseTimes(item['times']);
            String time = times[0];

            return !(widget.completedLogs[dateKey]?.contains(time) ?? false);
          }).toList();

          // 🔥 nếu hết thuốc
          if (filtered.isEmpty) {
            return const Center(
              child: Text("Hôm nay đã uống hết thuốc 🎉"),
            );
          }

          return ListView.builder(
            itemCount: filtered.length, // 🔥 QUAN TRỌNG
            itemBuilder: (context, index) {
              final item = filtered[index];

              List<String> times = parseTimes(item['times']);
              String time = times[0];

              bool isDone =
                  widget.completedLogs[dateKey]?.contains(time) ?? false;

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    item['name'] ?? '',
                    style: TextStyle(
                      decoration:
                      isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Liều: ${item['dosage']}"),
                      Text("Giờ: ${times.join(', ')}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✔ HOÀN THÀNH
                      IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          color: isDone ? Colors.green : Colors.grey,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Xác nhận"),
                              content: const Text("Bạn đã uống thuốc này chưa?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Hủy"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);

                                    widget.onDone(dateKey, time);

                                    Future.delayed(
                                        const Duration(milliseconds: 50), () {
                                      calculateProgress();
                                    });
                                  },
                                  child: const Text("Xong"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // ✏️ SỬA
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => showEditDialog(item),
                      ),

                      // 🗑️ XÓA
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteMedication(item['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showEditDialog(dynamic item) {
    final nameController = TextEditingController(text: item['name']);
    final dosageController =
    TextEditingController(text: item['dosage']);
    final noteController =
    TextEditingController(text: item['note'] ?? '');

    List<String> times = parseTimes(item['times']);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Sửa thuốc"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration:
                      const InputDecoration(labelText: "Tên thuốc"),
                    ),
                    TextField(
                      controller: dosageController,
                      decoration: const InputDecoration(
                          labelText: "Liều lượng"),
                    ),
                    TextField(
                      controller: noteController,
                      decoration:
                      const InputDecoration(labelText: "Ghi chú"),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Giờ uống"),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? picked =
                            await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (picked != null) {
                              final time =
                                  "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";

                              setStateDialog(() {
                                times.add(time);
                              });
                            }
                          },
                          child: const Text("+"),
                        )
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      children: times.map((t) {
                        return Chip(
                          label: Text(t),
                          deleteIcon: const Icon(Icons.close),
                          onDeleted: () {
                            setStateDialog(() {
                              times.remove(t);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Hủy"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await updateMedication(item['id'], {
                      "name": nameController.text,
                      "dosage": dosageController.text,
                      "note": noteController.text,
                      "frequency": item['frequency'],
                      "times": times,
                      "userId": item['userId'],
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Lưu"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}