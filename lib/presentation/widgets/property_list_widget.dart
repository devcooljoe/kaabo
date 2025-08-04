import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaabo/presentation/providers/property_provider.dart';

import '../providers/property_stream_provider.dart';

class PropertyListWidget extends ConsumerWidget {
  const PropertyListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(propertyStreamProvider);

    return propertiesAsync.when(
      data:
          (properties) => ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return ListTile(
                title: Text(property.title),
                subtitle: Text('₦${property.price}'),
                // Add your property tile content here
              );
            },
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class LandlordPropertyListWidget extends ConsumerWidget {
  final String landlordId;

  const LandlordPropertyListWidget({super.key, required this.landlordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(
      landlordPropertyStreamProvider(landlordId),
    );

    return propertiesAsync.when(
      data:
          (properties) => ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return ListTile(
                title: Text(property.title),
                subtitle: Text('₦${property.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await ref
                        .read(propertyControllerProvider.notifier)
                        .deleteProperty(property.id);
                  },
                ),
              );
            },
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
