import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/event.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/bases/webservice.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late Future<List<EventDetails>?> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = fetchEvents();
  }

  Future<List<EventDetails>?> fetchEvents() async {
    try {
      EventAPI apiResponse = await EventAPI.eventlist();
      if (apiResponse.processStatus == "YES") {
        // Update here to "YES"
        return apiResponse.eventDetails;
      } else {
        // Handle API error message
        print(apiResponse.processMessage);
        return null;
      }
    } catch (e) {
      // Handle any other error
      print("Error fetching events: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.getBackground(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Events',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        backgroundColor: AppThemes.getBackground(),
        elevation: 1,
      ),
      body: FutureBuilder<List<EventDetails>?>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading events."));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No events found."));
          } else {
            // Display the list of events
            return _buildEventGrid(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildEventGrid(List<EventDetails> events) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      child: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            itemCount: events.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (BuildContext context, int index) {
              return _buildEventCard(context, events[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventDetails event) {
    return GestureDetector(
      onTap: () {
        // Handle card tap
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 8,
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.network(
                event.eventimage ?? "https://example.com/placeholder.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            // Event details
            Positioned(
              bottom: 20.0,
              left: 16.0,
              right: 16.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventname ?? "Unnamed Event",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.white.withOpacity(0.8)),
                      const SizedBox(width: 4.0),
                      Text(
                        event.date ?? "Unknown Date",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 14, color: Colors.white.withOpacity(0.8)),
                      const SizedBox(width: 4.0),
                      Text(
                        event.venue ?? "Unknown Location",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12.0,
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
}
