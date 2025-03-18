// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kunet_app/screens/onboarding/onboarding.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:kunet_app/components/dashboard/dashboard.dart';
import 'package:kunet_app/helper/constants/constants.dart';
import 'package:kunet_app/helper/preference/preference_manager.dart';
import 'package:kunet_app/helper/state/state_manager.dart';
import 'package:kunet_app/helper/theme/app_theme.dart';
import 'package:kunet_app/screens/network/no_internet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'helper/socket/socket_manager.dart';
import 'helper/state/theme_manager.dart';

Future initFirebase() async {
  await Firebase.initializeApp();
}

enum Version { lazy, wait }

// Cmd-line args/Env vars: https://stackoverflow.com/a/64686348/2301224
const String version = String.fromEnvironment('VERSION');
const Version running = version == "lazy" ? Version.lazy : Version.wait;

class GlobalBindings extends Bindings {
  // final LocalDataProvider _localDataProvider = LocalDataProvider();
  @override
  void dependencies() {
    Get.lazyPut<StateController>(() => StateController(), fenix: true);
    // Get.lazyPut<PaymentController>(() => PaymentController(), fenix: true);
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);
    // Get.put<StateController>(StateController(), permanent: true);
    // Get.put<LocalDataProvider>(_localDataProvider, permanent: true);
    // Get.put<LocalDataSource>(LocalDataSource(_localDataProvider),
    // permanent: true);
  }
}

/// Calling [await] dependencies(), your app will wait until dependencies are loaded.
class AwaitBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<StateController>(() async {
      Dao _dao = await Dao.createAsync();
      return StateController(myDao: _dao);
    });

    // await Get.putAsync<PaymentController>(() async {
    //   return PaymentController();
    // });

    await Get.putAsync<ThemeController>(() async {
      return ThemeController();
    });
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Set the status bar color
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.white, // Set your desired color here
  //     statusBarIconBrightness:
  //         Brightness.dark, // Set the status bar icons' color
  //   ),
  // );

  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual,
  //   overlays: [SystemUiOverlay.bottom],
  // );

  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _controller = Get.put(StateController());

  Widget? component;
  PreferenceManager? _manager;
  bool _authenticated = false;

  _init() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      _authenticated = _prefs.getBool("loggedIn") ?? false;
      final _currentThemeMode = _prefs.getString("themeMode") ?? "";
      if (_currentThemeMode == "dark") {
        _controller.currentThemeMode.value = "dark";
      } else if (_currentThemeMode == "system default") {
        _controller.currentThemeMode.value = "system default";
      } else {
        _controller.currentThemeMode.value = "light";
      }
      print("MAIN THEME HERE ::::   $_currentThemeMode");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _connectSocket() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      final _token = _prefs.getString("accessToken") ?? "";
      final _user = _prefs.getString("user") ?? "";
      Map<String, dynamic> _userMap = jsonDecode(_user);

      // socket = IO.io('${Constants.baseURL}/', <String, dynamic>{
      //   "transports": ["websocket"],
      //   "autoConnect": false
      // });

      final socket = SocketManager().socket;
      // socket.connect();
      // socket.on
      socket.onConnect((data) => print('Connected ID: ${data}'));

      if (_token.isNotEmpty) {
        socket.emit('identity', _userMap['id']);
      }

      socket.on(
        "message",
        (data) => debugPrint("DATA FROM SERVER >> $data"),
      );

      socket.on(
        "isOnline",
        (data) => debugPrint("DATA FROM  >> $data"),
      );

      // Profile Updated
      socket.on(
        "profile-updated",
        (data) {
          debugPrint("DATA FROM PROFILE UPDATE  >> ${jsonEncode(data)}");
          // debugPrint("USER ID >> ${data['userId']}");
          if (data['user']['email_address'] == _userMap['email_address']) {
            //For me
            debugPrint("FOR ME !! ");
            _prefs.setString('user', data['user']);
            _controller.userData.value = data['user'];
          } else {
            // Not for me
            debugPrint("NOT FOR ME !! ");
          }
        },
      );

      // Bank saved
      socket.on(
        "bank-added",
        (data) => debugPrint("DATA FROM BANK  >> $data"),
      );

      // Bank saved
      socket.on(
        "buy-voucher",
        (data) => debugPrint("DATA FROM VOUCHER PURCHASE >> $data"),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _manager = PreferenceManager(context);
    _init();
    _connectSocket();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Obx(
            () => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Kunet_app',
              theme: _controller.currentThemeMode.value == "dark"
                  ? darkTheme
                  : appTheme,
              home: Scaffold(
                body: Splash(
                  controller: _controller,
                ),
              ),
            ),
          );
        } else {
          // Loading is done, return the app:
          return Obx(
            () => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Kunet_app',
              theme: appTheme,
              darkTheme: darkTheme,
              themeMode: _controller.currentThemeMode.value == "dark"
                  ? ThemeMode.dark
                  : _controller.currentThemeMode.value == "system default"
                      ? ThemeMode.system
                      : ThemeMode.light,
              home: LoadingOverlayPro(
                isLoading: _controller.isLoading.value,
                progressIndicator: const CircularProgressIndicator.adaptive(),
                backgroundColor: Colors.black54,
                child: _controller.hasInternetAccess.value
                    ? !_authenticated
                        ? const Onboarding()
                        : Dashboard(
                            manager: _manager!,
                          )
                    : const NoInternet(),
              ),
            ),
          );
        }
      },
    );
  }
}

class Splash extends StatefulWidget {
  var controller;
  Splash({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  _init() async {
    try {
      // await FirebaseFirestore.instance.collection("stores").snapshots();
    } on SocketException catch (io) {
      widget.controller.setHasInternet(false);
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    bool lightMode =
        MediaQuery.of(context).platformBrightness == Brightness.light;
    return Container(
      color: lightMode ? Constants.primaryColor : const Color(0xff042a49),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    final _prefs = await SharedPreferences.getInstance();
    // await Future.delayed(const Duration(seconds: 3));
  }
}

class Dao {
  String dbValue = "";

  Dao._privateConstructor();

  static Future<Dao> createAsync() async {
    var dao = Dao._privateConstructor();
    // print('Dao.createAsync() called');
    return dao._initAsync();
  }

  /// Simulates a long-loading process such as remote DB connection or device
  /// file storage access.
  Future<Dao> _initAsync() async {
    dbValue =
        await Future.delayed(const Duration(seconds: 5), () => 'Some DB data');
    // print('Dao._initAsync done');
    return this;
  }
}
