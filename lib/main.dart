import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location_radius/controller/location_controller.dart';
import 'package:location_radius/location_fetch.dart';
import 'package:location_radius/notification_code.dart';
import 'package:network_info_plus/network_info_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notificationMainMethod();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final NetworkInfo _networkInfo = NetworkInfo();
  final controller = Get.put(LocationController());

  final storage = GetStorage();
  String? wifiName;
  @override
  initState() {
    super.initState();
    //  9.930520155469766,
    //     76.35232860320333,

    storage.write("lat", 9.930520155469766);
    storage.write("long", 76.35232860320333);

    double lat = storage.read("lat") ?? 0.0;
    double long = storage.read("long") ?? 0.0;

    log("123  lat ${lat.toString()} long ${long.toString()}");

    if (lat != 0.0 && long != 0.0) {
      log("message");
      controller.checkIfWithinBounds(
        lat: lat,
        long: long,
      );
    }

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      log(result.name);
      // Got a new connectivity status!
    });
    getPermissions();
  }

  getPermissions() async {
    // ignore: deprecated_member_use
    await _networkInfo.requestLocationServiceAuthorization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Get.to(
                      () => const LocationFetch(),
                    );
                  },
                  child: const Text("Location fetch")),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  log("pressed");
                  var ipAddress = IpAddress(type: RequestType.json);
                  dynamic data = await ipAddress.getIpAddress();
                  log(data["ip"].toString());

                  // {ip: 49.37.226.163}
                  storage.write(
                    "wifi",
                    data["ip"].toString(),
                  );

                  String wifi = storage.read("wifi") ?? "";

                  if (wifi != "") {
                    if (wifi == data["ip"].toString()) {
                      flutterLocalNotificationsPlugin.show(
                        0,
                        "Alert",
                        "Viswajith is connected to office wifi",
                        NotificationDetails(
                          android: AndroidNotificationDetails(
                            channel.id,
                            channel.name,
                            playSound: true,
                            icon: '@mipmap/ic_launcher',
                          ),
                          iOS: const DarwinNotificationDetails(),
                        ),
                        // payload: message.data['type'].toString(),
                      );
                    }
                  }
                },
                child: const Text("Network Check"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
