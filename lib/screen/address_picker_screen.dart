import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({super.key});

  @override
  State<AddressPickerScreen> createState() =>
      _AddressPickerScreenState();
}

class _AddressPickerScreenState
    extends State<AddressPickerScreen> {

  GoogleMapController? mapController;

  LatLng currentLocation =
      const LatLng(20.2961, 85.8245);

  LatLng selectedLocation =
      const LatLng(20.2961, 85.8245);

  String selectedAddress =
      "Fetching your location...";

  bool loading = true;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  //--------------------------------------------------
  // GET CURRENT LOCATION
  //--------------------------------------------------

  Future<void> getCurrentLocation() async {

    try {

      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {

        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please enable location service.",
            ),
          ),
        );

        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {

        permission =
            await Geolocator.requestPermission();
      }

      if (permission ==
              LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {

        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Location permission denied.",
            ),
          ),
        );

        return;
      }

      Position position =
          await Geolocator.getCurrentPosition(
        desiredAccuracy:
            LocationAccuracy.high,
      );

      currentLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      selectedLocation = currentLocation;

      await getAddress(
        position.latitude,
        position.longitude,
      );

      if (mapController != null) {

        mapController!.animateCamera(

          CameraUpdate.newCameraPosition(

            CameraPosition(

              target: currentLocation,

              zoom: 17,
            ),
          ),
        );
      }

      setState(() {
        loading = false;
      });

    } catch (e) {

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  //--------------------------------------------------
  // GET ADDRESS FROM LAT LNG
  //--------------------------------------------------

  Future<void> getAddress(
      double latitude,
      double longitude) async {

    try {

      List<Placemark> placemarks =
          await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {

        Placemark place =
            placemarks.first;

        selectedAddress =
            "${place.name ?? ""}, "
            "${place.street ?? ""}, "
            "${place.subLocality ?? ""}, "
            "${place.locality ?? ""}, "
            "${place.administrativeArea ?? ""}, "
            "${place.postalCode ?? ""}";
      }

    } catch (e) {

      selectedAddress =
          "Unable to fetch address";
    }

    if (mounted) {
      setState(() {});
    }
  }

  //--------------------------------------------------
  // BUILD
  //--------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xff0F172A),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
            const Color(0xff0F172A),

        title: const Text(
          "Select Pickup Address",
        ),

        actions: [

          IconButton(

            icon: const Icon(
              Icons.my_location,
            ),

            onPressed: () {

              setState(() {
                loading = true;
              });

              getCurrentLocation();
            },
          ),
        ],
      ),

      body: loading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : Column(

              children: [
                                //--------------------------------------------------
                // GOOGLE MAP
                //--------------------------------------------------

                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLocation,
                      zoom: 17,
                    ),

                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },

                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    compassEnabled: true,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: true,

                    markers: {
                      Marker(
                        markerId: const MarkerId("pickup"),

                        position: selectedLocation,

                        draggable: true,

                        infoWindow: const InfoWindow(
                          title: "Pickup Location",
                        ),

                        onDragEnd: (LatLng position) async {

                          selectedLocation = position;

                          await getAddress(
                            position.latitude,
                            position.longitude,
                          );

                          setState(() {});
                        },
                      ),
                    },

                    onTap: (LatLng position) async {

                      selectedLocation = position;

                      await getAddress(
                        position.latitude,
                        position.longitude,
                      );

                      setState(() {});
                    },
                  ),
                ),

                //--------------------------------------------------
                // ADDRESS CARD
                //--------------------------------------------------

                AnimatedContainer(

                  duration: const Duration(milliseconds: 400),

                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: const BoxDecoration(

                    color: Color(0xff111827),

                    borderRadius: BorderRadius.only(

                      topLeft: Radius.circular(30),

                      topRight: Radius.circular(30),
                    ),
                  ),

                  child: SafeArea(

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      mainAxisSize: MainAxisSize.min,

                      children: [

                        Row(

                          children: const [

                            Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 28,
                            ),

                            SizedBox(width: 8),

                            Text(

                              "Pickup Address",

                              style: TextStyle(

                                color: Colors.white,

                                fontSize: 22,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Container(

                          padding: const EdgeInsets.all(15),

                          decoration: BoxDecoration(

                            color: Colors.white10,

                            borderRadius:
                                BorderRadius.circular(15),
                          ),

                          child: Row(

                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              const Icon(
                                Icons.home,
                                color: Colors.blue,
                              ),

                              const SizedBox(width: 10),

                              Expanded(

                                child: Text(

                                  selectedAddress,

                                  style: const TextStyle(

                                    color: Colors.white70,

                                    fontSize: 15,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(

                          width: double.infinity,

                          height: 55,

                          child: ElevatedButton.icon(

                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),

                            label: const Text(

                              "Confirm Pickup Address",

                              style: TextStyle(

                                fontSize: 17,

                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            style:
                                ElevatedButton.styleFrom(

                              backgroundColor:
                                  Colors.blue,

                              shape:
                                  RoundedRectangleBorder(

                                borderRadius:
                                    BorderRadius.circular(
                                        15),
                              ),
                            ),

                            onPressed: () {

                              Navigator.pop(

                                context,

                                {

                                  "address":
                                      selectedAddress,

                                  "latitude":
                                      selectedLocation.latitude,

                                  "longitude":
                                      selectedLocation.longitude,
                                },
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        Center(

                          child: Text(

                            "Drag the marker or tap anywhere on the map",

                            style: TextStyle(

                              color: Colors.grey.shade400,

                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}