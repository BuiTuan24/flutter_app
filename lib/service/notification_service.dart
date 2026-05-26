import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  static final FlutterLocalNotificationsPlugin
  notifications =
  FlutterLocalNotificationsPlugin();

  // 🚀 INIT
  static Future<void> init() async {

    const AndroidInitializationSettings android =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings settings =
    InitializationSettings(
      android: android,
    );

// 🔔 xin quyền notification
    await notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
// 🌏 timezone VN
    tz.initializeTimeZones();

    tz.setLocalLocation(
      tz.getLocation('Asia/Ho_Chi_Minh'),
    );

    await notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {

        if (response.actionId == 'stop') {
          await notifications.cancelAll();
          print("Đã tắt alarm loop");
        }
      },
    );
  }
  static Future<void> startAlarmLoop({
    required int baseId,
    required String medicineName,
    required String dosage,
  }) async {

    const int durationSeconds = 300; // 5 phút
    const int intervalSeconds = 10;

    final int count = (durationSeconds / intervalSeconds).ceil();

    for (int i = 0; i < count; i++) {

      await Future.wait(
        List.generate(count, (i) {
          return notifications.zonedSchedule(
            baseId + i,
            "💊 Đến giờ uống thuốc",
            "$medicineName - $dosage (bấm Tắt để dừng)",

            tz.TZDateTime.now(tz.local)
                .add(Duration(seconds: i * intervalSeconds)),

            const NotificationDetails(
              android: AndroidNotificationDetails(
                'medicine_channel',
                'Medicine Reminder',
                channelDescription: 'Alarm thuốc',
                importance: Importance.max,
                priority: Priority.high,
                playSound: true,
                enableVibration: true,
              ),
            ),

            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
          );
        }),
      );
    }

    print("Đã tạo alarm loop: $count lần");
  }
  // ⏰ Schedule thuốc
  static Future<void> scheduleMedicineNotification({

    required int id,
    required String medicineName,
    required String dosage,
    required String time,

  }) async {

    // ví dụ: 08:30
    final parts = time.split(":");

    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);

    await notifications.zonedSchedule(
      id,
      "💊 Đến giờ uống thuốc",
      "$medicineName - $dosage",
      _nextInstance(hour, minute),

      NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminder',
          channelDescription: 'Thông báo nhắc uống thuốc',

          importance: Importance.max,
          priority: Priority.high,

          playSound: true,
          enableVibration: true,

          // ⭐ QUAN TRỌNG: bật full screen (giống alarm)
          fullScreenIntent: true,

          // ⭐ NÚT ACTION
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction(
              'stop',   // actionId
              'Tắt',     // text hiển thị
            ),
          ],
        ),
      ),

      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,

      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  // 📅 giờ tiếp theo
  static tz.TZDateTime _nextInstance(
      int hour,
      int minute,
      ) {

    final tz.TZDateTime now =
    tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduled =
    tz.TZDateTime(

      tz.local,

      now.year,
      now.month,
      now.day,

      hour,
      minute,
    );

    // nếu giờ đã qua → +1 ngày
    if (scheduled.isBefore(now)) {

      scheduled = scheduled.add(
        const Duration(days: 1),
      );
    }

    print("NOW: $now");
    print("SCHEDULED: $scheduled");

    return scheduled;
  }

  // ❌ huỷ toàn bộ
  static Future<void> stopAlarmLoop(int baseId) async {
    for (int i = 0; i < 60; i++) {
      await notifications.cancel(baseId + i);
    }
  }
}