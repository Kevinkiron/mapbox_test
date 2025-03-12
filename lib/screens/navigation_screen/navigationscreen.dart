import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:mapbox_test/helper/config.dart';
import 'package:mapbox_test/helper/controller.dart';
import 'package:mapbox_test/helper/globalfunction.dart';
import 'package:mapbox_test/utils/colors/colors.dart';
import 'package:mapbox_test/utils/reusable_widgets/kstyles.dart';
import 'package:mapbox_test/utils/reusable_widgets/reusable_buttons.dart';
import 'package:mapbox_test/utils/reusable_widgets/reusable_widgets.dart';
import 'package:mapbox_test/utils/reusable_widgets/reused_text.dart';
import 'package:mapbox_test/utils/spacing/spacing.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({
    super.key,
    required this.startLat,
    required this.startLong,
    required this.endLat,
    required this.endLong,
    required this.endlocation,
    required this.startlocation,
  });
  final double startLat;
  final double startLong;
  final double endLat;
  final double endLong;
  final String endlocation;
  final String startlocation;
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  MapboxMap? _mapboxMap;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((_) {
      _drawRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        toolbarHeight: height * .35,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryblue,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Kstyles().med(
              text: "YOUR LOCATION",
              fontStyle: FontStyle.italic,
              size: 12,
              color: AppColors.whitecolor,
            ),
            const Halfh(),
            Kstyles().bold(
              text: widget.startlocation,
              size: 20,
              color: AppColors.whitecolor,
            ),
            const Halfh(),
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.whitecolor),
                Heading12font500(
                  heading: "${widget.startLat},${widget.startLong}",
                  color: AppColors.whitecolor.withValues(alpha: .6),
                ),
              ],
            ),
            Threeh(),
            CustomLine(width: width * .8, color: AppColors.whitecolor),
            Threeh(),
            Kstyles().med(
              text: "DESTINATION",
              fontStyle: FontStyle.italic,
              size: 12,
              color: AppColors.whitecolor,
            ),
            const Halfh(),
            Kstyles().bold(
              text: widget.endlocation,
              size: 20,
              color: AppColors.whitecolor,
            ),
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.whitecolor),
                Heading12font500(
                  heading: "${widget.endLat},${widget.endLong}",
                  color: AppColors.whitecolor.withValues(alpha: .6),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: MapWidget(
              styleUri: MapboxStyles.STANDARD,
              mapOptions: MapOptions(
                contextMode: ContextMode.UNIQUE,
                pixelRatio: MediaQuery.of(context).devicePixelRatio,
              ),
              onMapCreated: _onMapCreated,
              cameraOptions: CameraOptions(
                center: Point(
                  coordinates: Position(
                    (widget.startLong + widget.endLong) / 2,
                    (widget.startLat + widget.endLat) / 2,
                  ),
                ),
                zoom: 12.0,
              ),
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
                      saveTrip(
                        startlatitude.value,
                        startlongitude.value,
                        endlatitude.value,
                        endlongitude.value,
                        context,
                        widget.startlocation,
                        widget.endlocation,
                      );
                    },
                    buttontitle: "Save",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _drawRoute();
  }

  void _drawRoute() async {
    if (_mapboxMap == null) return;

    List<Position> routeCoordinates = await _getRouteCoordinates();
    if (routeCoordinates.isNotEmpty) {
      // Add start point marker
      final startPointLayer = _createSymbolLayer(
        "start_point",
        Position(widget.startLong, widget.startLat),
      );
      await _mapboxMap!.style.addLayer(startPointLayer);

      // Add end point marker
      final endPointLayer = _createSymbolLayer(
        "end_point",
        Position(widget.endLong, widget.endLat),
      );
      await _mapboxMap!.style.addLayer(endPointLayer);

      // Add route line
      final routeSource = GeoJsonSource(
        id: "route_source",
        data: _createLineStringFromPositions(routeCoordinates),
      );
      await _mapboxMap!.style.addSource(routeSource);

      final routeLayer =
          LineLayer(id: "route_layer", sourceId: "route_source")
            ..lineColor = Colors.red.value
            ..lineWidth = 5.0;

      await _mapboxMap!.style.addLayer(routeLayer);

      // Fit bounds to show the entire route
      CameraOptions cameraOptions = _getCameraOptionsForBounds(
        routeCoordinates,
      );
      await _mapboxMap!.setCamera(cameraOptions);
    }
  }

  SymbolLayer _createSymbolLayer(String id, Position position) {
    // Create a GeoJson source for the marker
    GeoJsonSource source = GeoJsonSource(
      id: "${id}_source",
      data: """
        {
          "type": "Feature",
          "properties": {},
          "geometry": {
            "type": "Point",
            "coordinates": [${position.lng}, ${position.lat}]
          }
        }
      """,
    );

    _mapboxMap!.style.addSource(source);

    // Create a symbol layer for the marker
    return SymbolLayer(id: id, sourceId: "${id}_source")
      ..iconSize = 1.0
      ..iconImage = "marker";
  }

  String _createLineStringFromPositions(List<Position> positions) {
    final coordinates = positions.map((p) => [p.lng, p.lat]).toList();

    return """
      {
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "LineString",
          "coordinates": $coordinates
        }
      }
    """;
  }

  CameraOptions _getCameraOptionsForBounds(List<Position> positions) {
    double minLat = double.infinity;
    double minLng = double.infinity;
    double maxLat = -double.infinity;
    double maxLng = -double.infinity;

    for (var position in positions) {
      minLat = position.lat < minLat ? position.lat.toDouble() : minLat;
      minLng = position.lng < minLng ? position.lng.toDouble() : minLng;
      maxLat = position.lat > maxLat ? position.lat.toDouble() : maxLat;
      maxLng = position.lng > maxLng ? position.lng.toDouble() : maxLng;
    }

    minLat = widget.startLat < minLat ? widget.startLat : minLat;
    minLng = widget.startLong < minLng ? widget.startLong : minLng;
    maxLat = widget.endLat > maxLat ? widget.endLat : maxLat;
    maxLng = widget.endLong > maxLng ? widget.endLong : maxLng;

    double centerLat = (minLat + maxLat) / 2;
    double centerLng = (minLng + maxLng) / 2;

    double latDelta = maxLat - minLat;
    double lngDelta = maxLng - minLng;
    double zoomLevel = 12.0;

    if (latDelta > 0 || lngDelta > 0) {
      double maxDelta = latDelta > lngDelta ? latDelta : lngDelta;
      zoomLevel = 14 - (maxDelta * 100);
      zoomLevel = zoomLevel < 5 ? 5 : zoomLevel;
      zoomLevel = zoomLevel > 15 ? 15 : zoomLevel;
    }

    return CameraOptions(
      center: Point(coordinates: Position(centerLng, centerLat)),
      zoom: zoomLevel,
      padding: MbxEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
    );
  }

  Future<List<Position>> _getRouteCoordinates() async {
    String accessToken = mapboxtoken;
    String apiUrl =
        'https://api.mapbox.com/directions/v5/mapbox/driving/${widget.startLong},${widget.startLat};${widget.endLong},${widget.endLat}?steps=true&geometries=geojson&access_token=$accessToken';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> routes = data['routes'];
        if (routes.isNotEmpty) {
          Map<String, dynamic> route = routes[0];
          Map<String, dynamic> geometry = route['geometry'];
          List<dynamic> coordinates = geometry['coordinates'];

          List<Position> positions =
              coordinates
                  .map<Position>((point) => Position(point[0], point[1]))
                  .toList();

          return positions;
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
    return [];
  }
}
