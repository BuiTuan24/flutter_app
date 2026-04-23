// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// class DosageScreen extends StatefulWidget {
//   @override
//   _DosageScreenState createState() => _DosageScreenState();
// }
//
// class _DosageScreenState extends State<DosageScreen> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController dosageController = TextEditingController();
//   final TextEditingController noteController = TextEditingController();
//
//   List<TimeOfDay> times = [];
//   String frequency = "daily";
//
//   void addTime() async {
//     TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//
//     if (picked != null) {
//       setState(() {
//         times.add(picked);
//       });
//     }
//   }
//
//   void removeTime(int index) {
//     setState(() {
//       times.removeAt(index);
//     });
//   }
//
//   String formatTime(TimeOfDay t) {
//     return t.hour.toString().padLeft(2, '0') +
//         ":" +
//         t.minute.toString().padLeft(2, '0');
//   }
//
//   void save() async {
//     if (nameController.text.isEmpty || times.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Nhập tên thuốc và ít nhất 1 giờ")),
//       );
//       return;
//     }
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? userId = prefs.getInt("userId");
//
//     if (userId == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Chưa đăng nhập")),
//       );
//       return;
//     }
//
//     final response = await http.post(
//       Uri.parse("http://localhost:8080/medications"),
//       headers: {
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode({
//         "userId": userId,
//         "name": nameController.text,
//         "dosage": dosageController.text,
//         "times": times.map((t) => formatTime(t)).toList(),
//         "frequency": frequency,
//         "note": noteController.text,
//       }),
//     );
//
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Đã lưu")),
//       );
//
//       setState(() {
//         nameController.clear();
//         dosageController.clear();
//         noteController.clear();
//         times.clear();
//         frequency = "daily";
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Lỗi khi lưu")),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     nameController.dispose();
//     dosageController.dispose();
//     noteController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Thiết lập liều lượng")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               // 🟢 Tên thuốc
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   labelText: "Tên thuốc",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 12),
//
//               // 🟢 Liều lượng
//               TextField(
//                 controller: dosageController,
//                 decoration: InputDecoration(
//                   labelText: "Liều lượng (vd: 1 viên)",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 16),
//
//               // 🟢 Thời điểm uống
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Thời điểm uống",
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                   ElevatedButton(
//                     onPressed: addTime,
//                     child: Text("+ Thêm giờ"),
//                   )
//                 ],
//               ),
//
//               SizedBox(height: 8),
//
//               Wrap(
//                 spacing: 8,
//                 children: List.generate(times.length, (index) {
//                   return Chip(
//                     label: Text(formatTime(times[index])),
//                     deleteIcon: Icon(Icons.close),
//                     onDeleted: () => removeTime(index),
//                   );
//                 }),
//               ),
//
//               SizedBox(height: 16),
//
//               // 🟢 Tần suất
//               DropdownButtonFormField<String>(
//                 value: frequency,
//                 decoration: InputDecoration(
//                   labelText: "Tần suất",
//                   border: OutlineInputBorder(),
//                 ),
//                 items: [
//                   DropdownMenuItem(value: "daily", child: Text("Mỗi ngày")),
//                   DropdownMenuItem(value: "alternate", child: Text("Cách ngày")),
//                   DropdownMenuItem(value: "weekly", child: Text("Mỗi tuần")),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     frequency = value!;
//                   });
//                 },
//               ),
//
//               SizedBox(height: 16),
//
//               // 🟢 Ghi chú
//               TextField(
//                 controller: noteController,
//                 maxLines: 3,
//                 decoration: InputDecoration(
//                   labelText: "Ghi chú",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//
//               SizedBox(height: 20),
//
//               // 🟢 Nút lưu
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: save,
//                   child: Text("Lưu"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DosageScreen extends StatefulWidget {
  @override
  _DosageScreenState createState() => _DosageScreenState();
}

class _DosageScreenState extends State<DosageScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  List<TimeOfDay> times = [];
  String frequency = "daily";

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
    return t.hour.toString().padLeft(2, '0') +
        ":" +
        t.minute.toString().padLeft(2, '0');
  }

  // 🔥 CHỈ SỬA HÀM NÀY
  void save() async {
    if (nameController.text.isEmpty || times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nhập tên thuốc và ít nhất 1 giờ")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("userId");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chưa đăng nhập")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2:8080/medications"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "userId": userId,
          "name": nameController.text,
          "dosage": dosageController.text,
          "times": times.map((t) => formatTime(t)).toList(),
          "frequency": frequency,
          "note": noteController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đã lưu")),
        );

        // reset form
        setState(() {
          nameController.clear();
          dosageController.clear();
          noteController.clear();
          times.clear();
          frequency = "daily";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi khi lưu")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không kết nối được server")),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thiết lập liều lượng")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🟢 Tên thuốc
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Tên thuốc",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),

              // 🟢 Liều lượng
              TextField(
                controller: dosageController,
                decoration: InputDecoration(
                  labelText: "Liều lượng (vd: 1 viên)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // 🟢 Thời điểm uống
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Thời điểm uống",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: addTime,
                    child: Text("+ Thêm giờ"),
                  )
                ],
              ),

              SizedBox(height: 8),

              Wrap(
                spacing: 8,
                children: List.generate(times.length, (index) {
                  return Chip(
                    label: Text(formatTime(times[index])),
                    deleteIcon: Icon(Icons.close),
                    onDeleted: () => removeTime(index),
                  );
                }),
              ),

              SizedBox(height: 16),

              // 🟢 Tần suất
              DropdownButtonFormField<String>(
                value: frequency,
                decoration: InputDecoration(
                  labelText: "Tần suất",
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: "daily", child: Text("Mỗi ngày")),
                  DropdownMenuItem(value: "alternate", child: Text("Cách ngày")),
                  DropdownMenuItem(value: "weekly", child: Text("Mỗi tuần")),
                ],
                onChanged: (value) {
                  setState(() {
                    frequency = value!;
                  });
                },
              ),

              SizedBox(height: 16),

              // 🟢 Ghi chú
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Ghi chú",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              // 🟢 Nút lưu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: save,
                  child: Text("Lưu"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}