import 'dart:convert';

import 'package:cron/cron.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:json_theme/json_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:vialticecmr/firebase_options.dart';
import 'package:vialticecmr/model/ordretransport.dart';
import 'package:vialticecmr/screen/AuthScreen.dart';
import 'package:vialticecmr/screen/ExploitationScreen.dart';
import 'package:vialticecmr/screen/MyAccountScreen.dart';
import 'package:vialticecmr/screen/OrdreTransportLandingScreen.dart';
import 'package:vialticecmr/screen/OrdreTransportScreen.dart';
import 'package:vialticecmr/screen/TourneeScreen.dart';
import 'package:vialticecmr/screen/landing.dart';
import 'package:vialticecmr/utils/MyVariables.dart';
import 'package:vialticecmr/utils/network.dart';
import 'package:vialticecmr/utils/sqlHelper.dart';

final GlobalKey rootWidgetKey = GlobalKey();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'description',
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
Future<void> main() async {
  // firebase App initialize
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Firebase local notification plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  //Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  //myFirebase().initFirebase();

  myFirebase().initFirebaseMessaging();
  final cron = Cron();

  cron.schedule(Schedule.parse('*/1 * * * *'), () async {
    await Network().synchronise();

    OrdreTransport ordre = OrdreTransport(ordretransportId: 0);
    await ordre.fetchJobs();
  });

  final themeStr =
      await rootBundle.loadString('assets/appainter_theme_jaune.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson);

  // Open the database and store the reference.
  final database = openDatabase(
    join(await getDatabasesPath(), 'demo.db'),
  );
  final tempDir = await getApplicationDocumentsDirectory();
  final tempPath = tempDir.path;
  MyVariables().basePath(tempPath);
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String version = packageInfo.version;

  MyVariables().setInfoVersion('$appName- $version');
  String lastLogin = await SQLHelper.getLastLogin();
  MyVariables().setLogin(lastLogin);
  String lastPass = await SQLHelper.getLastPass();
  String lastName = await SQLHelper.getParameter('lastname');
  String firstName = await SQLHelper.getParameter('firstname');
  MyVariables().setUser({
    'getLastName': lastName,
    'getFirstName': firstName,
  });
  MyVariables().setPass(lastPass);
  WidgetsFlutterBinding.ensureInitialized();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  MyVariables().setToken(fcmToken!);

  runApp(MyApp(theme: theme!));
}

class MyApp extends StatefulWidget {
  final ThemeData theme;
  const MyApp({Key? key, required this.theme}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final int _counter = 0;

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vialtic E-cmr',
      theme: widget.theme,
      home: MyHomePage(title: 'Vialtic E-cmr', theme: widget.theme),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.theme})
      : super(key: key);

  final String title;
  final ThemeData theme;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', ''), // arabic, no country code
      ],
      theme: widget.theme,
      routes: {
        /*ExtractArgumentsScreen.routeName: (context) =>
            const ExtractArgumentsScreen(),*/
        '/': (context) => const Landing(),
        '/login': (context) => const AuthScreen(),
        '/home': (context) => const ExploitationScreen(),
        '/account': (context) => const MyAccountScreen(),
      },
      onGenerateRoute: (settings) {
        // If you push the PassArguments route
        if (settings.name == '/tournee') {
          final args = settings.arguments as TourneeParams;

          return MaterialPageRoute(
            builder: (context) {
              return TourneeLandingScreen(
                tourneeId: args.tourneeId,
              );
            },
          );
        }
        if (settings.name == '/ordre') {
          final args = settings.arguments as OrdreTransportParams;

          return MaterialPageRoute(
            builder: (context) {
              return OrdreTransportLandingScreen(
                ordretransportId: args.ordretransportId,
              );
            },
          );
        }
        if (settings.name == PassArgumentsScreen.routeName) {
          final args = settings.arguments as ScreenArguments;
          return MaterialPageRoute(
            builder: (context) {
              return PassArgumentsScreen(
                  title: args.title, message: args.message);
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}

class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({super.key});

  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

// A Widget that accepts the necessary arguments via the
// constructor.
class PassArgumentsScreen extends StatelessWidget {
  static const routeName = '/test';

  final String title;
  final String message;

  // This Widget accepts the arguments as constructor
  // parameters. It does not extract the arguments from
  // the ModalRoute.
  //
  // The arguments are extracted by the onGenerateRoute
  // function provided to the MaterialApp widget.
  const PassArgumentsScreen({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }
}

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}

class myFirebase {
  void initFirebaseMessaging() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        OrdreTransport ordre = OrdreTransport(ordretransportId: 0);
        ordre.fetchJobs();
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            payload: jsonEncode(message.data),
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
              ),
            ));
      }
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();
  }

  /// Initialisation du module Firebase
  void initFirebase() async {
    // Firebase local notification plugin
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    //Firebase messaging
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Actions à faire après clic sur une notification
  void onDidReceiveNotificationResponse(NotificationResponse details) {
    Map datas = jsonDecode(details.payload!);

    if (datas['data_type'] == 'new_transport') {
      int ordretransport_id = int.parse(datas['ordretransport_id']);
      Navigator.pushNamed(
        MyVariables().getMyCurrentContext,
        '/ordre',
        arguments: OrdreTransportParams(
          ordretransport_id,
        ),
      );
    }
    if (datas['data_type'] == 'new_tournee') {
      int tournee_id = int.parse(datas['tournee_id']);
      Navigator.pushNamed(
        MyVariables().getMyCurrentContext,
        '/tournee',
        arguments: TourneeParams(
          tournee_id,
        ),
      );
    }
  }
}
