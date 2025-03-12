import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_test/helper/places.dart';
import 'package:mapbox_test/helper/config.dart';

class HomeController extends GetxController {
  var startLocationController = TextEditingController();
  var endLocationController = TextEditingController();

  var startPlaces = <Place>[].obs;
  var endPlaces = <Place>[].obs;

  var startLatitude = 0.0.obs;
  var startLongitude = 0.0.obs;
  var endLatitude = 0.0.obs;
  var endLongitude = 0.0.obs;

  /// Search Places with Separate Lists for Start & End Locations
  void searchPlace(String query, {required bool isStartLocation}) async {
    if (query.isEmpty) return;

    String apiKey = mapboxtoken;
    String endpoint =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$apiKey';

    var response = await http.get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      List<Place> places = [];
      if (data['features'] != null) {
        places = List<Place>.from(
          data['features'].map((place) => Place.fromJson(place)),
        );
      }

      if (isStartLocation) {
        startPlaces.value = places;
      } else {
        endPlaces.value = places;
      }
    } else {
      print('Failed to fetch data: ${response.statusCode}');
    }
  }

  RxString startName = "".obs;
  RxString endName = "".obs;
  void setStartLocation(Place place) {
    startName.value = place.placeName;
    startLocationController.text = place.placeName;
    startLatitude.value = place.latitude;
    startLongitude.value = place.longitude;

    startPlaces.clear();
    Get.back();
  }

  void setEndLocation(Place place) {
    endName.value = place.placeName;
    endLocationController.text = place.placeName;
    endLatitude.value = place.latitude;
    endLongitude.value = place.longitude;
    endPlaces.clear();
    Get.back();
  }
}
