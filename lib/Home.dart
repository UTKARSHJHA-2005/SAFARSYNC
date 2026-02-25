import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:safarsync/Events.dart';
import 'package:safarsync/State.dart';
import 'dart:async';
import 'package:safarsync/User.dart';
import 'package:safarsync/notification.dart';
import 'package:safarsync/Eventpage.dart';
import 'package:safarsync/Wingman.dart';
import 'package:safarsync/Help.dart';
import 'package:safarsync/Map.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MapController mapController;

  @override
  void initState() {
    super.initState();

    // Initialize controller to start with user tracking (v1.2.7 API)
    mapController = MapController.withUserPosition(
      trackUserLocation: const UserTrackingOption(
        enableTracking: true,
        unFollowUser: false,
      ),
    );
  }

  bool _showBottomButtons = false;
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    mapController.dispose();
    super.dispose();
  }

  Future<void> _addSampleMarker() async {
    await mapController.addMarker(
      GeoPoint(latitude: 37.7749, longitude: -122.4194),
      markerIcon: const MarkerIcon(
        icon: Icon(Icons.location_on, size: 48, color: Colors.red),
      ),
    );
  }

  void _showSettingsPanel(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Settings",
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Settings",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  _settingsItem(
                    Icons.person,
                    "Profile",
                    Colors.blue,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfilePage()),
                    ),
                  ),
                  _settingsItem(
                    Icons.location_on,
                    "Change Location",
                    Colors.orange,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SelectStatePage(),
                        ),
                      );
                    },
                  ),
                  _settingsItem(
                    Icons.help_outline,
                    "Help",
                    Colors.purple,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HelpPage()),
                      );
                    },
                  ),
                  _settingsItem(
                    Icons.delete_outline,
                    "Delete Account",
                    Colors.red,
                  ),
                  _settingsItem(Icons.logout, "Logout", Colors.red),

                  const Spacer(),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  Widget _settingsItem(
    IconData icon,
    String title,
    Color colors, {
    VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          children: [
            Icon(icon, size: 22, color: colors),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const FullMapPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void _handleMapInteraction() {
      setState(() {
        _showBottomButtons = true;
      });

      _hideTimer?.cancel();

      _hideTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showBottomButtons = false;
          });
        }
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEAF2FF), Color(0xFF6B75FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Good Morning, SafarSync",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Montserrat",
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateTime.now().toString().substring(0, 10),
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            size: 26,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationPage(),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: const Text(
                              "3",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _showSettingsPanel(context),
                      child: const Icon(
                        Icons.settings,
                        size: 26,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _squareCard(
                        title: "Wingman",
                        subtitle: "Travel with AI",
                        image: "assets/wing.png",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChatPage()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _squareImageCard(
                        label: "",
                        place: "Assam",
                        images: [
                          "assets/assam.jpg",
                          "assets/kaziranga.webp",
                          "assets/handicraft.jpg",
                        ],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ProfilePage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: 366,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Events()),
                      );
                    },
                    child: _squareCard(
                      title: "Events Near You!",
                      subtitle: "Discover meetups & pop-up now.",
                      image: "assets/events.jpeg",
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(_createRoute());
                },
                child: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(150),
                  ),
                  child: Container(
                    color: Colors.black87,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          // child: GestureDetector(
                          //   behavior: HitTestBehavior.translucent,
                          //   onTap: _handleMapInteraction,
                          //   onScaleStart: (_) => _handleMapInteraction(),
                          child: OSMFlutter(
                            controller: mapController,
                            osmOption: OSMOption(
                              zoomOption: const ZoomOption(
                                initZoom: 14,
                                minZoomLevel: 3,
                                maxZoomLevel: 19,
                              ),
                              userLocationMarker: UserLocationMaker(
                                personMarker: const MarkerIcon(
                                  icon: Icon(
                                    Icons.person_pin_circle,
                                    color: Colors.blue,
                                    size: 56,
                                  ),
                                ),
                                directionArrowMarker: const MarkerIcon(
                                  icon: Icon(
                                    Icons.navigation,
                                    color: Colors.blue,
                                    size: 44,
                                  ),
                                ),
                              ),
                            ),
                            onMapMoved: (region) {
                              _handleMapInteraction();
                            },
                            onMapIsReady: (isReady) async {
                              if (isReady) {
                                try {
                                  await mapController.currentLocation();
                                } catch (e) {
                                  debugPrint('currentLocation error: $e');
                                }
                                await _addSampleMarker();
                              }
                            },
                          ),
                          // ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          bottom: _showBottomButtons ? 20 : -120,
                          left: 0,
                          right: 0,
                          child: bottomActionButtons(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionButton(
            icon: Icons.local_police,
            label: "Police",
            bg: Colors.white,
            iconColor: Colors.black,
          ),

          _sosMainButton(),

          _actionButton(
            icon: Icons.local_hospital,
            label: "Hospital",
            bg: Colors.white,
            iconColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color bg,
    required Color iconColor,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: bg.withOpacity(0.9),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 14)),
      ],
    );
  }

  Widget _sosMainButton() {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.redAccent,
      child: const Text(
        "SOS",
        style: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void showEmergencySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 50,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Report Emergency",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              _emItem(Icons.gavel, Colors.red, "Armed Robbery"),
              _emItem(Icons.sensor_door_outlined, Colors.yellow, "Break In"),
              _emItem(
                Icons.local_fire_department,
                Colors.orange,
                "Fire Outbreak",
              ),
              _emItem(Icons.local_hospital, Colors.green, "Medical Emergency"),
              _emItem(Icons.visibility, Colors.purple, "Suspicious Activity"),
              _emItem(Icons.call, Colors.blue, "Other Emergency"),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {},
                      child: const Text("Proceed"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _emItem(IconData icon, Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 15),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _squareCard({
    required String title,
    required String subtitle,
    required String image,
    VoidCallback? onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _squareImageCard({
    required String label,
    required String place,
    required List<String> images,
    VoidCallback? onPressed,
  }) {
    final PageController controller = PageController();
    final ValueNotifier<int> currentPage = ValueNotifier(0);

    Timer? timer;

    return StatefulBuilder(
      builder: (context, setState) {
        timer ??= Timer.periodic(const Duration(seconds: 3), (Timer t) {
          if (controller.hasClients) {
            int nextPage = currentPage.value + 1;
            if (nextPage >= images.length) {
              nextPage = 0;
            }
            controller.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );

            currentPage.value = nextPage;
          }
        });

        return GestureDetector(
          onTap: onPressed,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: controller,
                    itemCount: images.length,
                    onPageChanged: (index) {
                      currentPage.value = index;
                    },
                    itemBuilder: (context, index) {
                      return Image.asset(images[index], fit: BoxFit.cover);
                    },
                  ),

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          place,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _mapAction(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.9),
          radius: 20,
          child: Icon(icon, color: Colors.black),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _sosButton(BuildContext context) {
    return GestureDetector(
      onTap: () => showEmergencySheet(context),
      child: const CircleAvatar(
        radius: 40,
        backgroundColor: Colors.redAccent,
        child: Text(
          "SOS",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
