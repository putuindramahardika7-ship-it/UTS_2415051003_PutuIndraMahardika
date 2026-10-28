import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_kos_model.dart';
import '../providers/kos_provider.dart';

class AddSavedKosScreen extends StatefulWidget {
  const AddSavedKosScreen({super.key});

  @override
  State<AddSavedKosScreen> createState() => _AddSavedKosScreenState();
}

class _AddSavedKosScreenState extends State<AddSavedKosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  double _rating = 4.0;
  String _status = 'planned';

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final newItem = SavedKos(
        studentId: '2415051003',
        kosId: 'CUSTOM-${DateTime.now().millisecondsSinceEpoch}',
        kosName: _nameController.text.trim(),
        note: _noteController.text.trim(),
        rating: _rating,
        status: _status,
      );

      final success = await context.read<KosProvider>().addSavedKos(newItem);

      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan survei kos berhasil ditambah!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambah data: ${context.read<KosProvider>().savedError}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final kosProvider = context.watch<KosProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan Kos Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kos *',
                  hintText: 'Misal: Kos Pondok Indah Singaraja',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kos wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Catatan Survei *',
                  hintText: 'Tuliskan lokasi, ibu kos, atau harga sepakat...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Rating Personal: ${_rating.toStringAsFixed(1)} / 5.0',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _rating,
                min: 1.0,
                max: 5.0,
                divisions: 8,
                label: _rating.toStringAsFixed(1),
                onChanged: (val) => setState(() => _rating = val),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  labelText: 'Status Kunjungan',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'planned', child: Text('Planned (Rencana)')),
                  DropdownMenuItem(value: 'visited', child: Text('Visited (Sudah Dilihat)')),
                  DropdownMenuItem(value: 'deal', child: Text('Deal (Sudah Disewa)')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _status = val);
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: kosProvider.isSaving ? null : _submit,
                  child: kosProvider.isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan Ke Database Supabase',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}