import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaabo/domain/entities/property_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/property_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/property_provider.dart';

class AddPropertyView extends ConsumerStatefulWidget {
  const AddPropertyView({super.key});

  @override
  ConsumerState<AddPropertyView> createState() => _AddPropertyViewState();
}

class _AddPropertyViewState extends ConsumerState<AddPropertyView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController();

  String _selectedState = 'Lagos';
  PropertyType _selectedType = PropertyType.apartment;
  int _bedrooms = 1;
  int _bathrooms = 1;
  final List<String> _selectedAmenities = [];

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
  ];

  final List<String> _availableAmenities = [
    'Swimming Pool',
    'Gym',
    'Security',
    'Parking',
    'Generator',
    'Air Conditioning',
    'Balcony',
    'Garden',
    'Elevator',
    'CCTV',
  ];

  @override
  Widget build(BuildContext context) {
    final propertyState = ref.watch(propertyControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Property'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Property Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Title is required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Description is required';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Rent (₦)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Price is required';
                  if (double.tryParse(value!) == null) return 'Invalid price';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location/Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Location is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'City is required';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedState,
                decoration: const InputDecoration(
                  labelText: 'State',
                  border: OutlineInputBorder(),
                ),
                items:
                    _nigerianStates
                        .map(
                          (state) => DropdownMenuItem(
                            value: state,
                            child: Text(state),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _selectedState = value!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<PropertyType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Property Type',
                  border: OutlineInputBorder(),
                ),
                items:
                    PropertyType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _bedrooms,
                      decoration: const InputDecoration(
                        labelText: 'Bedrooms',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          List.generate(6, (index) => index + 1)
                              .map(
                                (num) => DropdownMenuItem(
                                  value: num,
                                  child: Text('$num'),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => setState(() => _bedrooms = value!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _bathrooms,
                      decoration: const InputDecoration(
                        labelText: 'Bathrooms',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          List.generate(6, (index) => index + 1)
                              .map(
                                (num) => DropdownMenuItem(
                                  value: num,
                                  child: Text('$num'),
                                ),
                              )
                              .toList(),
                      onChanged: (value) => setState(() => _bathrooms = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Amenities',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _availableAmenities.map((amenity) {
                      final isSelected = _selectedAmenities.contains(amenity);
                      return FilterChip(
                        label: Text(amenity),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedAmenities.add(amenity);
                            } else {
                              _selectedAmenities.remove(amenity);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: propertyState.isLoading ? null : _addProperty,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      propertyState.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            'Add Property',
                            style: TextStyle(fontSize: 18),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProperty() async {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final property = PropertyModel(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        location: _locationController.text.trim(),
        state: _selectedState,
        city: _cityController.text.trim(),
        type: _selectedType,
        bedrooms: _bedrooms,
        bathrooms: _bathrooms,
        images: [],
        amenities: _selectedAmenities,
        landlordId: user.id,
        isAvailable: true,
        createdAt: DateTime.now(),
      );

      await ref
          .read(propertyControllerProvider.notifier)
          .addProperty(property.toEntity());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Property added successfully!')),
        );
        context.go('/landlord-dashboard');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
