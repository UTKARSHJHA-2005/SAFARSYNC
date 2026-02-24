import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class FullMapPage extends StatefulWidget {
  const FullMapPage({super.key});

  @override
  State<FullMapPage> createState() => _FullMapPageState();
}

class _FullMapPageState extends State<FullMapPage> {
  late MapController controller;

  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  String distanceText = "";

  @override
  void initState() {
    super.initState();
    controller = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
    );
  }

  Future<void> calculateDistance() async {
    try {
      GeoPoint? source = await controller
          .addressSuggestion(sourceController.text)
          .then((value) => value.first);

      GeoPoint? destination = await controller
          .addressSuggestion(destinationController.text)
          .then((value) => value.first);

      if (source != null && destination != null) {
        double distance = await controller.distance2point(source, destination);

        setState(() {
          distanceText = "${(distance / 1000).toStringAsFixed(2)} km away 🚗";
        });

        await controller.drawRoad(
          source,
          destination,
          roadOption: const RoadOption(roadColor: Colors.blue, roadWidth: 8),
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// FULL MAP
          OSMFlutter(
            controller: controller,
            osmOption: const OSMOption(zoomOption: ZoomOption(initZoom: 14)),
          ),

          /// TOP SEARCH PANEL
          SafeArea(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _searchField(
                    controller: sourceController,
                    hint: "Enter source location",
                    icon: Icons.my_location,
                  ),
                  const SizedBox(height: 12),
                  _searchField(
                    controller: destinationController,
                    hint: "Enter destination",
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: calculateDistance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Show Route"),
                  ),

                  if (distanceText.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      distanceText,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          /// CLOSE BUTTON
          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
