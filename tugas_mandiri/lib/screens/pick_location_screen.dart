import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({super.key});

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  LatLng? selectedLocation;

  static const LatLng initialPosition = LatLng(-6.200000, 106.816666);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi Kecelakaan'),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: initialPosition,
          zoom: 13,
        ),
        onTap: (LatLng position) {
          setState(() {
            selectedLocation = position;
          });
        },
        markers: selectedLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('lokasi_kecelakaan'),
                  position: selectedLocation!,
                  infoWindow: const InfoWindow(
                    title: 'Lokasi Kecelakaan',
                  ),
                ),
              },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (selectedLocation != null) {
            Navigator.pop(context, selectedLocation);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Pilih titik lokasi terlebih dahulu'),
              ),
            );
          }
        },
        icon: const Icon(Icons.check),
        label: const Text('Pilih Lokasi'),
      ),
    );
  }
}