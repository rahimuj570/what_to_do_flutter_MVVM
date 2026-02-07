import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // This will fire even if the app is terminated
  // debugPrint(
  //   'Background NotificationResponse: ${response.actionId} and ${response.id}',
  // );
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> initialize() async {
    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Combined initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // debugPrint('Foreground NotificationResponse: ${response.actionId}');

        // if (response.actionId == 'id_view') {
        //   debugPrint('View clicked');
        //   debugPrint(response.id.toString());
        // } else if (response.actionId == 'id_complete') {
        //   debugPrint('Complete clicked');
        // } else if (response.actionId == 'id_cancel') {
        //   debugPrint('Cancel clicked');
        // } else {
        //   debugPrint('Notification body tapped');
        // }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _notificationsPlugin.periodicallyShow(
      id: 0,
      title: 'Stay on Track',
      body: 'You might have something to do today — check your tasks.',
      repeatInterval: RepeatInterval.daily,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_notify',
          'daily_notify_channel',
          channelDescription: 'This is the daily notification channel',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          actions: [AndroidNotificationAction('id_view', 'title')],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Show a simple notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required int deadline,
  }) async {
    final TimezoneInfo currentTimeZone =
        await FlutterTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    // Android notification details
    const AndroidNotificationDetails
    androidDetails = AndroidNotificationDetails(
      'shedule_notify',
      'shedule_notify_channel',
      channelDescription:
          'This is the shedule notification channel which will trigger before 30min of deadline',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,

      // actions: <AndroidNotificationAction>[
      //   AndroidNotificationAction('id_view', 'View'),
      //   AndroidNotificationAction('id_complete', 'Complete'),
      //   AndroidNotificationAction('id_cancel', 'Cancel'),
      // ],
    );

    // Combined notification details
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );
    // Show the notification
    await _notificationsPlugin.zonedSchedule(
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      scheduledDate: tz.TZDateTime.fromMillisecondsSinceEpoch(
        tz.local,
        deadline,
      ),
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  // Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
