import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:group_project/map_model/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:group_project/map_model/map_constants.dart';
import 'package:latlong2/latlong.dart';
class FindUsersView extends StatefulWidget {
  const FindUsersView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FindUsersView> createState() => _FindUsersViewState();
}



class _FindUsersViewState extends State<FindUsersView> {
  late MapController mapController; // = MapController();
  late var currentLocation;
  bool locationLoaded = false;
  List<GeoLocation> mapMarkers = [];

  List<LatLng> polyline = [];
  late List<List<LatLng>> polylines;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _askForLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: locationLoaded ? FlutterMap(
        mapController: mapController,
        options: MapOptions(
            minZoom: 5,
            maxZoom: 18,
            zoom: 13,
            center: currentLocation ?? MapConstants.myLocation
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: MapConstants.mapBoxStyleId,
          ),
          MarkerLayerOptions(
              markers: [
                for( int i = 0; i < mapMarkers.length; i++)
                  Marker(
                      height: 40,
                      width: 40,
                      point: mapMarkers[i].latlng,
                      builder: (context) {
                        return Container(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                currentLocation = mapMarkers[i].latlng;
                              });
                            },
                            icon: Icon(Icons.circle),
                            color: Colors.red,
                            iconSize: 45,
                          ),
                        );
                      }
                  ),
              ]
          ),
        ],
      ) : Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }

  _updateLocationStream(Position userLocation) async{
    Position userLocation = await Geolocator.getCurrentPosition();
    setState(() {
      locationLoaded = true;
      currentLocation = LatLng(userLocation.latitude, userLocation.longitude);
    });
    /*E/flutter ( 4153): This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer or an animation callback.
E/flutter ( 4153): The preferred solution is to cancel the timer or stop listening to the animation in the dispose() callback. Another solution is to check the "mounted" property of this object before calling setState() to ensure the object is still in the tree.
E/flutter ( 4153): This error might indicate a memory leak if setState() is being called because another object is retaining a reference to this State object after it has been removed from the tree. To avoid memory leaks, consider breaking the reference to this object during dispose().*/
  }

  _askForLocation()async{
    await Geolocator.isLocationServiceEnabled().then((value) => null);
    await Geolocator.requestPermission().then((value) => null);
    await Geolocator.checkPermission().then(
            (LocationPermission permission)
        {
          print("Check Location Permission: $permission");
        }
    );
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best
      ),
    ).listen(_updateLocationStream);
  }
}
