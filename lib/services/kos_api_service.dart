import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kos_model.dart';

class KosApiService {
  // Menggunakan Endpoint Mock/Dummy JSON Kos Singaraja
  static const String _baseUrl =
      'https://raw.githubusercontent.com/putuindramahardika7-ship-it/worksheet4indra/main/kos_data.json';

  Future<List<Kos>> fetchKosCatalog() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Kos.fromJson(json)).toList();
      } else {
        // Fallback Mock Data jika endpoint REST API sedang offline/unreachable
        return _getMockKosData();
      }
    } catch (e) {
      // Fallback lokal agar data tetap tampil saat offline
      return _getMockKosData();
    }
  }

  List<Kos> _getMockKosData() {
    return [
      Kos(
        id: 'KOS-001',
        name: 'Kos Singaraja Asri 1',
        location: 'Jl. Udayana No. 12, Singaraja, Buleleng',
        pricePerMonth: 850000,
        imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500',
        facilities: ['AC', 'Wi-Fi 100Mbps', 'Kamar Mandi Dalam', 'Kasur Springbed'],
        description: 'Kos eksklusif khusus mahasiswa Undiksha. Dekat dengan kampus dan pusat kuliner.',
      ),
      Kos(
        id: 'KOS-002',
        name: 'Kos Kampus Undiksha Central',
        location: 'Jl. Ahmad Yani No. 45, Singaraja',
        pricePerMonth: 650000,
        imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=500',
        facilities: ['Wi-Fi', 'Kamar Mandi Luar', 'Kasur', 'Lemari Pakaian'],
        description: 'Kos tenang dan bersih, sangat cocok untuk mahasiswa yang butuh fokus belajar.',
      ),
      Kos(
        id: 'KOS-003',
        name: 'Kos Buleleng Comfort Suite',
        location: 'Jl. Gajah Mada No. 88, Singaraja',
        pricePerMonth: 1200000,
        imageUrl: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500',
        facilities: ['AC', 'Wi-Fi', 'Kamar Mandi Dalam', 'Dapur Bersama', 'CCTV 24 Jam'],
        description: 'Fasilitas lengkap serba ada dengan parkiran mobil dan motor yang luas.',
      ),
      Kos(
        id: 'KOS-004',
        name: 'Kos Student House Seririt',
        location: 'Jl. Raya Seririt, Buleleng',
        pricePerMonth: 550000,
        imageUrl: 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=500',
        facilities: ['Kipas Angin', 'Kasur', 'Lemari', 'Parkir Motor'],
        description: 'Harga terjangkau dengan tempat aman dan bersih di area strategis.',
      ),
    ];
  }
}