import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/kos_provider.dart';
import '../widgets/error_state_view.dart';
import '../widgets/kos_card.dart';
import 'kos_detail_screen.dart';

class KosCatalogScreen extends StatelessWidget {
  const KosCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final kosProvider = context.watch<KosProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Kos Singaraja'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              onChanged: (value) => kosProvider.setSearchQuery(value),
              decoration: InputDecoration(
                hintText: 'Cari nama kos atau lokasi...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: kosProvider.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => kosProvider.setSearchQuery(''),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),

            // Stream / Future State View (Loading, Error, Empty, List)
            Expanded(
              child: Builder(
                builder: (context) {
                  if (kosProvider.isLoadingCatalog) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (kosProvider.catalogError != null) {
                    return ErrorStateView(
                      message: kosProvider.catalogError!,
                      onRetry: kosProvider.loadCatalog,
                    );
                  }
                  final list = kosProvider.filteredCatalog;
                  if (list.isEmpty) {
                    return const ErrorStateView(
                      message: 'Kos yang Anda cari tidak ditemukan.',
                      icon: Icons.search_off,
                    );
                  }

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final kos = list[index];
                      return KosCard(
                        title: kos.name,
                        location: kos.location,
                        price: kos.pricePerMonth,
                        imageUrl: kos.imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KosDetailScreen(kos: kos),
                            ),
                          );
                        },
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
}