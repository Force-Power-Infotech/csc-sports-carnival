import 'package:flutter/material.dart';
import 'package:rpgl/bases/api/sponsor.dart';
import 'package:rpgl/bases/themes.dart';
import 'package:rpgl/widgets/CustomWebView.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorScreen extends StatefulWidget {
  @override
  _SponsorScreenState createState() => _SponsorScreenState();
}

class _SponsorScreenState extends State<SponsorScreen> {
  late Future<SponsorsAPI> _sponsorsFuture;

  @override
  void initState() {
    super.initState();
    _sponsorsFuture = SponsorsAPI.sponsorslist();
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
            'Sponsors',
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
            onPressed: () {
              // Handle close action
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: AppThemes.getBackground(),
        elevation: 1,
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        child: Container(
          color: Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<SponsorsAPI>(
              future: _sponsorsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching sponsors'));
                } else if (!snapshot.hasData ||
                    snapshot.data!.sponsorsDetails == null ||
                    snapshot.data!.sponsorsDetails!.isEmpty) {
                  return const Center(child: Text('No sponsors available'));
                } else {
                  List<SponsorsDetails> sponsors =
                      snapshot.data!.sponsorsDetails!;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: sponsors.length,
                    itemBuilder: (context, index) {
                      return SponsorCard(sponsor: sponsors[index]);
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SponsorCard extends StatelessWidget {
  final SponsorsDetails sponsor;

  SponsorCard({required this.sponsor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {
          if (sponsor.website != null && sponsor.website!.isNotEmpty) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                  height:
                      MediaQuery.of(context).size.height * 0.9, // 90% height
                  child: CustomWebView(
                    initialUrl: sponsor.website!,
                    // title: sponsor.sponsor ?? 'Website',
                  ),
                );
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Website not available')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child:
                    sponsor.thumbnail != null && sponsor.thumbnail!.isNotEmpty
                        ? Image.network(
                            sponsor.thumbnail!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120,
                                color: Colors.grey,
                              );
                            },
                          )
                        : Container(
                            height: 120,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
              ),
              const SizedBox(height: 8),
              Text(
                sponsor.sponsor ?? 'No name',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.getBackground(),
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              // const SizedBox(height: 8),
              Text(
                sponsor.sponsorType ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text(
                sponsor.description ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
