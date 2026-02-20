import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  String selectedFilter = "For You";

  final List<Map<String, dynamic>> nearbyData = [
    {
      "title": "Kaziranga National Park",
      "location": "Assam",
      "image": "assets/kaziranga.webp",
      "category": "For You",
    },
    {
      "title": "Meghalaya Trek",
      "location": "Meghalaya",
      "image": "assets/kaziranga.webp",
      "category": "👀  See More",
    },
  ];

  final List<Map<String, dynamic>> vocalData = [
    {
      "title": "Majuli Island Pottery Workshop",
      "location": "Assam",
      "image": "assets/handicraft.jpg",
      "category": "Adventure",
    },
    {
      "title": "Assam Silk Weaving",
      "location": "Assam",
      "image": "assets/handicraft.jpg",
      "category": "Shopping",
    },
  ];

  List<Map<String, dynamic>> get filteredNearby {
    if (selectedFilter == "For You") return nearbyData;
    return nearbyData
        .where((item) => item["category"] == selectedFilter)
        .toList();
  }

  List<Map<String, dynamic>> get filteredVocal {
    if (selectedFilter == "For You") return vocalData;
    return vocalData
        .where((item) => item["category"] == selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    "Events Near You!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Cities, Homestays, Treks...",
                      icon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _chip("For You"),
                    _chip("Adventure"),
                    _chip("Stays"),
                    _chip("Shopping"),
                    _chip("Food"),
                    _chip("👀  See More"),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Nearby places",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 420,
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredNearby.length,
                  itemBuilder: (_, index) => _nearbyCard(filteredNearby[index]),
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                ),
              ),

              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Vocal for Local",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),

              const SizedBox(height: 14),
              SizedBox(
                height: 300,
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 20),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemCount: filteredVocal.length,
                  itemBuilder: (_, index) => _vocalCard(filteredVocal[index]),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(String text) {
    bool isSelected = selectedFilter == text;

    int count = filteredNearby.length + filteredVocal.length;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$count",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _nearbyCard(Map<String, dynamic> data) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Image.asset(
              data["image"],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 CONTENT
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Tags
                Row(
                  children: [
                    _tag("Safe place", const Color(0xFFE8ECF8)),
                    const SizedBox(width: 10),
                    _tag("Nature", const Color(0xFFF3E3E3)),
                  ],
                ),

                const SizedBox(height: 14),

                /// Title
                Text(
                  data["title"],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                /// Location
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 20, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text(
                      data["location"],
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
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

  Widget _avatarStack() {
    return SizedBox(
      width: 70,
      height: 40,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/user1.jpg"),
            ),
          ),
          Positioned(
            left: 22,
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/user2.jpg"),
            ),
          ),
          Positioned(
            left: 44,
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage("assets/user3.jpg"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vocalCard(Map<String, dynamic> data) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.asset(
              data["image"],
              width: 260,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["title"],
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 18, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(data["location"]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAG UI
  //   Widget _tag(String text, Color bg) {
  //     return Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //       decoration: BoxDecoration(
  //         color: bg,
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       child: Text(
  //         text,
  //         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  //       ),
  //     );
  //   }
  // }
  Widget _tag(String text, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
