import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() =>
      _PickLocationScreenState();
}

class _PickLocationScreenState
    extends State<PickLocationScreen> {

  GoogleMapController? mapController;

  final searchC = TextEditingController();

  LatLng selectedLatLng =  const LatLng(52.5200, 13.4050);

  bool loading = false;

  String selectedAddress =  "Loading address...";

  Marker get marker => Marker(
    markerId: const MarkerId("site"),
    position: selectedLatLng,
  );

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    if (permission == LocationPermission.deniedForever) return;

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        selectedLatLng = LatLng(position.latitude, position.longitude);
      });
      
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLatLng, 15),
      );
      getAddress();
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  Future<void> searchLocation() async {
    try {
      final query = searchC.text.trim();

      if (query.isEmpty) return;
      
      FocusScope.of(context).unfocus();

      setState(() => loading = true);

      final result =
      await locationFromAddress(query);

      if (result.isNotEmpty) {
        final loc = result.first;

        setState(() {
          selectedLatLng = LatLng(
            loc.latitude,
            loc.longitude,
          );
        });

        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            selectedLatLng,
            16,
          ),
        );

        await getAddress();
      }

      loading = false;
      setState(() {});
    } catch (e) {
      setState(() => loading = false);

      Get.snackbar(
        "Error",
        "Location not found",
      );
    }
  }


  Future<void> getAddress() async {
    try {
      final places =
      await placemarkFromCoordinates(
        selectedLatLng.latitude,
        selectedLatLng.longitude,
      );

      if (places.isNotEmpty) {
        final p = places.first;

        selectedAddress =
        "${p.street}, ${p.locality}, ${p.administrativeArea}, ${p.country}";
      } else {
        selectedAddress =
        "${selectedLatLng.latitude}, ${selectedLatLng.longitude}";
      }
    } catch (e) {
      selectedAddress =
      "${selectedLatLng.latitude}, ${selectedLatLng.longitude}";
    }

    setState(() {});
  }


  Future<void> onTapMap(
      LatLng value) async {
    selectedLatLng = value;

    await getAddress();

    setState(() {});
  }

  void saveLocation() {
    Get.back(
      result: {
        "lat": selectedLatLng.latitude,
        "lng": selectedLatLng.longitude,
        "address": selectedAddress,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
        
            /// MAP
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedLatLng,
                zoom: 14,
              ),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              buildingsEnabled: true,
              trafficEnabled: false,
              indoorViewEnabled: true,
              compassEnabled: true,
              zoomControlsEnabled: true,
              markers: {marker},
              onMapCreated: (controller) {
                mapController = controller;
              },
              onTap: onTapMap,
            ),
        
            /// SEARCH BOX
            Positioned(
              top: 50,
              left: 15,
              right: 15,
              child: Material(
                elevation: 5,
                borderRadius:
                BorderRadius.circular(12),
                child: TextField(
                  controller: searchC,
                  onSubmitted: (_) =>
                      searchLocation(),
                  decoration:
                  InputDecoration(
                    hintText:
                    "Search city / address",
                    suffixIcon:
                    IconButton(
                      icon: const Icon(
                          Icons.search),
                      onPressed:
                      searchLocation,
                    ),
                    border:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(
                          12),
                      borderSide:
                      BorderSide.none,
                    ),
                    filled: true,
                    fillColor:
                    Colors.white,
                  ),
                ),
              ),
            ),
        
            /// ADDRESS BOX
            Positioned(
              bottom: 85,
              left: 15,
              right: 15,
              child: Container(
                padding:
                const EdgeInsets.all(
                    12),
                decoration:
                BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                      12),
                ),
                child: Text(
                  selectedAddress,
                  textAlign:
                  TextAlign.center,
                  maxLines: 2,
                  overflow:
                  TextOverflow
                      .ellipsis,
                ),
              ),
            ),
        
            /// SAVE BUTTON
            Positioned(
              bottom: 20,
              left: 15,
              right: 15,
              child: ElevatedButton(
                onPressed: saveLocation,
                child: loading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth:
                    2,
                    color: Colors
                        .white,
                  ),
                )
                    : const Text(
                    "Save Location"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}