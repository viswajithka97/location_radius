import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:location_radius/location_fetch.dart';
import 'package:network_info_plus/network_info_plus.dart';

void main() {
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
  String? wifiName;
  @override
  initState() {
    super.initState();

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
                  log(data.toString());
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
