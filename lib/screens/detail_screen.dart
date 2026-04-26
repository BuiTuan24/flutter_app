// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Bloc_auth/auth_bloc.dart';
// import 'package:flutter_application_1/Bloc_auth/auth_event.dart' show LogoutEvent;
// import 'package:flutter_application_1/screens/change_password.dart';
// import 'package:flutter_application_1/screens/login_page.dart';
// import 'package:flutter_application_1/screens/support_page.dart';
// import 'package:http/http.dart' as http;
// import 'ReminderScreen.dart';
// import 'SafetyScreen.dart';
// import 'ScheduleScreen.dart';
// import 'SettingsScreen.dart';
// import 'TrackingScreen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// class DetailScreen extends StatefulWidget {
//   const DetailScreen({super.key});
//
//   @override
//   State<DetailScreen> createState() => _DetailScreenState();
// }
//
// class _DetailScreenState extends State<DetailScreen> {
//   String userName = "Loading...";
//
//   @override
//   void initState() {
//     super.initState();
//     loadUser();
//   }
//
//   Future<String> fetchUserName(String email) async {
//     final res = await http.get(
//       Uri.parse('http://10.0.2.2:8080/api/auth/me?email=$email'),
//     );
//
//     if (res.statusCode == 200) {
//       return res.body.replaceAll('"', '');
//     } else {
//       throw Exception("Lỗi lấy tên");
//     }
//   }
//   Future<void> deleteAccount() async {
//   showDialog(
//     context: context,
//     builder: (_) => AlertDialog(
//       title: Text("Xóa tài khoản"),
//       content: Text("Hành động này không thể hoàn tác!"),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text("Hủy"),
//         ),
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//
//             // demo trước
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text("Đã xóa tài khoản (demo)")),
//             );
//
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (_) => LoginPage()),
//               (route) => false,
//             );
//           },
//           child: Text("Xóa"),
//         ),
//       ],
//     ),
//   );
// }
//   void loadUser() async {
//     String email = "tuan@gmail.com"; // 🔥 sau này thay bằng email từ login
//
//     try {
//       final name = await fetchUserName(email);
//       setState(() {
//         userName = name;
//       });
//     } catch (e) {
//       setState(() {
//         userName = "User";
//       });
//     }
//   }
//
//   Widget buildButton(BuildContext context, String title, Widget screen) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           minimumSize: const Size(double.infinity, 60),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => screen),
//           );
//         },
//         child: Text(title, style: const TextStyle(fontSize: 16)),
//       ),
//     );
//   }
//
//   void showMenu() {
//   showModalBottomSheet(
//     context: context,
//     builder: (_) {
//       return Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             title: Text("Đổi mật khẩu"),
//             onTap: () {
//               Navigator.pop(context); // đóng sheet
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => ChangePasswordPage()),
//               );
//             },
//           ),
//           ListTile(title: Text("Version 13.10.2.0.2")),
//           ListTile(
//             title: Text("Xóa tài khoản"),
//             onTap: () async {
//               Navigator.pop(context);
//               await deleteAccount();
//             },
//           ),
//           ListTile(
//             title: Text("Trợ giúp & hỗ trợ"),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => SupportPage()),
//               );
//             },
//           ),
//           ListTile(
//             title: Text("Đăng xuất"),
//             onTap: () {
//               Navigator.pop(context);
//
//               // TODO: sau này clear token ở đây
//
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (_) => LoginPage()),
//                 (route) => false,
//               );
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Nhắc thuốc"),
//         centerTitle: true,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: GestureDetector(
//               onTap: showMenu,
//               child: CircleAvatar(
//                 backgroundColor: Colors.blue,
//                 child: Text(
//                   userName.isNotEmpty ? userName[0].toUpperCase() : "?",
//                   style: const TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // 👇 lời chào
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Xin chào, $userName 👋",
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             buildButton(context, "Quản lý lịch trình uống thuốc", const ScheduleScreen()),
//             buildButton(context, "Thông báo & nhắc nhở", const ReminderScreen()),
//             buildButton(context, "Theo dõi & báo cáo", const TrackingScreen()),
//             buildButton(context, "Kết nối & an toàn", const SafetyScreen()),
//             buildButton(context, "Cá nhân hóa & trải nghiệm", const SettingsScreen()),
//           ],
//         ),
//       ),
//     );
//   }
// }
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