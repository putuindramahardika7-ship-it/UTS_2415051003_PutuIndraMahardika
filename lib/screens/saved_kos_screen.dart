import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/saved_kos_model.dart';
import '../providers/kos_provider.dart';
import '../widgets/error_state_view.dart';
import 'add_saved_kos_screen.dart';
import 'edit_saved_kos_screen.dart';

class SavedKosScreen extends StatelessWidget {
  const SavedKosScreen({super.key});

  void _confirmDelete(BuildContext context, SavedKos item) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "${item.kosName}" dari favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(dialogContext);
              if (item.id != null) {
                final success =
                    await context.read<KosProvider>().deleteSavedKos(item.id!);
                if (!context.mounted) return;
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data kos berhasil dihapus!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kosProvider = context.watch<KosProvider>();
    final savedList = kosProvider.filteredSavedKos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit & Catatan Kos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddSavedKosScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Filter Status Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(context, 'Semua', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip(context, 'Planned', 'planned'),
                  const SizedBox(width: 8),
                  _buildFilterChip(context, 'Visited', 'visited'),
                  const SizedBox(width: 8),
                  _buildFilterChip(context, 'Deal', 'deal'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Builder(
                builder: (context) {
                  if (kosProvider.isLoadingSaved) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (kosProvider.savedError != null) {
                    return ErrorStateView(
                      message: kosProvider.savedError!,
                      onRetry: kosProvider.loadSavedKos,
                    );
                  }
                  if (savedList.isEmpty) {
                    return const ErrorStateView(
                      message: 'Belum ada catatan kos tersimpan.',
                      icon: Icons.bookmark_border,
                    );
                  }

                  return ListView.builder(
                    itemCount: savedList.length,
                    itemBuilder: (context, index) {
                      final item = savedList[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(
                            item.kosName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Status: ${item.status.toUpperCase()} | Rating: ⭐ ${item.rating}\nCatatan: ${item.note}',
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditSavedKosScreen(item: item),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(context, item),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String value) {
    final provider = context.watch<KosProvider>();
    final isSelected = provider.selectedStatus == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) provider.setSelectedStatus(value);
      },
    );
  }
}