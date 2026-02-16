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
  final void Function({
    required String bloodId,
    required String bloodGroupLabel,
  })
  onSelected;

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

    if (bloodState.status == BloodGroupStatus.loading &&
        bloodState.bloodGroups.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (bloodState.status == BloodGroupStatus.error) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bloodState.errorMessage ?? "Failed to load blood groups",
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              ref
                  .read(bloodGroupViewModelProvider.notifier)
                  .getAllBloodGroups();
            },
            child: const Text("Retry"),
          ),
        ],
      );
    }

    // Loaded
    final groups = bloodState.bloodGroups;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: groups.map((blood) {
        final idKey = (blood.bloodId!).trim();
        final label = blood.bloodGroup.trim();

        final isSelected = (_selectedBloodId ?? "") == idKey;

        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() => _selectedBloodId = idKey);

            // If you NEED id for API, you should not allow null id.
            // But for UI selection, this works.
            if (blood.bloodId != null) {
              widget.onSelected(
                bloodId: blood.bloodId!.trim(),
                bloodGroupLabel: label,
              );
            } else {
              // Optional: still call callback using label as key
              widget.onSelected(bloodId: idKey, bloodGroupLabel: label);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _brand : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black45),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: "BricolageGrotesque SemiBold",
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
