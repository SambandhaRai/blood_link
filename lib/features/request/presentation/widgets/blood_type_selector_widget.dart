import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blood_link/features/bloodGroup/presentation/state/blood_group_state.dart';
import 'package:blood_link/features/bloodGroup/presentation/view_model/blood_group_viewmodel.dart';

class BloodTypeSelector extends ConsumerStatefulWidget {
  const BloodTypeSelector({
    super.key,
    required this.onSelected,
    this.initialSelectedBloodId,
  });

  final String? initialSelectedBloodId;
  final void Function(String bloodId) onSelected;

  @override
  ConsumerState<BloodTypeSelector> createState() => _BloodTypeSelectorState();
}

class _BloodTypeSelectorState extends ConsumerState<BloodTypeSelector> {
  static const _brand = Color(0xFFA72636);

  String? _selectedBloodId;

  @override
  void initState() {
    super.initState();
    _selectedBloodId = widget.initialSelectedBloodId;

    Future.microtask(() {
      ref.read(bloodGroupViewModelProvider.notifier).getAllBloodGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloodState = ref.watch(bloodGroupViewModelProvider);

    final isLoading = bloodState.status == BloodGroupStatus.loading;
    final isError = bloodState.status == BloodGroupStatus.error;

    final groups = bloodState.bloodGroups;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (groups.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              isLoading
                  ? "Loading blood groups..."
                  : isError
                  ? (bloodState.errorMessage ?? "Failed to load blood groups")
                  : "No blood groups available",
              style: TextStyle(color: isError ? Colors.red : Colors.grey),
            ),
          ),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: groups.map((blood) {
            final bloodId = (blood.bloodId ?? "").trim();
            final label = blood.bloodGroup.trim();
            final isSelected = (_selectedBloodId ?? "") == bloodId;

            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: (bloodId.isEmpty || isLoading)
                  ? null
                  : () {
                      setState(() => _selectedBloodId = bloodId);
                      widget.onSelected(bloodId);
                    },
              child: Opacity(
                opacity: isLoading ? 0.6 : 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? _brand : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black45),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: "BricolageGrotesque SemiBold",
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
