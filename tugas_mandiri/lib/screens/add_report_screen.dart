import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../models/accident_report_model.dart';
import '../services/accident_service.dart';
import 'pick_location_screen.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  final AccidentService accidentService = AccidentService();

  XFile? selectedImage;
  double? latitude;
  double? longitude;

  bool isLoading = false;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 10,
      maxWidth: 300,
      maxHeight: 300,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile;
      });
    }
  }

  Future<void> pickLocationFromMap() async {
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PickLocationScreen(),
      ),
    );

    if (result != null) {
      latitude = result.latitude;
      longitude = result.longitude;

      try {
        final placemarks = await placemarkFromCoordinates(
          result.latitude,
          result.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;

          locationController.text =
              '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}';
        } else {
          locationController.text =
              '${result.latitude}, ${result.longitude}';
        }
      } catch (e) {
        locationController.text =
            '${result.latitude}, ${result.longitude}';
      }

      setState(() {});
    }
  }

  Future<void> submitReport() async {
    if (selectedImage == null ||
        titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        locationController.text.trim().isEmpty ||
        latitude == null ||
        longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto, judul, keterangan, dan lokasi wajib diisi'),
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final String id = const Uuid().v4();

      final bytes = await selectedImage!.readAsBytes();

      if (bytes.length > 500000) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto terlalu besar, pilih foto lain'),
          ),
        );

        setState(() => isLoading = false);
        return;
      }

      final String imageBase64 = base64Encode(bytes);

      final report = AccidentReportModel(
        id: id,
        userId: accidentService.currentUser!.uid,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        location: locationController.text.trim(),
        latitude: latitude!,
        longitude: longitude!,
        imageBase64: imageBase64,
        createdAt: DateTime.now(),
      );

      await accidentService.addReport(report);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil dikirim')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim laporan: $e')),
      );
    }

    setState(() => isLoading = false);
  }

  Widget imagePreview() {
    if (selectedImage == null) {
      return Container(
        height: 180,
        width: double.infinity,
        color: Colors.grey.shade300,
        child: const Icon(
          Icons.camera_alt,
          size: 50,
        ),
      );
    }

    if (kIsWeb) {
      return Image.network(
        selectedImage!.path,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Image.file(
      File(selectedImage!.path),
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Laporan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            imagePreview(),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: isLoading ? null : pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('Pilih Foto'),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: titleController,
              enabled: !isLoading,
              decoration: const InputDecoration(
                labelText: 'Judul Laporan',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              enabled: !isLoading,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Keterangan Kecelakaan',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: locationController,
              enabled: !isLoading,
              maxLines: 2,
              readOnly: false,
              decoration: const InputDecoration(
                labelText: 'Alamat Lokasi Kejadian',
                hintText: 'Pilih dari Google Maps atau ketik manual',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: isLoading ? null : pickLocationFromMap,
              icon: const Icon(Icons.map),
              label: const Text('Pilih Lokasi dari Google Maps'),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: isLoading ? null : submitReport,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Kirim Laporan'),
            ),
          ],
        ),
      ),
    );
  }
}