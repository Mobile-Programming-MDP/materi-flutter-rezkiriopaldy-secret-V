import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/accident_report_model.dart';
import '../services/accident_service.dart';
import 'add_report_screen.dart';
import 'detail_screen.dart';
import 'signin_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccidentService accidentService = AccidentService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Kecelakaan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await accidentService.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<AccidentReportModel>>(
        stream: accidentService.getReports(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data!;

          if (reports.isEmpty) {
            return const Center(child: Text('Belum ada laporan'));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: report.imageBase64.isNotEmpty
                      ? Image.memory(
                          base64Decode(report.imageBase64),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image),
                  title: Text(report.title),
                  subtitle: Text(report.location),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(report: report),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddReportScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}