import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_app/models/map_marker_model.dart';
import 'package:map_app/shared/components/components.dart';
import 'package:map_app/shared/components/constants.dart';

final _myLocation = LatLng(29.978605, 31.103532);
final _locations = [
  LatLng(29.964134, 31.094771),
  LatLng(29.986374, 31.105181),
  LatLng(29.968233, 31.096927),
  LatLng(29.978643, 31.120124),
  LatLng(29.978197, 31.091945),
];
final _mapMarkers = [
  MapMarkerModel(
      image: 'assets/images/place1.svg',
      title: 'Chinese food',
      address: '1355 Market Street Suite',
      location: _locations[0]),
  MapMarkerModel(
      image: 'assets/images/place2.svg',
      title: 'Fast food',
      address: '259 ELHaram Street',
      location: _locations[1]),
  MapMarkerModel(
      image: 'assets/images/place3.svg',
      title: 'Sandwich',
      address: '106 Street 4',
      location: _locations[2]),
  MapMarkerModel(
      image: 'assets/images/place4.svg',
      title: 'Burger',
      address: '100 B Street 1',
      location: _locations[3]),
  MapMarkerModel(
      image: 'assets/images/place5.svg',
      title: 'Pizza',
      address: 'ElTeseen Street',
      location: _locations[4]),
];

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final _pageViewController = PageController();
  int _selectedIndex = 0;
  late final AnimationController _animationController;

  List<Marker> _buildMarkers() {
    final _markerList = <Marker>[];
    for (int i = 0; i < _mapMarkers.length; i++) {
      final mapItem = _mapMarkers[i];
      _markerList.add(
        Marker(
          height: MARKER_SIZE_EXPANDED,
          width: MARKER_SIZE_EXPANDED,
          point: mapItem.location,
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                _selectedIndex = i;
                setState(() {
                  _pageViewController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                  );
                });
              },
              child: locationMarker(selected: _selectedIndex == i),
            );
          },
        ),
      );
    }

    return _markerList;
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _markers = _buildMarkers();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Map App'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_alt),
          )
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              minZoom: 5.0,
              maxZoom: 18.0,
              zoom: 13.0,
              center: _myLocation,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/{id}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': MAPBOX_ACCESS_TOKEN,
                  'id': MAPBOX_STYLE
                },
                // attributionBuilder: (_) {
                //   return Text("© OpenStreetMap contributors");
                // },
              ),
              MarkerLayerOptions(
                markers: _markers,
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    height: 60.0,
                    width: 60.0,
                    point: _myLocation,
                    builder: (ctx) => MyLocationMarker(_animationController),
                  ),
                ],
              ),
            ],
          ),

          // Add page view
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 20.0,
            height: MediaQuery.of(context).size.height * 0.3,
            child: PageView.builder(
              controller: _pageViewController,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = _mapMarkers[index];
                return mapItemDetails(mapMarker: item);
              },
              itemCount: _mapMarkers.length,
            ),
          ),
        ],
      ),
    );
  }
}
