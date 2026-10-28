import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Putu Indra Mahardika',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'NIM: 2415051003',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              const SizedBox(height: 4),
              const Text(
                'S1 Pendidikan Teknik Informatika',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Text(
                'Universitas Pendidikan Ganesha',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Divider(height: 32),
              const Text(
                'FindMyKos v1.0 (Singaraja Kos Finder)\nProject Ujian Tengah Semester Pemrograman Mobile',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
