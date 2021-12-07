import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rxdart/rxdart.dart';
import 'package:orbit/models/task.dart';
import 'package:orbit/ui/theme.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

var localId = 0;
class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); //
  late String selectedNotificationPayload;
  late BuildContext _context;

  final Map<int?, bool> scheduledTask = {};
  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  initializeNotification(BuildContext context) async {
    _configureSelectNotificationSubject();
    _context = context;
    await _configureLocalTimeZone();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload == null) return;
      selectNotificationSubject.add(payload);
    });
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  displayNotification({required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: _context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(body ?? ""),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload ?? ""),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  scheduledNotification(Task task) {
    if (task.isCompleted == 1 || scheduledTask[task.id] == true) return;
    if (task.id != null) scheduledTask[task.id] = true;

    DateTime now = DateTime.now();

    DateTime start = DateFormat('dd/MM/yyyy HH:mm aa')
        .parse('${task.date} ${task.startTime}');
    DateTime end =
        DateFormat('dd/MM/yyyy HH:mm aa').parse('${task.date} ${task.endTime}');

    tz.TZDateTime tzStart = tz.TZDateTime(
        tz.local, start.year, start.month, start.day, start.hour, start.minute);
    tz.TZDateTime tzEnd = tz.TZDateTime(
        tz.local, end.year, end.month, end.day, end.hour, end.minute);

    tz.TZDateTime tzNow = tz.TZDateTime(
        tz.local, now.year, now.day, now.month, now.hour, now.minute);

    for (var tz in [tzStart, tzEnd]) {
      flutterLocalNotificationsPlugin.zonedSchedule(
        localId++,
        tz == tzStart
            ? 'You have incoming task at ${task.startTime}'
            : 'Your task end at ${task.endTime}',
        'Tap for more details',
        tz,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
            color: Colors.grey,
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|${task.note}|${task.startTime}|",
      );
    }
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Get.to(() => SecondScreen(payload));
    });
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen(this.payload);

  final String payload;

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  late String _payload;

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${_payload.toString().split("|")[0]}'),
      ),
      body: Container(
        height: double.maxFinite,
        child: Column(children: [
          const SizedBox(
            height: 40,
          ),
          Column(children: const [
            Text("Hello, Anonymous",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  // color: Color(0xFF162339)),
                )),
            SizedBox(
              height: 10,
            ),
            Text("You have a reminder",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  // color: Colors.grey),
                )),
          ]),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              margin: const EdgeInsets.only(left: 30, right: 30),
              //child:Text('${_payload}'),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.text_format, size: 35, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Title",
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      _payload.toString().split("|")[0],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Icon(Icons.description, size: 30, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Description",
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      _payload.toString().split("|")[1],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Icon(Icons.calendar_today,
                            size: 28, color: Colors.white),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Date",
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      _payload.toString().split("|")[2],
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ]),
              decoration: const BoxDecoration(
                  color: primaryClr,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50))),
            ),
          ),
          const SizedBox(
            height: 140,
          )
        ]),
      ),
    );
  }
}
