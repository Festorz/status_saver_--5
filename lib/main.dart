import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'HomePage/homePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? _storagePermissionCheck;

  Future<int>? _StoragePermissionChecker;

  int? androidSDK;

  Future<int> _loadPermission() async {
    // Get phone SDK version first in order to request correct permissions.

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });

    if (androidSDK! >= 30) {
      //check first if we already have the persmissions
      final _currentStatusManaged =
          await Permission.manageExternalStorage.status;
      if (_currentStatusManaged.isGranted) {
        //update
        return 1;
      } else {
        return 0;
      }
    } else {
      //for older phones request typical storage permissions
      //check first if we already have the permissions

      final _currentStatusStorage = await Permission.storage.status;

      if (_currentStatusStorage.isGranted) {
        //update provider
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    if (androidSDK! >= 30) {
      //request management permission for android 11 and higher devices

      final _requestStatusManaged =
          await Permission.manageExternalStorage.request();
      // update provider model

      if (_requestStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final _requestStatusStorage = await Permission.storage.request();
      // update provider model
      if (_requestStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestStoragePermission() async {
    //
    final result = await [Permission.storage].request();
    if (result[Permission.storage]!.isDenied) {
      return 0;
    } else if (result[Permission.storage]!.isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    _StoragePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
        _storagePermissionCheck = await _loadPermission();
      } else {
        _storagePermissionCheck = 1;
      }

      if (_storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }

      return finalPermission;
    })();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.teal,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.teal,
        ),
        initial: AdaptiveThemeMode.light,
        builder: (light, dark) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Status Saver',
              theme: light,
              darkTheme: dark,
              home: DefaultTabController(
                  length: 2,
                  child: FutureBuilder(
                      future: _StoragePermissionChecker,
                      builder: (context, status) {
                        if (status.connectionState == ConnectionState.done) {
                          if (status.hasData) {
                            if (status.data == 1) {
                              return const HomePage();
                            } else {
                              return Scaffold(
                                body: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Colors.lightBlue[100]!,
                                      Colors.lightBlue[200]!,
                                      Colors.lightBlue[300]!,
                                      Colors.lightBlue[200]!,
                                      Colors.lightBlue[100]!,
                                    ],
                                  )),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Text(
                                          'Storage Permission Required',
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                      ),
                                      MaterialButton(
                                          padding: const EdgeInsets.all(15.0),
                                          color: Colors.indigo,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _StoragePermissionChecker =
                                                requestPermission();
                                            setState(() {});
                                          },
                                          child: const Text(
                                            'Allow Storage Permission',
                                            style: TextStyle(fontSize: 20.0),
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return Scaffold(
                              body: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Colors.lightBlue[100]!,
                                      Colors.lightBlue[200]!,
                                      Colors.lightBlue[300]!,
                                      Colors.lightBlue[200]!,
                                      Colors.lightBlue[100]!,
                                    ],
                                  )),
                                  child: const Center(
                                    child: Text(
                                      "Something went wrong...Please uninstall and Install again",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  )),
                            );
                          }
                        } else {
                          return const Scaffold(
                            body: SizedBox(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }
                      })),
            ));
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: Container(),
    // );
  }
}
