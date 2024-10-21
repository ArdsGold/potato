import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OSMMapPage extends StatefulWidget {
  const OSMMapPage({super.key});

  @override
  _OSMMapPageState createState() => _OSMMapPageState();
}

class _OSMMapPageState extends State<OSMMapPage> {
  late final MapController _mapController; // Map controller for zoom controls
  double _currentZoom = 13.0; // Initial zoom level
  LatLng? _currentLocation; // User's current location
  List<LatLng> _routePoints = []; // Route points

  @override
  void initState() {
    super.initState();
    _mapController = MapController(); // Initialize map controller
    _getCurrentLocation(); // Get user's current location
  }

  // Get the user's current location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapController.move(_currentLocation!, _currentZoom);
    });
  }

  // Fetch route from OSRM API
  Future<void> _fetchRoute(LatLng start, LatLng end) async {
    final url =
        'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

      setState(() {
        _routePoints = coordinates
            .map((coord) => LatLng(coord[1], coord[0])) // Reverse lat/lng order
            .toList();
      });
    } else {
      // Handle API errors (e.g., show a snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch route')),
      );
    }
  }

  // Zoom in function
  void _zoomIn() {
    setState(() {
      _currentZoom++;
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  // Zoom out function
  void _zoomOut() {
    setState(() {
      _currentZoom--;
      _mapController.move(_mapController.center, _currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    final LatLng destination = LatLng(15.0721, 120.5434); // Target location

    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenStreetMap with Navigation'),
        actions: [
          IconButton(icon: const Icon(Icons.zoom_in), onPressed: _zoomIn),
          IconButton(icon: const Icon(Icons.zoom_out), onPressed: _zoomOut),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(15.0721, 120.5434),
          zoom: _currentZoom,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              if (_currentLocation != null)
                Marker(
                  point: _currentLocation!,
                  width: 80,
                  height: 80,
                  builder: (ctx) => const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
            ],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.directions),
        onPressed: () {
          if (_currentLocation != null) {
            _fetchRoute(_currentLocation!, destination); // Fetch route when button is pressed
          }
        },
      ),
    );
  }
}