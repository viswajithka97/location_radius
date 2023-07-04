import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_radius/controller/location_controller.dart';

final Completer<GoogleMapController> mapcontroller = Completer();

const CameraPosition initialPosition =
    CameraPosition(target: LatLng(9.9487, 76.3464), zoom: 14.0);

late GoogleMapController googleMapController;

Set<Marker> markers = {};

class LocationFetch extends StatelessWidget {
  const LocationFetch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      init: LocationController(),
      initState: (_) {},
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Location'),
            centerTitle: true,
          ),
          body: GoogleMap(
            compassEnabled: true,
            initialCameraPosition: initialPosition,
            mapType: MapType.normal,
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: markers,
            onTap: (latLng) {
              controller.onTapMarker(latLng);
              controller.update();
            },
            onMapCreated: (GoogleMapController cont) {
              log(cont.mapId.toString());
              googleMapController = cont;
              mapcontroller.complete(cont);
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endContained,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            onPressed: () async {
              controller.getCurrentLocation();
            },
            child: const Icon(Icons.location_on_outlined),
          ),
        );
      },
    );
  }
}
