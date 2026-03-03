import 'dart:ui';
import 'package:flutter/material.dart';

class StayVehicleDetailPage extends StatelessWidget {
  final String title;
  final String image;
  final String location;
  final double price;
  final String rating;
  final String category; // "stay" or "vehicle"

  const StayVehicleDetailPage({
    super.key,
    required this.title,
    required this.image,
    required this.location,
    required this.price,
    required this.rating,
    required this.category,
  });

  bool get isStay => category.toLowerCase() == "stays";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      body: CustomScrollView(
        slivers: [
          /// 🔥 HERO IMAGE
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.grey.shade300),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// 🔥 DETAILS SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Location + Rating
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        location,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Price Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          "₹$price",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9893FF),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isStay ? "/ night" : "/ day",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9893FF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 26,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            isStay ? "Book Stay" : "Rent Now",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Description
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isStay
                        ? "Experience comfort and culture combined. Enjoy authentic hospitality, beautiful surroundings, and peaceful stays tailored for travelers."
                        : "Reliable and well-maintained vehicle rental for smooth journeys. Flexible booking options and affordable pricing for your adventure.",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Features Section
                  const Text(
                    "Features",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: isStay ? _stayFeatures() : _vehicleFeatures(),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _stayFeatures() {
    return [
      _featureChip(Icons.wifi, "Free WiFi"),
      _featureChip(Icons.local_parking, "Parking"),
      _featureChip(Icons.restaurant, "Meals Included"),
      _featureChip(Icons.bed, "Comfort Rooms"),
    ];
  }

  List<Widget> _vehicleFeatures() {
    return [
      _featureChip(Icons.local_gas_station, "Fuel Efficient"),
      _featureChip(Icons.security, "Insurance Included"),
      _featureChip(Icons.speed, "Well Maintained"),
      _featureChip(Icons.support_agent, "24/7 Support"),
    ];
  }

  Widget _featureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9893FF)),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
