import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_kos_model.dart';
import '../providers/kos_provider.dart';

class EditSavedKosScreen extends StatefulWidget {
  final SavedKos item;

  const EditSavedKosScreen({super.key, required this.item});

  @override
  State<EditSavedKosScreen> createState() => _EditSavedKosScreenState();
}

class _EditSavedKosScreenState extends State<EditSavedKosScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _noteController;
  late double _rating;
  late String _status;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.kosName);
    _noteController = TextEditingController(text: widget.item.note);
    _rating = widget.item.rating;
    _status = widget.item.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _update() async {
    if (_formKey.currentState!.validate() && widget.item.id != null) {
      final updatedItem = SavedKos(
        id: widget.item.id,
        studentId: widget.item.studentId,
        kosId: widget.item.kosId,
        kosName: _nameController.text.trim(),
        note: _noteController.text.trim(),
        rating: _rating,
        status: _status,
      );

      final success = await context
          .read<KosProvider>()
          .updateSavedKos(widget.item.id!, updatedItem);

      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Catatan survei kos berhasil diperbarui!'),
            backgroundColor: Colors.blue,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Gagal memperbarui: ${context.read<KosProvider>().savedError}'),
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
        title: const Text('Edit Catatan Kos'),
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
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama kos tidak boleh kosong';
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
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan tidak boleh kosong';
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
                  DropdownMenuItem(value: 'planned', child: Text('Planned')),
                  DropdownMenuItem(value: 'visited', child: Text('Visited')),
                  DropdownMenuItem(value: 'deal', child: Text('Deal')),
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
                  onPressed: kosProvider.isSaving ? null : _update,
                  child: kosProvider.isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Update Changes',
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