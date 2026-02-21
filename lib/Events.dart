// import 'package:flutter/material.dart';

// class Events extends StatefulWidget {
//   const Events({super.key});

//   @override
//   State<Events> createState() => _EventsState();
// }

// class _EventsState extends State<Events> {
//   String selectedFilter = "For You";

//   final List<Map<String, dynamic>> nearbyData = [
//     {
//       "title": "Kaziranga National Park",
//       "location": "Assam",
//       "image": "assets/kaziranga.webp",
//       "category": "For You",
//     },
//     {
//       "title": "Meghalaya Trek",
//       "location": "Meghalaya",
//       "image": "assets/kaziranga.webp",
//       "category": "👀  See More",
//     },
//   ];

//   final List<Map<String, dynamic>> vocalData = [
//     {
//       "title": "Majuli Island Pottery Workshop",
//       "location": "Assam",
//       "image": "assets/handicraft.jpg",
//       "category": "Adventure",
//     },
//     {
//       "title": "Assam Silk Weaving",
//       "location": "Assam",
//       "image": "assets/handicraft.jpg",
//       "category": "Shopping",
//     },
//   ];

//   List<Map<String, dynamic>> get filteredNearby {
//     if (selectedFilter == "For You") return nearbyData;
//     return nearbyData
//         .where((item) => item["category"] == selectedFilter)
//         .toList();
//   }

//   List<Map<String, dynamic>> get filteredVocal {
//     if (selectedFilter == "For You") return vocalData;
//     return vocalData
//         .where((item) => item["category"] == selectedFilter)
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),

//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: const Icon(Icons.arrow_back),
//                   ),
//                   const Text(
//                     "Events Near You!",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.refresh_rounded),
//                   ),
//                 ],
//               ),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: const TextField(
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: "Search Cities, Homestays, Treks...",
//                       icon: Icon(Icons.search),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 15),

//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Wrap(
//                   spacing: 12,
//                   runSpacing: 12,
//                   children: [
//                     _chip("For You"),
//                     _chip("Adventure"),
//                     _chip("Stays"),
//                     _chip("Shopping"),
//                     _chip("Food"),
//                     _chip("👀  See More"),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Text(
//                   "Nearby places",
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
//                 ),
//               ),
//               const SizedBox(height: 14),
//               SizedBox(
//                 height: 350,
//                 child: ListView.separated(
//                   padding: const EdgeInsets.only(left: 20),
//                   scrollDirection: Axis.horizontal,
//                   itemCount: filteredNearby.length,
//                   itemBuilder: (_, index) => _nearbyCard(filteredNearby[index]),
//                   separatorBuilder: (_, __) => const SizedBox(width: 16),
//                 ),
//               ),

//               const SizedBox(height: 30),
//               const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Text(
//                   "Vocal for Local",
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
//                 ),
//               ),

//               const SizedBox(height: 14),
//               SizedBox(
//                 height: 300,
//                 child: ListView.separated(
//                   padding: const EdgeInsets.only(left: 20),
//                   scrollDirection: Axis.horizontal,
//                   separatorBuilder: (_, __) => const SizedBox(width: 16),
//                   itemCount: filteredVocal.length,
//                   itemBuilder: (_, index) => _vocalCard(filteredVocal[index]),
//                 ),
//               ),

//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _chip(String text) {
//     bool isSelected = selectedFilter == text;

//     int count = filteredNearby.length + filteredVocal.length;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedFilter = text;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue : Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(30),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               text,
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 color: isSelected ? Colors.white : Colors.black,
//               ),
//             ),
//             if (isSelected) ...[
//               const SizedBox(width: 8),
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//                 child: Text(
//                   "$count",
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _nearbyCard(Map<String, dynamic> data) {
//     return Container(
//       width: 300,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(28),
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// 🔹 IMAGE
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
//             child: Image.asset(
//               data["image"],
//               height: 200,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),

//           /// CONTENT
//           Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Tags
//                 Row(
//                   children: [
//                     _tag("Safe place", const Color(0xFFE8ECF8)),
//                     const SizedBox(width: 10),
//                     _tag("Nature", const Color(0xFFF3E3E3)),
//                   ],
//                 ),

//                 const SizedBox(height: 14),

//                 /// Title
//                 Text(
//                   data["title"],
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 /// Location
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 20, color: Colors.blue),
//                     const SizedBox(width: 6),
//                     Text(
//                       data["location"],
//                       style: const TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _avatarStack() {
//     return SizedBox(
//       width: 70,
//       height: 40,
//       child: Stack(
//         children: [
//           Positioned(
//             left: 0,
//             child: CircleAvatar(
//               radius: 18,
//               backgroundImage: AssetImage("assets/user1.jpg"),
//             ),
//           ),
//           Positioned(
//             left: 22,
//             child: CircleAvatar(
//               radius: 18,
//               backgroundImage: AssetImage("assets/user2.jpg"),
//             ),
//           ),
//           Positioned(
//             left: 44,
//             child: CircleAvatar(
//               radius: 18,
//               backgroundImage: AssetImage("assets/user3.jpg"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _vocalCard(Map<String, dynamic> data) {
//     return Container(
//       width: 260,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: Colors.black12),
//         color: Colors.white,
//       ),
//       child: Column(
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//             child: Image.asset(
//               data["image"],
//               width: 260,
//               height: 150,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   data["title"],
//                   style: const TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on, size: 18, color: Colors.blue),
//                     const SizedBox(width: 4),
//                     Text(data["location"]),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // TAG UI
//   //   Widget _tag(String text, Color bg) {
//   //     return Container(
//   //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//   //       decoration: BoxDecoration(
//   //         color: bg,
//   //         borderRadius: BorderRadius.circular(20),
//   //       ),
//   //       child: Text(
//   //         text,
//   //         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//   //       ),
//   //     );
//   //   }
//   // }
//   Widget _tag(String text, Color bg) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Text(
//         text,
//         style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'dart:ui';

// ─── Typed Models ─────────────────────────────────────────────────────────────

class NearbyPlace {
  final String title;
  final String location;
  final String image;
  final String category;
  final String tag1;
  final String tag2;
  final String rating;

  const NearbyPlace({
    required this.title,
    required this.location,
    required this.image,
    required this.category,
    required this.tag1,
    required this.tag2,
    required this.rating,
  });
}

class VocalItem {
  final String title;
  final String location;
  final String image;
  final String category;
  final String emoji;

  const VocalItem({
    required this.title,
    required this.location,
    required this.image,
    required this.category,
    required this.emoji,
  });
}

// ─── Widget ───────────────────────────────────────────────────────────────────

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

  static const List<NearbyPlace> _nearbyData = [
    NearbyPlace(
      title: 'Kaziranga\nNational Park',
      location: 'Assam, India',
      image: 'assets/kaziranga.webp',
      category: 'For You',
      tag1: 'Wildlife',
      tag2: 'Nature',
      rating: '4.9',
    ),
    NearbyPlace(
      title: 'Meghalaya\nTrek',
      location: 'Meghalaya, India',
      image: 'assets/kaziranga.webp',
      category: '👀 See More',
      tag1: 'Adventure',
      tag2: 'Scenic',
      rating: '4.7',
    ),
  ];

  static const List<List<Color>> _nearbyGradients = [
    [Color(0xFF1A3A2A), Color(0xFF2D6A4F)],
    [Color(0xFF1A2A3A), Color(0xFF2D4A6A)],
  ];

  static const List<VocalItem> _vocalData = [
    VocalItem(
      title: 'Majuli Island\nPottery Workshop',
      location: 'Assam',
      image: 'assets/handicraft.jpg',
      category: 'Adventure',
      emoji: '🏺',
    ),
    VocalItem(
      title: 'Assam Silk\nWeaving',
      location: 'Assam',
      image: 'assets/handicraft.jpg',
      category: 'Shopping',
      emoji: '🧵',
    ),
    VocalItem(
      title: 'Bamboo Craft\nFestival',
      location: 'Tripura',
      image: 'assets/handicraft.jpg',
      category: 'Adventure',
      emoji: '🎋',
    ),
  ];

  static const List<List<Color>> _vocalPalettes = [
    [Color(0xFFFFF3E0), Color(0xFFE65100)],
    [Color(0xFFE8F5E9), Color(0xFF2E7D32)],
    [Color(0xFFE3F2FD), Color(0xFF1565C0)],
  ];

  static const List<String> _filterLabels = [
    'For You',
    'Adventure',
    'Stays',
    'Shopping',
    'Food',
    '👀  See More',
  ];

  List<NearbyPlace> get _filteredNearby {
    if (selectedFilter == 'For You') return _nearbyData;
    return _nearbyData.where((p) => p.category == selectedFilter).toList();
  }

  List<VocalItem> get _filteredVocal {
    if (selectedFilter == 'For You') return _vocalData;
    return _vocalData.where((v) => v.category == selectedFilter).toList();
  }

  int get _totalCount => _filteredNearby.length + _filteredVocal.length;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
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
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildNearbyList()),
            SliverToBoxAdapter(child: const SizedBox(height: 36)),
            SliverToBoxAdapter(
              child: _buildSectionLabel(
                'Vocal for Local',
                'Handmade with pride',
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildVocalList()),
            const SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
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
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(237, 245, 126, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_totalCount',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String title, String subtitle) {
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
          const Spacer(),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
            ),
            child: const Text(
              'See all →',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyList() {
    final items = _filteredNearby;
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizedBox(
        height: 380,
        child: items.isEmpty
            ? _emptyState()
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) => _nearbyCard(items[i], i),
              ),
      ),
    );
  }

  Widget _nearbyCard(NearbyPlace place, int index) {
    final gradients = _nearbyGradients[index % _nearbyGradients.length];
    return Container(
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
              child: Image.asset(
                place.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradients,
                    ),
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: items.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _emptyState(),
            )
          : SizedBox(
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
    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                Image.asset(
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
