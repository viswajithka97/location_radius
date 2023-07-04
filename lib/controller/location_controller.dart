import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_radius/location_fetch.dart';

class LocationController extends GetxController {
  final geolocator =
      Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  Position? currentPosition;
  LatLng? currentAddress;
  String pincode = '';
  String locatlityName = '';
  String street = '';
  String country = '';
  String state = '';
  List<Placemark>? p;
  int? index;
  double? latitude;
  double? longitude;

  getCurrentLocation() async {
    try {
      // if () {

      // }
      Position position = await goToLocation();
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 20.0)));

      log(position.latitude.toString());
      log(position.longitude.toString());
      markers.clear();
      markers.add(Marker(
          markerId: const MarkerId('Current Location'),
          position: LatLng(position.latitude, position.longitude)));
      update();
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        // currentPosition = position;
        latitude = position.latitude;
        longitude = position.longitude;
        update();
        getAddressfromLatLang();
        update();
      }).catchError((e) {
        // log(e);
      });
    } catch (e) {
      if (e is LocationServiceDisabledException) {
        log(e.toString());
      }
    }
  }

  getAddressfromLatLang() async {
    try {
      p = await placemarkFromCoordinates(latitude!, longitude!);
      log(index.toString());
      Placemark place = index == null ? p![0] : p![index!];
      locatlityName = "${place.name}";
      // locatlity = "${place.locality}";
      street = "${place.street}";
      state = "${place.administrativeArea}";
      pincode = "${place.postalCode}";
      country = "${place.country}";
      log(place.toString());
      update();
      return p;
    } catch (e) {
      log(e.toString());
    }
  }

  onTapMarker(LatLng latLng) async {
    Marker newMarker = Marker(
      markerId: const MarkerId('new_marker'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(latLng.latitude, latLng.longitude),
    );
    markers.clear();
    markers.add(newMarker);
    latitude = latLng.latitude;
    longitude = latLng.longitude;
    update();
    getAddressfromLatLang();
    await _checkIfWithinBounds();
    update();
  }

  Future<bool> _checkIfWithinBounds() async {
    double distanceInMeters = Geolocator.distanceBetween(
      latitude!,
      longitude!,
      19.011259939007626,
      72.83739959985151,
    );
    double distanceInKm = distanceInMeters / 1000;
    if (distanceInKm <= 2) {
      print('The location is within a 2km radius of the prime location.');
      return true;
    } else {
      print('The location is outside the 2km radius of the prime location.');
      return false;
    }
  }

  Future<Position> goToLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location service is not enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission not granted');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return position;
  }
}
