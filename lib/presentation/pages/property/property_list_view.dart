import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/property_entity.dart';
import '../../../domain/entities/property_filter.dart';
import '../../providers/property_provider.dart';
import '../home/home_view.dart';

class PropertyListView extends ConsumerStatefulWidget {
  const PropertyListView({super.key});

  @override
  ConsumerState<PropertyListView> createState() => _PropertyListViewState();
}

class _PropertyListViewState extends ConsumerState<PropertyListView> {
  String? _selectedState;
  PropertyType? _selectedType;
  double? _maxPrice;

  final List<String> _nigerianStates = [
    'Lagos',
    'Abuja',
    'Kano',
    'Rivers',
    'Oyo',
    'Kaduna',
    'Ogun',
    'Imo',
    'Plateau',
    'Akwa Ibom',
    'Abia',
    'Osun',
    'Delta',
    'Katsina',
    'Niger',
    'Jigawa',
    'Ondo',
    'Anambra',
    'Borno',
    'Adamawa',
    'Bauchi',
    'Taraba',
    'Kebbi',
    'Cross River',
    'Kwara',
    'Gombe',
    'Sokoto',
    'Zamfara',
    'Enugu',
    'Edo',
    'Yobe',
    'Kogi',
    'Benue',
    'Ebonyi',
    'Bayelsa',
    'Nasarawa',
  ];

  @override
  Widget build(BuildContext context) {
    final filter = PropertyFilter(
      state: _selectedState,
      type: _selectedType,
      maxPrice: _maxPrice,
    );
    final propertiesAsync = ref.watch(propertiesProvider(filter));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedState,
                        decoration: const InputDecoration(
                          labelText: 'State',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All States'),
                          ),
                          ..._nigerianStates.map(
                            (state) => DropdownMenuItem(
                              value: state,
                              child: Text(state),
                            ),
                          ),
                        ],
                        onChanged:
                            (value) => setState(() => _selectedState = value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<PropertyType>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Types'),
                          ),
                          ...PropertyType.values.map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type.name.toUpperCase()),
                            ),
                          ),
                        ],
                        onChanged:
                            (value) => setState(() => _selectedType = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max Price (₦)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _maxPrice = double.tryParse(value);
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: propertiesAsync.when(
              data:
                  (properties) =>
                      properties.isEmpty
                          ? const Center(child: Text('No properties found'))
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: properties.length,
                            itemBuilder: (context, index) {
                              return PropertyCard(
                                property: properties[index].toModel(),
                              );
                            },
                          ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
}
