import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/localization_service.dart';

class CampusFilterWidget extends StatefulWidget {
  final String? selectedCampus;
  final Function(String?) onCampusChanged;

  const CampusFilterWidget({
    super.key,
    this.selectedCampus,
    required this.onCampusChanged,
  });

  @override
  State<CampusFilterWidget> createState() => _CampusFilterWidgetState();
}

class _CampusFilterWidgetState extends State<CampusFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedCampus,
      decoration: InputDecoration(
        labelText: 'near_campus'.tr,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.school),
      ),
      items: [
        DropdownMenuItem<String>(value: null, child: Text('All Areas')),
        ...AppConstants.universities.keys.map((campus) {
          return DropdownMenuItem<String>(value: campus, child: Text(campus));
        }),
      ],
      onChanged: widget.onCampusChanged,
    );
  }
}

class CampusProximityChip extends StatelessWidget {
  final String campusName;
  final double distance;

  const CampusProximityChip({
    super.key,
    required this.campusName,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school, size: 14, color: Colors.blue.shade600),
          const SizedBox(width: 4),
          Text(
            '${distance.toStringAsFixed(1)}km to $campusName',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
