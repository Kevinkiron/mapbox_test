import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_test/helper/trip.dart';
import 'package:mapbox_test/screens/navigation_screen/navigationscreen.dart';
import 'package:mapbox_test/utils/colors/colors.dart';
import 'package:mapbox_test/utils/reusable_widgets/reusable_buttons.dart';
import 'package:mapbox_test/utils/reusable_widgets/reusable_widgets.dart';
import 'package:mapbox_test/utils/reusable_widgets/reused_text.dart';
import 'package:mapbox_test/utils/spacing/spacing.dart';

class TripListScreen extends StatelessWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      body: Column(
        children: [
          const TopHeaderSection(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Trip>('trips').listenable(),
              builder: (context, Box<Trip> box, _) {
                if (box.values.isEmpty) {
                  return const Center(child: Text('No trips added yet.'));
                }

                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final trip = box.getAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: width * .8,
                          height: height * .31,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primaryblue,
                              width: .3,
                            ),
                            color: AppColors.whitecolor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Fivew(),
                                  const Icon(Icons.location_on),
                                  const Threew(),
                                  Heading15font500(
                                    heading: "Trip -${index + 1}",
                                    color: AppColors.black,
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      box.deleteAt(index);
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const Fivew(),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  height: height * .2,
                                  width: width * .7,
                                  child: MapWidget(
                                    styleUri:
                                        MapboxStyles
                                            .STANDARD, // Or your preferred style
                                    mapOptions: MapOptions(
                                      contextMode: ContextMode.UNIQUE,
                                      pixelRatio:
                                          MediaQuery.of(
                                            context,
                                          ).devicePixelRatio,
                                    ),
                                    cameraOptions: CameraOptions(
                                      center: Point(
                                        coordinates: Position(76.9366, 8.5241),
                                      ),
                                      zoom: 13.0,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => NavigationScreen(
                                      startLat: trip!.startLat,
                                      startLong: trip.startLong,
                                      endLat: trip.endLat,
                                      endLong: trip.endLong,
                                      startlocation: trip.startlocation,
                                      endlocation: trip.endlocation,
                                    ),
                                  );
                                },
                                child: const Heading15font500(
                                  heading: "View Trip",
                                  color: AppColors.primaryblue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: width,
              height: height * .12,
              color: AppColors.primaryblue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NavigateButton(
                    onpressed: () {
                      Navigator.pop(context);
                    },
                    buttontitle: "Go Back",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
