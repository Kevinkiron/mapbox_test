import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_test/helper/config.dart';
import 'package:mapbox_test/helper/trip.dart';
import 'package:mapbox_test/screens/home/homescreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(mapboxtoken);
  await Hive.initFlutter();
  Hive.registerAdapter(TripAdapter());
  await Hive.openBox<Trip>('trips');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
