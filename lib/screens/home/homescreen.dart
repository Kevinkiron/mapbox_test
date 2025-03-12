import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapbox_test/screens/home/home_controller.dart';
import 'package:mapbox_test/helper/places.dart';
import 'package:mapbox_test/screens/navigation_screen/navigationscreen.dart';
import 'package:mapbox_test/screens/trip_screen/tripListscreen.dart';
import 'package:mapbox_test/utils/colors/colors.dart';
import 'package:mapbox_test/utils/reusable_widgets/custom_textfield.dart';
import 'package:mapbox_test/utils/reusable_widgets/kstyles.dart';
import 'package:mapbox_test/utils/reusable_widgets/reusable_buttons.dart';
import 'package:mapbox_test/utils/reusable_widgets/reusable_widgets.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TopHeaderSection(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap:
                              () => _showLocationDialog(
                                context,
                                "Start Location",
                                controller.startLocationController,
                                controller.startPlaces,
                                (query) => controller.searchPlace(
                                  query,
                                  isStartLocation: true,
                                ),
                                controller.setStartLocation,
                              ),
                          child: _locationBox(
                            controller.startName.isNotEmpty
                                ? controller.startName.value
                                : "Starting Location",
                          ),
                        ),
                      ),
                      Icon(Icons.connecting_airports_sharp),
                      Expanded(
                        child: GestureDetector(
                          onTap:
                              () => _showLocationDialog(
                                context,
                                "End Location",
                                controller.endLocationController,
                                controller.endPlaces,
                                (query) => controller.searchPlace(
                                  query,
                                  isStartLocation: false,
                                ),
                                controller.setEndLocation,
                              ),
                          child: _locationBox(
                            controller.endName.isNotEmpty
                                ? controller.endName.value
                                : "Ending Location",
                          ),
                        ),
                      ),
                    ],
                  );
                }),
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
                          Get.to(
                            () => NavigationScreen(
                              startLat: controller.startLatitude.value,
                              startLong: controller.startLongitude.value,
                              endLat: controller.endLatitude.value,
                              endLong: controller.endLongitude.value,
                              startlocation:
                                  controller.startLocationController.text,
                              endlocation:
                                  controller.endLocationController.text,
                            ),
                          );
                        },
                        buttontitle: "Navigate",
                      ),
                      NavigateButton(
                        onpressed: () {
                          Get.to(() => const TripListScreen());
                        },
                        buttontitle: "Saved",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationBox(String title) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: AppColors.black)),
      child: Center(child: Kstyles().med(text: title, size: 16)),
    );
  }

  void _showLocationDialog(
    BuildContext context,
    String hintText,
    TextEditingController controller,
    RxList<Place> places,
    Function(String) onChanged,
    Function(Place) onSelect,
  ) {
    Get.dialog(
      Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => _buildLocationBox(
                context,
                hintText,
                controller,
                places,
                onChanged,
                onSelect,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationBox(
    BuildContext context,
    String hintText,
    TextEditingController controller,
    RxList<Place> places,
    Function(String) onChanged,
    Function(Place) onSelect,
  ) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      width: width * .8,
      height: places.isEmpty ? height * .07 : height * .3,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryblue, width: .3),
        color: AppColors.whitecolor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on),
              SizedBox(
                height: height * .06,
                width: width * .6,
                child: CustomTextfieldTwo(
                  hintText: hintText,
                  controller: controller,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          places.isEmpty
              ? const SizedBox()
              : SizedBox(
                height: height * .23,
                child: ListView.builder(
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(places[index].placeName),
                      onTap: () => onSelect(places[index]),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
