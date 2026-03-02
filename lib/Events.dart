import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:safarsync/Eventpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyPlace {
  final String title;
  final String location;
  final String image;
  final String category;
  final String tag1;
  final String tag2;
  final String rating;

  // 🔥 Add these
  final String date;
  final String time;
  final String organizer;
  final String description;
  final double price;

  const NearbyPlace({
    required this.title,
    required this.location,
    required this.image,
    required this.category,
    required this.tag1,
    required this.tag2,
    required this.rating,
    required this.date,
    required this.time,
    required this.organizer,
    required this.description,
    required this.price,
  });
}

class VocalItem {
  final String title;
  final String location;
  final String image;
  final String category;
  final String emoji;

  // 🔥 Add these
  final String date;
  final String time;
  final String organizer;
  final String description;
  final double price;

  const VocalItem({
    required this.title,
    required this.location,
    required this.image,
    required this.category,
    required this.emoji,
    required this.date,
    required this.time,
    required this.organizer,
    required this.description,
    required this.price,
  });
}

class StayItem {
  final String name;
  final String location;
  final String image;
  final double price;
  final String rating;
  final String category;

  StayItem({
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.rating,
    required this.category,
  });

  factory StayItem.fromJson(Map<String, dynamic> json) {
    return StayItem(
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? '',
      price: double.parse(json['price'].toString()),
      rating: json['rating'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class Vehicle {
  final String name;
  final String type;
  final String image;
  final double price;
  final String rating;
  final String category;

  Vehicle({
    required this.name,
    required this.type,
    required this.image,
    required this.price,
    required this.rating,
    required this.category,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      image: json['image'] ?? '',
      price: double.parse(json['price'].toString()),
      rating: json['rating'] ?? '',
      category: json['category'] ?? '',
    );
  }
}

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> with TickerProviderStateMixin {
  String selectedFilter = 'For You';
  AnimationController? _fadeController;

  Animation<double> get _fadeAnimation => _fadeController != null
      ? CurvedAnimation(parent: _fadeController!, curve: Curves.easeOut)
      : const AlwaysStoppedAnimation(1.0);

  // static const List<NearbyPlace> _nearbyData = [
  //   NearbyPlace(
  //     title: 'Kaziranga\nNational Park',
  //     location: 'Assam, India',
  //     image: 'assets/kaziranga.webp',
  //     category: 'For You',
  //     tag1: 'Wildlife',
  //     tag2: 'Nature',
  //     rating: '4.9',
  //     date: '12 March 2026',
  //     time: '7:00 PM',
  //     organizer: 'SafarSync',
  //     description:
  //         'Explore the breathtaking wildlife of Kaziranga National Park with guided safari and cultural events.',
  //     price: 49.99,
  //   ),
  //   NearbyPlace(
  //     title: 'Meghalaya\nTrek',
  //     location: 'Meghalaya, India',
  //     image: 'assets/kaziranga.webp',
  //     category: '👀 See More',
  //     tag1: 'Adventure',
  //     tag2: 'Scenic',
  //     rating: '4.7',
  //     date: '20 April 2026',
  //     time: '6:30 AM',
  //     organizer: 'Adventure Club',
  //     description:
  //         'A thrilling trekking experience through waterfalls and living root bridges.',
  //     price: 29.99,
  //   ),
  // ];

  List<NearbyPlace> _nearbyData = [];
  bool _isLoading = true;

  static const List<List<Color>> _nearbyGradients = [
    [Color(0xFF1A3A2A), Color(0xFF2D6A4F)],
    [Color(0xFF1A2A3A), Color(0xFF2D4A6A)],
  ];

  // static const List<VocalItem> _vocalData = [
  //   VocalItem(
  //     title: 'Majuli Island\nPottery Workshop',
  //     location: 'Assam',
  //     image: 'assets/handicraft.jpg',
  //     category: 'Adventure',
  //     emoji: '🏺',
  //     date: '5 May 2026',
  //     time: '11:00 AM',
  //     organizer: 'Local Artisans',
  //     description:
  //         'Learn traditional pottery techniques from local craftsmen of Majuli.',
  //     price: 19.99,
  //   ),
  //   VocalItem(
  //     title: 'Assam Silk\nWeaving',
  //     location: 'Assam',
  //     image: 'assets/handicraft.jpg',
  //     category: 'Shopping',
  //     emoji: '🧵',
  //     date: '5 May 2026',
  //     time: '11:00 AM',
  //     organizer: 'Local Artisans',
  //     description:
  //         'Learn traditional pottery techniques from local craftsmen of Majuli.',
  //     price: 19.99,
  //   ),
  //   VocalItem(
  //     title: 'Bamboo Craft\nFestival',
  //     location: 'Tripura',
  //     image: 'assets/handicraft.jpg',
  //     category: 'Adventure',
  //     emoji: '🎋',
  //     date: '5 May 2026',
  //     time: '11:00 AM',
  //     organizer: 'Local Artisans',
  //     description:
  //         'Learn traditional pottery techniques from local craftsmen of Majuli.',
  //     price: 19.99,
  //   ),
  // ];

  List<VocalItem> _vocalData = [];
  bool _isVocalLoading = true;
  Future<List<VocalItem>> fetchVocals() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.3:3000/vocals'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map(
            (e) => VocalItem(
              title: e['title'] ?? '',
              location: e['location'] ?? '',
              image: e['image'] ?? '',
              category: e['category'] ?? '',
              emoji: e['emoji'] ?? '',
              date: e['date'] ?? '',
              time: e['time'] ?? '',
              organizer: e['organizer'] ?? '',
              description: e['description'] ?? '',
              price: double.tryParse(e['price'].toString()) ?? 0.0,
            ),
          )
          .toList();
    } else {
      throw Exception('Failed to load vocals');
    }
  }

  Future<void> loadVocals() async {
    try {
      final data = await fetchVocals();
      setState(() {
        _vocalData = data;
        _isVocalLoading = false;
      });
    } catch (e) {
      print("Error loading vocals: $e");
      setState(() {
        _isVocalLoading = false;
      });
    }
  }

  // static const List<StayItem> _stayData = [
  //   StayItem(
  //     title: "Ziro Valley\nHomestay",
  //     location: "Arunachal Pradesh",
  //     image: "assets/assam.jpg",
  //     rating: "4.8",
  //     category: "Stays",
  //     date: "Available Now",
  //     time: "Check-in 12 PM",
  //     organizer: "Local Host",
  //     description: "Experience traditional Apatani hospitality.",
  //     price: 59.99,
  //   ),
  // ];

  // static const List<VehicleItem> _vehicleData = [
  //   VehicleItem(
  //     title: "Royal Enfield",
  //     location: "Assam",
  //     image: "assets/assam.jpg",
  //     category: "Vehicle",
  //     type: "Bike Rental",
  //     price: 14.99,
  //   ),
  //   VehicleItem(
  //     title: "SUV Self Drive",
  //     location: "Meghalaya",
  //     image: "assets/assam.jpg",
  //     category: "Vehicle",
  //     type: "Car Rental",
  //     price: 39.99,
  //   ),
  // ];

  Future<List<StayItem>> fetchStays() async {
    final response = await http.get(Uri.parse('http://192.168.1.3:3000/stays'));
    final List data = json.decode(response.body);
    return data.map((e) => StayItem.fromJson(e)).toList();
  }

  static const List<List<Color>> _vocalPalettes = [
    [Color(0xFFFFF3E0), Color(0xFFE65100)],
    [Color(0xFFE8F5E9), Color(0xFF2E7D32)],
    [Color(0xFFE3F2FD), Color(0xFF1565C0)],
  ];

  static const List<String> _filterLabels = [
    'For You',
    'Adventure',
    'Stays',
    'Vehicle',
    'Shopping',
    'Food',
    '👀 See More',
  ];

  Future<List<NearbyPlace>> fetchEvents() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.3:3000/events'),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data
          .map(
            (e) => NearbyPlace(
              title: e['title'] ?? '',
              location: e['location'] ?? '',
              image: e['image'] ?? '',
              category: e['category'] ?? '',
              tag1: e['tag1'] ?? '',
              tag2: e['tag2'] ?? '',
              rating: e['rating'] ?? '',
              date: e['date'] ?? '',
              time: e['time'] ?? '',
              organizer: e['organizer'] ?? '',
              description: e['description'] ?? '',
              price: double.tryParse(e['price'].toString()) ?? 0.0,
            ),
          )
          .toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  List<NearbyPlace> get _filteredNearby {
    if (selectedFilter == 'For You') return _nearbyData;
    return _nearbyData.where((p) => p.category == selectedFilter).toList();
  }

  List<VocalItem> get _filteredVocal {
    if (selectedFilter == 'For You') return _vocalData;
    return _vocalData.where((v) => v.category == selectedFilter).toList();
  }

  List<Vehicle> _vehicles = [];
  bool _isVehicleLoading = true;
  Future<void> loadVehicles() async {
    try {
      final data = await fetchVehicles();
      setState(() {
        _vehicles = data;
        _isVehicleLoading = false;
      });
      print("Vehicles Loaded: ${data.length}");
    } catch (e) {
      print("Error loading vehicles: $e");

      setState(() {
        _isVehicleLoading = false;
      });
    }
  }

  Future<void> loadStays() async {
    try {
      final data = await fetchStays();

      setState(() {
        _stays = data;
        _isStayLoading = false;
      });
      print("Stays Loaded: ${data.length}");
    } catch (e) {
      print("Error loading stays: $e");

      setState(() {
        _isStayLoading = false;
      });
    }
  }

  List<StayItem> _stays = [];
  bool _isStayLoading = true;

  List<StayItem> get _filteredStays {
    if (selectedFilter == 'For You') return _stays;
    return _stays.where((s) => s.category == selectedFilter).toList();
  }

  // List<Vehicle> get _filteredVehicles {
  //   if (selectedFilter == 'For You') return _vehicleData;
  //   return _vehicleData.where((v) => v.category == selectedFilter).toList();
  // }

  // int get _totalCount =>
  //     _filteredNearby.length +
  //     _filteredVocal.length +
  //     _filteredStays.length +
  //     _filteredVehicles.length;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();

    loadEvents();
    loadVehicles();
    loadStays();
    loadVocals();
  }

  Future<void> loadEvents() async {
    try {
      final data = await fetchEvents();
      setState(() {
        _nearbyData = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading events: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Vehicle>> fetchVehicles() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.3:3000/vehicles'),
    );

    final List data = json.decode(response.body);
    return data.map((e) => Vehicle.fromJson(e)).toList();
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    super.dispose();
  }

  void _selectFilter(String filter) {
    setState(() => selectedFilter = filter);
    _fadeController?.reset();
    _fadeController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: const SizedBox(height: 20)),
            SliverToBoxAdapter(child: _buildFilterChips()),
            SliverToBoxAdapter(child: const SizedBox(height: 32)),
            SliverToBoxAdapter(
              child: _buildSectionLabel(
                'Nearby Places',
                'Explore wild corners',
                () {
                  final event = _nearbyData.first;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventsPage(
                        title: event.title,
                        image: event.image,
                        date: event.date,
                        time: event.time,
                        location: event.location,
                        organizer: event.organizer,
                        description: event.description,
                        price: event.price,
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildNearbyList()),
            SliverToBoxAdapter(child: const SizedBox(height: 36)),
            SliverToBoxAdapter(
              child: _buildSectionLabel(
                'Vocal for Local',
                'Handmade with pride',
                () {
                  final event = _vocalData.first;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventsPage(
                        title: event.title,
                        image: event.image,
                        date: event.date,
                        time: event.time,
                        location: event.location,
                        organizer: event.organizer,
                        description: event.description,
                        price: event.price,
                      ),
                    ),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildVocalList()),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
            SliverToBoxAdapter(
              child: _buildSectionLabel(
                'Homestays & Hotels',
                'Comfort meets culture',
                null,
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildStayList()),

            SliverToBoxAdapter(child: const SizedBox(height: 36)),

            SliverToBoxAdapter(
              child: _buildSectionLabel(
                'Vehicle Rentals',
                'Ride your journey',
                null,
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildVehicleList()),
          ],
        ),
      ),
    );
  }

  Widget _buildStayList() {
    if (_isStayLoading) {
      return const SizedBox(
        height: 300,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final items = _filteredStays;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _emptyState(),
      );
    }

    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (_, i) {
          final stay = items[i];

          return Container(
            width: 260,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      stay.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(18),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stay.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "₹${stay.price}/night",
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVehicleList() {
    if (_isVehicleLoading) {
      return const SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_vehicles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("No vehicles found"),
      );
    }

    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _vehicles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, i) {
          final vehicle = _vehicles[i];

          return Container(
            width: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  /// 🔹 Vehicle Image
                  Positioned.fill(
                    child: Image.network(
                      vehicle.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey.shade300),
                    ),
                  ),

                  Positioned.fill(
                    child: Container(
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
                  ),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_city_outlined,
                            size: 16,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vehicle.rating,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// 🔹 Vehicle Info Bottom
                  Positioned(
                    bottom: 18,
                    left: 18,
                    right: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),

                        /// Price
                        Text(
                          "₹${vehicle.price} / day",
                          style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF9893FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DISCOVER',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3.5,
                    color: Color(0xFF8A7E6E),
                  ),
                ),
                Text(
                  'Events Near You',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Color(0xFF1A1A1A),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: Color(0xFFB0A898),
              size: 22,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Cities, homestays, treks...',
                  hintStyle: TextStyle(color: Color(0xFFB0A898), fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filterLabels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final label = _filterLabels[i];
          final isSelected = selectedFilter == label;
          return GestureDetector(
            onTap: () => _selectFilter(label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF9893FF) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF4A4A4A),
                    ),
                  ),
                  if (isSelected) ...[const SizedBox(width: 8)],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(
    String title,
    String subtitle,
    VoidCallback? onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A1A),
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A7E6E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyList() {
    if (_isLoading) {
      return const SizedBox(
        height: 380,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final items = _filteredNearby; // ✅ USE FILTERED LIST

    if (items.isEmpty) {
      return _emptyState();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizedBox(
        height: 380,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: items.length, // ✅ FIXED
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (_, i) => _nearbyCard(items[i], i), // ✅ FIXED
        ),
      ),
    );
  }

  Widget _nearbyCard(NearbyPlace place, int index) {
    final gradients = _nearbyGradients[index % _nearbyGradients.length];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventsPage(
              title: place.title,
              image: place.image,
              date: place.date,
              time: place.time,
              location: place.location,
              organizer: place.organizer,
              description: place.description,
              price: place.price,
            ),
          ),
        );
      },
      child: Container(
        width: 290,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: gradients[0].withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  place.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradients),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        gradients[0].withOpacity(0.7),
                        gradients[0].withOpacity(0.95),
                      ],
                      stops: const [0.0, 0.3, 0.65, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 18,
                right: 18,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      color: Colors.white.withOpacity(0.2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFD700),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            place.rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 18,
                left: 18,
                child: Row(
                  children: [
                    _floatingTag(place.tag1),
                    const SizedBox(width: 8),
                    _floatingTag(place.tag2),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.title,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: Color(0xFFE8FF6A),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            place.location,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8FF6A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF1A1A1A),
                              size: 20,
                            ),
                          ),
                        ],
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

  Widget _floatingTag(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: Colors.white.withOpacity(0.2),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVocalList() {
    final items = _filteredVocal;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _emptyState(),
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizedBox(
        height: 220,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, i) => _vocalCard(items[i], i),
        ),
      ),
    );
  }

  Widget _vocalCard(VocalItem item, int index) {
    final palette = _vocalPalettes[index % _vocalPalettes.length];
    final bg = palette[0];
    final accent = palette[1];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventsPage(
              title: item.title,
              image: item.image,
              date: item.date,
              time: item.time,
              location: item.location,
              organizer: item.organizer,
              description: item.description,
              price: item.price,
            ),
          ),
        );
      },
      child: Container(
        width: 190,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Stack(
                children: [
                  Image.network(
                    item.image,
                    height: 110,
                    width: 190,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 110,
                      color: accent.withOpacity(0.15),
                      child: Center(
                        child: Text(
                          item.emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.emoji,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: accent,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: accent.withOpacity(0.6),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        item.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: accent.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🌿', style: TextStyle(fontSize: 36)),
            SizedBox(height: 10),
            Text(
              'Nothing here yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF8A7E6E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
