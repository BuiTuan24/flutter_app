import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MedicationListScreen extends StatefulWidget {
  @override
  _MedicationListScreenState createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  List medications = [];
  bool isLoading = true;

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

  void showEditDialog(dynamic item) {
    final nameController = TextEditingController(text: item['name']);
    final dosageController = TextEditingController(text: item['dosage']);
    final noteController = TextEditingController(text: item['note'] ?? '');
    List<String> times =
    (item['times'] is List)
        ? List<String>.from(item['times'])
        : (item['times'] ?? '').toString().split(',');

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text("Sửa thuốc"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Tên thuốc"),
                    ),
                    TextField(
                      controller: dosageController,
                      decoration: InputDecoration(labelText: "Liều lượng"),
                    ),
                    TextField(
                      controller: noteController,
                      decoration: InputDecoration(labelText: "Ghi chú"),
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Giờ uống"),
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? picked = await showTimePicker(
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
                          child: Text("+"),
                        )
                      ],
                    ),

                    Wrap(
                      spacing: 8,
                      children: times.map((t) {
                        return Chip(
                          label: Text(t),
                          deleteIcon: Icon(Icons.close),
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
                  child: Text("Hủy"),
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
                  child: Text("Lưu"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách thuốc")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : medications.isEmpty
          ? Center(child: Text("Chưa có thuốc nào"))
          : ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final item = medications[index];

          return Card(
            margin:
            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(item['name'] ?? ''),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Liều: ${item['dosage']}"),
                  Text("Giờ: ${item['times']}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => showEditDialog(item),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        deleteMedication(item['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}