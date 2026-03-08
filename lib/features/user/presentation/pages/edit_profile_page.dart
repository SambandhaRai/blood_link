import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/core/widgets/my_multi_line_text_form_field.dart';
import 'package:blood_link/core/widgets/my_text_form_field.dart';
import 'package:blood_link/features/auth/domain/entities/auth_entity.dart';
import 'package:blood_link/features/auth/presentation/state/auth_state.dart';
import 'package:blood_link/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:blood_link/features/bloodGroup/presentation/view_model/blood_group_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _healthConditionController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  DateTime? _selectedDob;
  String? _gender;
  String? _selectedBloodGroup;

  final List<String> _genders = const ["Male", "Female", "Others"];
  final _formKey = GlobalKey<FormState>();

  String? _normalizeGender(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final normalized = raw.trim().toLowerCase();
    for (final option in _genders) {
      if (option.toLowerCase() == normalized) return option;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bloodGroupViewModelProvider.notifier).getAllBloodGroups();
      _prefillFromSession();
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _healthConditionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _prefillFromSession() {
    final session = ref.read(userSessionServiceProvider);
    _fullNameController.text = session.getCurrentUserFullName() ?? "";
    _phoneController.text = session.getCurrentUserPhoneNumber() ?? "";
    _emailController.text = session.getCurrentUserEmail() ?? "";
    _healthConditionController.text =
        session.getCurrentUserHealthCondition() ?? "";
    _gender = _normalizeGender(session.getCurrentUserGender());
    _selectedBloodGroup = session.getCurrentUserBloodId();

    final dob = session.getCurrentUserDob();
    if (dob != null && dob.isNotEmpty) {
      try {
        final parsed = DateTime.parse(dob);
        _selectedDob = parsed;
        _dobController.text =
            "${parsed.day.toString().padLeft(2, '0')} / "
            "${parsed.month.toString().padLeft(2, '0')} / "
            "${parsed.year}";
      } catch (_) {
        _dobController.text = dob;
      }
    }

    if (mounted) setState(() {});
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text =
            "${picked.day.toString().padLeft(2, '0')} / "
            "${picked.month.toString().padLeft(2, '0')} / "
            "${picked.year}";
      });
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDob == null) {
      SnackbarUtils.showError(context, "Please select your date of birth");
      return;
    }

    if (_selectedBloodGroup == null || _selectedBloodGroup!.isEmpty) {
      SnackbarUtils.showError(context, "Please select blood group");
      return;
    }

    final dobIso =
        "${_selectedDob!.year.toString().padLeft(4, '0')}-"
        "${_selectedDob!.month.toString().padLeft(2, '0')}-"
        "${_selectedDob!.day.toString().padLeft(2, '0')}";

    final session = ref.read(userSessionServiceProvider);
    final currentUserId = session.getCurrentUserId();
    if (currentUserId == null || currentUserId.isEmpty) {
      SnackbarUtils.showError(
        context,
        "User session missing. Please login again.",
      );
      return;
    }

    final entity = AuthEntity(
      userId: currentUserId,
      fullName: _fullNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      dob: dobIso,
      gender: _gender ?? "",
      bloodId: _selectedBloodGroup,
      healthCondition: _healthConditionController.text.trim(),
      email: _emailController.text.trim(),
    );

    final ok = await ref
        .read(authViewmodelProvider.notifier)
        .updateProfile(entity);
    if (!mounted) return;

    if (ok) {
      SnackbarUtils.showSuccess(context, "Profile updated successfully");
      Navigator.pop(context, true);
      return;
    }

    final msg =
        ref.read(authViewmodelProvider).errorMessage ??
        "Failed to update profile";
    SnackbarUtils.showError(context, msg);
  }

  @override
  Widget build(BuildContext context) {
    final bloodGroupState = ref.watch(bloodGroupViewModelProvider);
    final authState = ref.watch(authViewmodelProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final hasSelectedBlood = bloodGroupState.bloodGroups.any(
      (blood) => blood.bloodId == _selectedBloodGroup,
    );
    final selectedBloodValue = hasSelectedBlood ? _selectedBloodGroup : null;
    final selectedGenderValue = _normalizeGender(_gender);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEC99A4), Color(0xFFA72636)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha((0.2 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    MyTextFormField(
                      controller: _fullNameController,
                      labelText: "Full Name",
                      hintText: "Full Name",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Full name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    MyTextFormField(
                      controller: _phoneController,
                      labelText: "Phone Number",
                      hintText: "Enter your phone number",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is required";
                        }
                        if (value.length != 10) {
                          return "Enter a valid phone number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    MyTextFormField(
                      controller: _emailController,
                      labelText: "Email",
                      hintText: "abc@gmail.com",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _pickDob,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Date of Birth",
                          labelStyle: const TextStyle(color: Colors.grey),
                          hintText: "DD / MM / YYYY",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFA72636),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 18,
                          ),
                          suffixIcon: const Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                        ),
                        child: Text(
                          _dobController.text.isEmpty
                              ? "DD / MM / YYYY"
                              : _dobController.text,
                          style: TextStyle(
                            color: _dobController.text.isEmpty
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedGenderValue,
                      decoration: InputDecoration(
                        labelText: "Gender",
                        labelStyle: const TextStyle(color: Colors.grey),
                        hintText: "Choose your gender",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFA72636),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 18,
                        ),
                      ),
                      items: _genders
                          .map(
                            (gender) => DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _gender = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select your gender";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: selectedBloodValue,
                      decoration: InputDecoration(
                        labelText: "Blood Group",
                        labelStyle: const TextStyle(color: Colors.grey),
                        hintText: "Choose your blood group",
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.grey,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFA72636),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 18,
                        ),
                      ),
                      items: bloodGroupState.bloodGroups
                          .map(
                            (bloodGroup) => DropdownMenuItem<String>(
                              value: bloodGroup.bloodId,
                              child: Text(bloodGroup.bloodGroup),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedBloodGroup = value),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select blood group";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    MyMultiLineTextFormField(
                      controller: _healthConditionController,
                      hintText: "Health condition (optional)",
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleUpdate,
                        child: Text(isLoading ? "Updating..." : "Save Changes"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
