import 'package:flutter/material.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> events = [
      {
        "title": "Music Concert 2026",
        "date": "March 15, 2026",
        "location": "New York City",
        "description":
            "Join us for an unforgettable night filled with live performances and entertainment.",
        "image": "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2",
      },
      {
        "title": "Tech Conference",
        "date": "April 10, 2026",
        "location": "San Francisco",
        "description":
            "Explore the future of technology with industry leaders and innovators.",
        "image": "https://images.unsplash.com/photo-1551836022-d5d88e9218df",
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Upcoming Events"), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.network(
                    event["image"]!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event["title"]!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16),
                          const SizedBox(width: 5),
                          Text(event["date"]!),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 5),
                          Text(event["location"]!),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        event["description"]!,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Booked ${event["title"]} successfully!",
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Book Now"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
