import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'osm_map_page.dart'; // Import the OSM map page
import 'complaints_screen.dart'; // Import the complaints screen
import 'package:webview_flutter/webview_flutter.dart'; // Import WebView
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BaranguardDashboard extends StatelessWidget {
  final String username; // Pass username after login

  const BaranguardDashboard({super.key, required this.username});

  void navigateToComplaintScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ComplaintScreen()),
    );
  }

  void navigateToOSMMap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OSMMapPage()),
    );
  }

  void navigateToFacebookFeed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FacebookFeedPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: const Text(
          'Baranguard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red[900],
              ),
              child: const Text(
                'More Options',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('Requests'),
              onTap: () {
                Navigator.pop(context);
                print('Requests pressed');
              },
            ),
            ListTile(
              leading: const Icon(Icons.comment),
              title: const Text('Complaints'),
              onTap: () {
                Navigator.pop(context);
                navigateToComplaintScreen(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: const Text('Report'),
              onTap: () {
                Navigator.pop(context);
                navigateToOSMMap(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Mabalacat City News Feed'),
              onTap: () {
                Navigator.pop(context);
                navigateToFacebookFeed(context);
              },
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          buildDashboardItem(
            title: 'News and Updates',
            image: 'assets/images/news.png',
          ),
          const SizedBox(height: 20),
          buildDashboardItem(
            title: 'Emergency Assistance',
            image: 'assets/images/help.png',
          ),
        ],
      ),
    );
  }

  Widget buildDashboardItem({required String title, required String image}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class FacebookFeedPage extends StatelessWidget {
  const FacebookFeedPage({super.key});

  // Function to launch the Facebook feed in an external browser
  void _launchFacebookFeed() async {
    const url = 'https://google.com';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: const Text('Mabalacat City News'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchFacebookFeed,
          child: const Text('Open News Feed'),
        ),
      ),
    );
  }
}


