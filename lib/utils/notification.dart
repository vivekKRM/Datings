import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:Dating/utils/appManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
// import 'package:firebase_messaging/firebase_messaging.dart';
//added
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

Future<dynamic> myBackgroundMessageHandler(message) async {
  print("messages in background $message");
}

class Notifications {
  // final AppManager appManager;
  // late SharedPreferences prefs;
  // late BuildContext context;
  // late String mobileToken;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();
  // final BehaviorSubject<ReceivedNotification>
  //     didReceiveLocalNotificationSubject =
  //     BehaviorSubject<ReceivedNotification>();
  // final BehaviorSubject<String> selectNotificationSubject =
  //     BehaviorSubject<String>();
  // BehaviorSubject<RemoteMessage> remoteMessages =
  //     BehaviorSubject<RemoteMessage>();
  //added

  static const String navigationActionId = 'id_1';
  static const String darwinNotificationCategoryPlain = 'plainCategory';
  // Firebase message variables;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // Stream<RemoteMessage> onMessage = FirebaseMessaging.onMessage;

  // Notifications(this.appManager) {
  //   this._requestPermissions();
  //   checkNotificationPermission();
  //   this.setupNotifications();
  //   this.configureSelectNotificationSubject();

    //added 1 Jun
    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //     print("Foreground message received: ${message.messageId}");
    //     //when notification came on live
    //     // Call the necessary function to handle the push notification data
    //   });
    // }

    // Future<String> getUserToken() async {
    //   this.mobileToken = await _firebaseMessaging.getToken() ?? '';
    //   print("this.mobileToken ${this.mobileToken}");
    //   this.prefs.setString("firebaseToken", this.mobileToken);
    //   return this.mobileToken;
    // }

    // setupFirebaseNotifications() async {
    //   if (Platform.isIOS) await _firebaseMessaging.requestPermission();
    //   _firebaseMessaging.onTokenRefresh.listen((event) {
    //     print("on notification token changed $event");
    //     // TODO: implement this to save new token;
    //   });

    //   await flutterLocalNotificationsPlugin
    //       .resolvePlatformSpecificImplementation<
    //           AndroidFlutterLocalNotificationsPlugin>()
    //       ?.createNotificationChannel(new AndroidNotificationChannel(
    //           "default_notification_channel_id", "Messaging channel"));
    //   // "Server notification receiving channel"));

    //   _firebaseMessaging.setForegroundNotificationPresentationOptions(
    //       alert: true, badge: true, sound: true);

    //   // Grabbing notification which opened the app;
    //   RemoteMessage? messageFromOutside =
    //       await _firebaseMessaging.getInitialMessage();
    //   debugPrint("messageFromOutside $messageFromOutside");
    //   if (messageFromOutside != null) {
    //     this.foundServerNorification(messageFromOutside, true);
    //   }

    //   // Grabbing notification while on foreground
    //   this.onMessage.listen((RemoteMessage message) {
    //     print("OnMessage");
    //     //when notification receiived live
    //     // prefs.setInt('therapy', tCounter);
    //     if (message.data['category'] == "medicine:add" ||
    //         message.data['category'] == "medicine:update:data" ||
    //         message.data['category'] == "medcine:update:timing" ||
    //         message.data['category'] == "medicine:delete" ||
    //         message.data['category'] == "therapy:add" ||
    //         message.data['category'] == "therapy:update:data" ||
    //         message.data['category'] == "therapy:update:timing" ||
    //         message.data['category'] == "therapy:delete") {
    //       this.foundServerNorification(message, true);
    //     } else {
    //       this.foundServerNorification(message, false);
    //     }
    //   });

    //   // Setting background handler

    //   FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    //   FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    // }

    // void _onMessageOpenedApp(RemoteMessage message) {
    //   // Handle the received message when the user taps on the notification
    //   print('User tapped on push notification: ${message.notification?.title}');
    // }

    // setupNotifications() async {
    //   print('Notifications setup started');
    //   this.prefs = await SharedPreferences.getInstance();

    //   final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    //       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    //   // final details = await _localNotifications.getNotificationAppLaunchDetails();
    //   final details =
    //       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    //   if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    //     this.appManager.appOpenedByNotification = true;
    //     if (details != null && details.didNotificationLaunchApp) {
    //       behaviorSubject.add(details.notificationResponse?.payload ?? '');
    //       this.foundNotification(details.notificationResponse?.payload ?? '');
    //     }
    //   }

    //   const AndroidInitializationSettings initializationSettingsAndroid =
    //       AndroidInitializationSettings('app_icon');

    //   final DarwinInitializationSettings initializationSettingsIOS =
    //       DarwinInitializationSettings(
    //     requestAlertPermission: false,
    //     requestBadgePermission: false,
    //     requestSoundPermission: false,
    //     defaultPresentAlert: true,
    //     defaultPresentSound: true,
    //     onDidReceiveLocalNotification:
    //     (int? id, String? title, String? body, String? payload) async {
    //   saveStringValue('Hello');
    //   print("onDidReceive Notification in---initializationSettingsIOS");
    //   didReceiveLocalNotificationSubject.add(
    //     ReceivedNotification(
    //       id: id ?? 0,
    //       title: title ?? "",
    //       body: body ?? "",
    //       payload: payload ?? "",
    //     ),
    //   );
    // },
    //     notificationCategories: [
    //       DarwinNotificationCategory(
    //         'demoCategory',
    //         options: {
    //           DarwinNotificationCategoryOption.allowAnnouncement,
    //         },
    //         actions: <DarwinNotificationAction>[
    //           DarwinNotificationAction.plain(
    //             navigationActionId,
    //             'Remind me later',
    //             options: <DarwinNotificationActionOption>{
    //               DarwinNotificationActionOption.foreground,
    //             },
    //           ),
    //           DarwinNotificationAction.plain(
    //             'id_2',
    //             'Dismiss',
    //             options: <DarwinNotificationActionOption>{
    //               DarwinNotificationActionOption.destructive,
    //             },
    //           ),
    //         ],
    //       )
    //     ],
    //   );

    //   final InitializationSettings initializationSettings =
    //       InitializationSettings(
    //           android: initializationSettingsAndroid,
    //           iOS: initializationSettingsIOS);

    //   await flutterLocalNotificationsPlugin.initialize(
    //     initializationSettings,
    //     onDidReceiveNotificationResponse:
    //         (NotificationResponse notificationResponse) async {
    //       switch (notificationResponse.notificationResponseType) {
    //         case NotificationResponseType.selectedNotification:
    //           print("coming from selecting Notification");
    //           saveStringValue('Hello');
    //           selectNotificationSubject.add(notificationResponse.payload ?? '');
    //           saveStringValue('Hello');
    //           //added on 25 Oct
    //           if (notificationResponse.payload?.contains(',') ?? false) {
    //             final List<String> payloadComponent =
    //                 notificationResponse.payload?.split(',') ?? [];
    //             if (payloadComponent[1].contains('-') &&
    //                 payloadComponent.length > 0) {
    //               // print("Handling Local Notifications- ${payload}");
    //               final List<String> data = payloadComponent[1].split('-');
    //               print("data Notifications- ${data[0]}");
    //               if (data[0] == 'Medication') {
    //                 // Navigator.pushNamed(context, '/medicationTherapyTab',
    //                 //     arguments: MedicationTherapyTabArgs(0));
    //               } else {
    //                 // Navigator.pushNamed(context, '/medicationTherapyTab',
    //                 //     arguments: MedicationTherapyTabArgs(1));
    //               }
    //               // callSkipApi(data[1], data[0]);
    //             }
    //           }
    //           //added on 25 Oct

    //           //send to next page
    //           break;
    //         case NotificationResponseType.selectedNotificationAction:
    //           print("coming from action button selectedNotificationAction");
    //           int? alertId;
    //           List<String> medicineAlert = [];

    //           if (notificationResponse.actionId == navigationActionId) {
    //             final List<String> data = notificationResponse.payload?.split(',') ?? [];
    //             final List<String> nameid = data[0].split('|');
    //             final List<String> dataLast = data[1].split('-');
    //             final String name = nameid[0];
    //             final String id = nameid[1];
    //             var now = DateTime.now();
    //             if (id == "1") {
    //               DateTime scheduledDateTime = now.add(Duration(minutes: 30));//30 on 10 Jan
    //               print(scheduledDateTime);
    //               var alertTime = tz.TZDateTime(
    //                   this.appManager.utils.localTimeZone,
    //                   now.year,
    //                   now.month,
    //                   now.day,
    //                   scheduledDateTime.hour,
    //                   scheduledDateTime.minute,
    //                   scheduledDateTime.second);
    //               print(alertTime);
    //               try {
    //     alertId =
    //         await this.appManager.notifications.setLocalDailyNotification(
    //                    1,
    //                   "${dataLast[0]} Reminder",
    //                   "Take ${name}",
    //                   alertTime,
    //                   "${name}|2,${dataLast[0]}-${dataLast[1]}", //"${name}|2",
    //                   false,
    //                   '');
    //   } catch (e) {
    //     print("Exception when setting notification: $e");
    //     // medicationAlertIds.add(alertId);
    //   }
    //   if (alertId != null) {
    //     // this.appManager.remindLater.add(
    //     //     {
    //     //       "mediId" : "${dataLast[1]}",
    //     //       "remindLater": true,
    //     //       "alertId": alertId
    //     //     }
    //     // );
    //     medicineAlert.add(alertId.toString());
    //     this.appManager.prefs.setStringList("${dataLast[1]}", medicineAlert);
    //   }
    //             //  this.appManager.notifications.setLocalDailyNotification(
    //             //       1,
    //             //       "${dataLast[0]} Reminder",
    //             //       "Take ${name}",
    //             //       alertTime,
    //             //       "${name}|2,${dataLast[0]}-${dataLast[1]}", //"${name}|2",
    //             //       false,
    //             //       '');
    //             } else if (id == "2") {
    //               DateTime scheduledDateTime = now.add(Duration(minutes: 30));
    //               print(scheduledDateTime);
    //               var alertTime = tz.TZDateTime(
    //                   this.appManager.utils.localTimeZone,
    //                   now.year,
    //                   now.month,
    //                   now.day,
    //                   scheduledDateTime.hour,
    //                   scheduledDateTime.minute,
    //                   scheduledDateTime.second);
    //               print(alertTime);

    //                 try {
    //     alertId =
    //         await this.appManager.notifications.setLocalDailyNotification(
    //                    1,
    //                   "${dataLast[0]} Reminder",
    //                   "Take ${name}",
    //                   alertTime,
    //                   "${name}|3,${dataLast[0]}-${dataLast[1]}", //"${name}|2",
    //                   false,
    //                   '');
    //   } catch (e) {
    //     print("Exception when setting notification: $e");
    //     // medicationAlertIds.add(alertId);
    //   }
    //   if (alertId != null) {
    //     // this.appManager.remindLater.add(
    //     //     {
    //     //       "mediId" : "${dataLast[1]}",
    //     //       "remindLater": true,
    //     //       "alertId": alertId
    //     //     }
    //     // );
    //     medicineAlert.add(alertId.toString());
    //     this.appManager.prefs.setStringList("${dataLast[1]}", medicineAlert);
    //   }

    //               // this.appManager.notifications.setLocalDailyNotification(
    //               //     1,
    //               //     "${dataLast[0]} Reminder",
    //               //     "Take ${name}",
    //               //     alertTime,
    //               //     "${name}|3,${dataLast[0]}-${dataLast[1]}", //"${name}|3",
    //               //     false,
    //               //     '');
    //             }
    //             selectNotificationSubject.add(notificationResponse.payload ?? '');
    //           }
    //           break;
    //       }
    //     },
    //     // onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
    //   );
    //   print('Notifications setup done');
    // }

    void onDidReceiveBackgroundNotificationResponse(
        NotificationResponse notificationResponse) {
      // Handle the background notification response here
      // This function will be called when your app is in the background or closed
      // saveStringValue('Hello');
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          // Handle the selected notification response
          print("coming from selecting Notification");
          // You can add your custom logic here
          break;
        case NotificationResponseType.selectedNotificationAction:
          // Handle the selected notification action response
          print("coming from action button selectedNotificationAction");
          // You can add your custom logic here
          break;
      }
    }

    // Future onDidReceiveLocalNotification(
    //     int id, String title, String body, String payload) async {
    //   saveStringValue('Hello');
    //   print('onDidReceiveLocalNotification occur');
    //   didReceiveLocalNotificationSubject.add(
    //     ReceivedNotification(
    //       id: id,
    //       title: title,
    //       body: body,
    //       payload: payload,
    //     ),
    //   );
    // }

    // @override
    // void dispose() {
    //   didReceiveLocalNotificationStream.close();
    //   selectNotificationStream.close();
    //   super.dispose();
    // }

    void _requestPermissions() {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    // configureDidReceiveLocalNotificationSubject(BuildContext context) {
    //   print("configureDidReceiveLocalNotificationSubject");
    //   // saveStringValue('Hello');//when run app 26 Oct
    //   this.context = context;
    //   didReceiveLocalNotificationSubject.stream
    //       .listen((ReceivedNotification receivedNotification) async {
    //     await showDialog(
    //       context: context,
    //       builder: (BuildContext context) => CupertinoAlertDialog(
    //         title: receivedNotification.title != null
    //             ? Text(receivedNotification.title)
    //             : null,
    //         content: receivedNotification.body != null
    //             ? Text(receivedNotification.body)
    //             : null,
    //         actions: <Widget>[
    //           CupertinoDialogAction(
    //             isDefaultAction: true,
    //             onPressed: () async {
    //               // Navigator.of(context, rootNavigator: true).pop();
    //               // await Navigator.pushNamed(context, '/home');
    //             },
    //             child: const Text('Ok'),
    //           )
    //         ],
    //       ),
    //     );
    //   });
    // }

    // selectNotification(String payload) async {
    //   if (payload != null && payload.isNotEmpty) {
    //     debugPrint('notification: payload 1 $payload');
    //     saveStringValue('Hello');
    //   }
    //   selectNotificationSubject.add(payload);
    //   // Clear the notification from the status bar
    //   await flutterLocalNotificationsPlugin.cancelAll();
    // }

    //Added 6 Jun

    // configureSelectNotificationSubject() {
    //   selectNotificationSubject.stream.listen((payload) async {
    //     //on Tap this function called
    //     print(payload);
    //     saveStringValue('Hello');
    //     // if (payload.contains(',')) {
    //     //   final List<String> payloadComponent = payload.split(',');
    //     //   if (payloadComponent[1].contains('-') && payloadComponent.length > 0) {
    //     //     print("Handling Local Notifications- ${payload}");
    //     //     final List<String> data = payloadComponent[1].split('-');
    //     //     print("data Notifications- ${data[0]}");
    //     //     if (data[0] == 'Medication') {
    //     //       Navigator.pushNamed(context, '/medicationTherapyTab',
    //     //           arguments: MedicationTherapyTabArgs(0));
    //     //     } else {
    //     //       Navigator.pushNamed(context, '/medicationTherapyTab',
    //     //           arguments: MedicationTherapyTabArgs(1));
    //     //     }
    //     //     // callSkipApi(data[1], data[0]);
    //     //   }
    //     // } else {
    //     //   if (payload.isNotEmpty) {
    //     //     this.foundNotification(payload);
    //     //   }
    //     // }
    //   });
    // }

    // Future<void> checkNotificationPermission() async {
    //   PermissionStatus status = await Permission.notification.status;
    //   if (status.isGranted) {
    //     print('Notification permission is granted.');
    //   } else if (status.isDenied) {
    //     if (Platform.isAndroid) openAppSettings();
    //     print('Notification permission is denied.');
    //   } else if (status.isPermanentlyDenied) {
    //     if (Platform.isAndroid) openAppSettings();
    //     print('Notification permission is permanently denied.');
    //   }
    // }

    void openAppSettings() {
      AppSettings.openAppSettings();
    }

    cancelNotification(int? notificationId) async {
      await flutterLocalNotificationsPlugin.cancel(notificationId ?? 0);
    }

    cancelAllNotification() async {
      await flutterLocalNotificationsPlugin.cancelAll();
    }

    getPendingNotifications() async {
      List<PendingNotificationRequest> pendingNotificationRequests =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      return pendingNotificationRequests;
    }

    //25 Oct
    Future<void> saveStringValue(String value) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('myStringValue', value);
    }
    //25 Oct

    //22 Jun Added
    Future<String> copyAssetToFile(String assetPath) async {
      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/${assetPath.split('/').last}';
      final byteData = await rootBundle.load(assetPath);
      final bytes = byteData.buffer.asUint8List();
      await File(tempPath).writeAsBytes(bytes);
      return tempPath;
    }

    //22 Jun Added

    Future<int?> setLocalDailyNotification(
      int id,
      String title,
      String body,
      tz.TZDateTime dateTime,
      String payload,
      bool group,
      String called,
    ) async {
      bool setAsGroupSummarys = title != "Reading reminder" ? false : true;
      int notificationId = new Random().nextInt(10000);
      // final attachmentPath = await copyAssetToFile('assets/angry.png');
      // var attachment = DarwinNotificationAttachment(
      //   attachmentPath,
      //   identifier:
      //       'localDailyNotifications', // Replace with your image file path
      // );
      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentList: true,
        presentBanner: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
        presentSound: true,
        threadIdentifier: "localDailyNotifications",
        categoryIdentifier: 'demoCategory',
      );
//Added for group
      const AndroidNotificationDetails androidGRPPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'dailyNotification',
        'Daily Reminder',
        channelDescription: "Reminder Description",
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        enableVibration: true,
        groupKey: 'groupKey',
        autoCancel: false,
        playSound: true,
        ongoing: true,
        setAsGroupSummary: true,
      );
      //un commented
      const NotificationDetails platformGrpChannelSpecifics =
          NotificationDetails(
        android: androidGRPPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      // //added new for group
      // await flutterLocalNotificationsPlugin.zonedSchedule(0, called, "", dateTime,
      //     platformGrpChannelSpecifics, //id ?? notificationId;
      //     //'Daily reminder for daily needed actions in app'
      //     androidAllowWhileIdle: true,
      //     payload: '',
      //     uiLocalNotificationDateInterpretation:
      //     UILocalNotificationDateInterpretation.absoluteTime,
      //     matchDateTimeComponents: DateTimeComponents.time);
      //un commented
//Added for group
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'dailyNotification',
        'Daily Reminder',
        channelDescription: "Reminder Description",
        importance: Importance.max,
        priority: Priority.high,
        groupKey: 'groupKey',
        fullScreenIntent: true,
        enableVibration: true,
        autoCancel: false,
        playSound: true,
        ongoing: true,
        // setAsGroupSummary: setAsGroupSummarys,//to be commented for group notification//uncomment for reading notifications
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            navigationActionId,
            'Remind me later',
            showsUserInterface: true,
          ),
          AndroidNotificationAction(
            'id_2',
            'Dismiss',
            cancelNotification: true,
            showsUserInterface: false,
          )
        ],
      );
      NotificationDetails platformChannelSpecifics;
      if (title != "Reading reminder") {
        platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iosPlatformChannelSpecifics,
        );
      } else {
        platformChannelSpecifics = NotificationDetails(
          android: androidGRPPlatformChannelSpecifics,
          iOS: iosPlatformChannelSpecifics,
        );
      }

      await flutterLocalNotificationsPlugin.zonedSchedule(
          id ?? notificationId, title, body, dateTime, platformChannelSpecifics,
          //'Notifications scheduled to occur only once'
          // ignore: deprecated_member_use
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload);

      if (Platform.isAndroid && title != "Reading reminder") {
        await flutterLocalNotificationsPlugin.zonedSchedule(0, called, "",
            dateTime, platformGrpChannelSpecifics, //id ?? notificationId;
            //'Daily reminder for daily needed actions in app'
            androidAllowWhileIdle: true,
            payload: '',
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.time);
      }

      return id ?? notificationId;
    }

    Future<int> setLocalScheduledNotification(int? id, String title,
        String body, tz.TZDateTime dateTime, String payload) async {
      const DarwinNotificationDetails iosNotificationDetails =
          DarwinNotificationDetails(
        categoryIdentifier: darwinNotificationCategoryPlain,
      );
      int notificationId = new Random().nextInt(10000);
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id ?? notificationId,
          title,
          body,
          dateTime,
          const NotificationDetails(
              iOS: iosNotificationDetails,
              android: AndroidNotificationDetails('scheduledForOnce', 'Once',
                  importance: Importance.max, priority: Priority.high)),
          //'Notifications scheduled to occur only once'
          // ignore: deprecated_member_use
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload);
      return id ?? notificationId;
    }

    // foundServerNorification(
    //     RemoteMessage message, bool appOpenedByRemoteMessage) {
    //   print(
    //       "notification type ${message.data["category"]} and ${message.data["category"] == "message"} and type ${message.data["category"].runtimeType}");
    //   if (message != null) {
    //     if (message.data["category"] == "message") {
    //       if (this.appManager.currentPage == "/messages") {
    //         this.remoteMessages.add(message);
    //       } else {
    //         if (appOpenedByRemoteMessage) {
    //           Navigator.pushNamed(context, "/messages");
    //         } else {
    //           print("Not Navigator.pushNamed $appOpenedByRemoteMessage");
    //           /* TODO: Find proper action to be taken */
    //         }
    //       }
    //     } else if (message.data["category"] == "readingAcknowledgement") {
    //       print(
    //           "readingAcknowledgement message.data.data ${jsonDecode(message.data["data"])}");
    //       var data = jsonDecode(message.data["data"]);
    //       if (data && data["category"]) {
    //         var category = data["category"];
    //         var notificationId =
    //                 this.appManager.prefs.getInt("$category reminder id"),
    //             notificationTimer =
    //                 this.appManager.prefs.getString("$category reminder time");
    //         if (category != null &&
    //             notificationTimer != null &&
    //             notificationId != null) {
    //           var newDate =
    //               DateTime.parse(notificationTimer).add(new Duration(days: 1));
    //           this
    //               .appManager
    //               .utils
    //               .cancelReadingReminder(notificationId, category);
    //           // this
    //           //     .appManager
    //           //     .utils
    //           //     .setReadingReminder(notificationId, category, newDate);
    //         }
    //       }
    //     } else if ((message.data["category"] == "medicine:add") ||
    //         (message.data["category"] == "medicine:update:data")) {
    //       print("medicine message.data.data ${jsonDecode(message.data["data"])}");
    //       var data = jsonDecode(message.data["data"]);
    //       if (this.appManager.currentPage == "/medicationTherapyTab") {
    //         // this.medication.add(data);
    //       } else {
    //         if (appOpenedByRemoteMessage) {
    //           //  this.appManager.utils.setReadingReminder(notificationId, category, newDate);
    //           // Navigator.pushNamed(context, '/medicationTherapyTab',
    //           //     arguments: MedicationTherapyTabArgs(0));
    //         } else {
    //           print("Not Navigator.pushNamed $appOpenedByRemoteMessage");
    //           /* TODO: Find proper action to be taken */
    //         }
    //       }
    //       //navigate to Medicine List an reload list and set Reminder
    //     } else if (message.data["category"] == "medcine:update:timing") {
    //       print("medicine message.data.data ${jsonDecode(message.data["data"])}");
    //       var data = jsonDecode(message.data["data"]);
    //       if (this.appManager.currentPage == "/medicationTherapyTab") {
    //         // this.medication.add(data);
    //         //  this.appManager.utils.cancelReadingReminder(notificationId, category);
    //         //  this.appManager.utils.setReadingReminder(notificationId, category, newDate);
    //       } else {
    //         if (appOpenedByRemoteMessage) {
    //           // Navigator.pushNamed(context, '/medicationTherapyTab',
    //           //     arguments: MedicationTherapyTabArgs(0));
    //         } else {
    //           print("Not Navigator.pushNamed $appOpenedByRemoteMessage");
    //           /* TODO: Find proper action to be taken */
    //         }
    //       }
    //       //navigate to medicine List and reload list and Update Reminder, remove older reminder
    //     } else if (message.data["category"] == "medicine:delete") {
    //       print("medicine message.data.data ${jsonDecode(message.data["data"])}");
    //       var data = jsonDecode(message.data["data"]);
    //       if (this.appManager.currentPage == "/medicationTherapyTab") {
    //         //  this.appManager.utils.cancelReadingReminder(notificationId, category);
    //       } else {
    //         if (appOpenedByRemoteMessage) {
    //           // Navigator.pushNamed(context, '/medicationTherapyTab',
    //           //     arguments: MedicationTherapyTabArgs(0));
    //         } else {
    //           print("Not Navigator.pushNamed $appOpenedByRemoteMessage");
    //           /* TODO: Find proper action to be taken */
    //         }
    //       }
    //       //navigate to medicine List and reload list and remove reminder
    //     }
    //     //Therapy Notification Handle
    //     else if ((message.data["category"] == "therapy:add") ||
    //         (message.data["category"] == "therapy:update:data")) {
    //       print("therapy message.data.data ${jsonDecode(message.data["data"])}");
    //       var data = jsonDecode(message.data["data"]);
    //       if (this.appManager.currentPage == "/medicationTherapyTab") {
    //         // this.therapy.add(data);
    //         //  this.appManager.utils.setReadingReminder(notificationId, category, newDate);
    //       } else {
    //         if (appOpenedByRemoteMessage) {
    //           // Navigator.pushNamed(context, '/medicationTherapyTab',
    //           //     arguments: MedicationTherapyTabArgs(1));
    //         } else {
    //           print("Not Navigator.pushNamed $appOpenedByRemoteMessage");
    //           /* TODO: Find proper action to be taken */
    //         }
    //       }
    //       //navigate to Medicine List an reload list and set Reminder
    //     } else if (message.data["category"] == "therapy:update:timing") {
    //       print("therapy message.data.data ${jsonDecode(message.data["data"])}");
    //       var data = jsonDecode(message.data["data"]);
    //       if (this.appManager.currentPage == "/medicationTherapyTab") {
    //         //  this.appManager.utils.cancelReadingReminder(notificationId, category);
    //         //  this.appManager.utils.setReadingReminder(notificationId, category, newDate);
    //       } else {
    //         if (appOpenedByRemoteMessage) {
    //           // Navigator.pushNamed(context, '/medicationTherapyTab',
    //           //     arguments: MedicationTherapyTabArgs(1));
    //         } else {
    //           print("Not Navigator.pushNamed $appOpenedByRemoteMessage");
    //           /* TODO: Find proper action to be taken */
    //         }
    //       }
    //       //navigate to medicine List and reload list and Update Reminder, remove older reminder
    //     } else if (message.data["category"] == "therapy:delete") {
    //       print("therapy message.data.data ${jsonDecode(message.data["data"])}");
    //       var data = jsonDecode(message.data["data"]);
    //       if (this.appManager.currentPage == "/medicationTherapyTab") {
    //         //  this.appManager.utils.cancelReadingReminder(notificationId, category);
    //       } else {
    //         if (appOpenedByRemoteMessage) {
    //           // Navigator.pushNamed(context, '/medicationTherapyTab',
    //           //     arguments: MedicationTherapyTabArgs(1));
    //         } else {
    //           print("Not Navigator.pushNamed $appOpenedByRemoteMessage");
    //           /* TODO: Find proper action to be taken */
    //         }
    //       }
    //       //navigate to medicine List and reload list and remove reminder
    //     }
    //   }
    // }

    foundNotification(String payload) async {
      print('foundNotification - $payload');
      if (payload.isNotEmpty) {
        Map<String, dynamic> payloadJson = jsonDecode(payload);
        print("payloadJson-> $payloadJson");
        if (payloadJson["dailyNotification"]) {
          // this.foundDailyNotification(payloadJson);
        }
      }
    }

    Future<List<String>> getListFromSharedPreferences() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> encodedList = prefs.getStringList('MedicationAckList') ?? [];
      return encodedList;
    }

    Future<void> saveListToSharedPreferences(
        String type, List<String> acknowledgedList) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (type == 'Medication') {
        await prefs.setStringList('MedicationAckList', acknowledgedList);
      } else {
        await prefs.setStringList('TherapyAckList', acknowledgedList);
      }
    }
  }

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}
