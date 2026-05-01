import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/accident_report_model.dart';

class DetailScreen extends StatelessWidget {
  final AccidentReportModel report;

  const DetailScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final LatLng reportLocation = LatLng(
      report.latitude,
      report.longitude,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Laporan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            report.imageBase64.isNotEmpty
                ? Image.memory(
                    base64Decode(report.imageBase64),
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 220,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image, size: 50),
                  ),

            const SizedBox(height: 20),

            Text(
              report.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text('Alamat Lokasi: ${report.location}'),
            Text('Latitude: ${report.latitude}'),
            Text('Longitude: ${report.longitude}'),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: reportLocation,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('lokasi_kecelakaan'),
                    position: reportLocation,
                    infoWindow: const InfoWindow(
                      title: 'Lokasi Kecelakaan',
                    ),
                  ),
                },
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Keterangan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(report.description),
          ],
        ),
      ),
    );
  }
}