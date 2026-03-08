import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/core/widgets/my_multi_line_text_form_field.dart';
import 'package:blood_link/core/widgets/my_text_form_field.dart';
import 'package:blood_link/features/hospital/presentation/state/hospital_state.dart';
import 'package:blood_link/features/hospital/presentation/view_model/hospital_viewmodel.dart';
import 'package:blood_link/features/request/domain/entities/create_request_entity.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart'
    hide ConditionType, RequestForType;
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:blood_link/features/request/presentation/widgets/blood_type_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditRequestPage extends ConsumerStatefulWidget {
  const EditRequestPage({super.key, required this.request});

  final RequestEntity request;

  @override
  ConsumerState<EditRequestPage> createState() => _EditRequestPageState();
}

class _EditRequestPageState extends ConsumerState<EditRequestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _recipientDetailsController =
      TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientPhoneController = TextEditingController();

  String? _selectedBloodGroupId;
  ConditionType? _selectedCondition;
  String? _selectedHospital;

  final _formKey = GlobalKey<FormState>();

  String _conditionLabel(ConditionType c) {
    switch (c) {
      case ConditionType.critical:
        return "Critical (Life-threatening)";
      case ConditionType.urgent:
        return "Urgent (Needs blood soon)";
      case ConditionType.stable:
        return "Stable (Under observation)";
    }
  }

  bool get _isOthers => _tabController.index == 1;
  RequestForType get _requestFor =>
      _isOthers ? RequestForType.others : RequestForType.self;

  @override
  void initState() {
    super.initState();
    final request = widget.request;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: request.requestFor.name == "others" ? 1 : 0,
    );

    _selectedBloodGroupId = request.recipientBloodId;
    _selectedCondition = ConditionType.values.firstWhere(
      (c) => c.name == request.recipientCondition.name,
      orElse: () => ConditionType.stable,
    );
    _selectedHospital = request.hospitalId;

    _recipientDetailsController.text = request.recipientDetails;
    _relationController.text = request.relationToPatient ?? "";
    _patientNameController.text = request.patientName ?? "";
    _patientPhoneController.text = request.patientPhone ?? "";

    Future.microtask(() {
      ref.read(hospitalViewModelProvider.notifier).getAllHospitals();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _recipientDetailsController.dispose();
    _relationController.dispose();
    _patientNameController.dispose();
    _patientPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdateRequest() async {
    final requestId = widget.request.requestId;
    if (requestId == null || requestId.isEmpty) {
      SnackbarUtils.showError(context, "Invalid request id");
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    if (_selectedBloodGroupId == null ||
        _selectedCondition == null ||
        _selectedHospital == null) {
      SnackbarUtils.showError(context, "Please fill all required fields.");
      return;
    }

    await ref
        .read(requestViewModelProvider.notifier)
        .updateRequest(
          requestId: requestId,
          recipientBloodId: _selectedBloodGroupId!,
          recipientDetails: _recipientDetailsController.text.trim(),
          recipientCondition: _selectedCondition!,
          hospitalId: _selectedHospital!,
          requestFor: _requestFor,
          relationToPatient: _isOthers ? _relationController.text.trim() : null,
          patientName: _isOthers ? _patientNameController.text.trim() : null,
          patientPhone: _isOthers ? _patientPhoneController.text.trim() : null,
        );

    if (!mounted) return;
    final requestState = ref.read(requestViewModelProvider);
    if (requestState.status == RequestStatus.error) {
      SnackbarUtils.showError(
        context,
        requestState.errorMessage ?? "Failed to update request.",
      );
      return;
    }

    SnackbarUtils.showSuccess(context, "Request updated successfully.");
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 380;
    final maxFormWidth = screenWidth > 900 ? 760.0 : 680.0;

    final hospitalState = ref.watch(hospitalViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFA72636),
        elevation: 0,
        toolbarHeight: 80,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Edit Request",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "BricolageGrotesque SemiBold",
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: compact ? 68 : 80,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFA72636),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, compact ? 8 : 10, 10, 15),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxFormWidth),
                    child: Card(
                      color: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(compact ? 14 : 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: TabBar(
                                  controller: _tabController,
                                  onTap: (index) {
                                    setState(() {
                                      if (index == 0) {
                                        _relationController.clear();
                                        _patientNameController.clear();
                                        _patientPhoneController.clear();
                                      }
                                    });
                                  },
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.primary,
                                  ),
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  dividerColor: Colors.transparent,
                                  labelColor: Colors.white,
                                  unselectedLabelColor: Colors.grey.shade700,
                                  labelStyle: TextStyle(
                                    fontFamily: "BricolageGrotesque SemiBold",
                                    fontSize: compact ? 12 : 14,
                                  ),
                                  tabs: const [
                                    Tab(
                                      child: FittedBox(
                                        child: Text("For Myself"),
                                      ),
                                    ),
                                    Tab(
                                      child: FittedBox(
                                        child: Text("For Others"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: compact ? 16 : 20),
                              Text(
                                "Recipient Blood Type:",
                                style: TextStyle(
                                  fontSize: compact ? 18 : 20,
                                  fontFamily: "BricolageGrotesque SemiBold",
                                ),
                              ),
                              const SizedBox(height: 12),
                              BloodTypeSelector(
                                initialSelectedBloodId: _selectedBloodGroupId,
                                onSelected: (bloodId) {
                                  setState(() {
                                    _selectedBloodGroupId = bloodId;
                                  });
                                },
                              ),
                              const SizedBox(height: 25),
                              Text(
                                "Recipient's Details:",
                                style: TextStyle(
                                  fontSize: compact ? 18 : 20,
                                  fontFamily: "BricolageGrotesque SemiBold",
                                ),
                              ),
                              const SizedBox(height: 5),
                              MyMultiLineTextFormField(
                                controller: _recipientDetailsController,
                                hintText: "Type Here...",
                              ),
                              const SizedBox(height: 25),
                              Text(
                                "Recipient's Condition:",
                                style: TextStyle(
                                  fontSize: compact ? 18 : 20,
                                  fontFamily: "BricolageGrotesque SemiBold",
                                ),
                              ),
                              const SizedBox(height: 5),
                              DropdownButtonFormField<ConditionType>(
                                initialValue: _selectedCondition,
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  hintText: "Choose recipient condition",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
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
                                items: ConditionType.values.map((c) {
                                  return DropdownMenuItem<ConditionType>(
                                    value: c,
                                    child: Text(_conditionLabel(c)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _selectedCondition = value);
                                },
                              ),
                              const SizedBox(height: 25),
                              Text(
                                "Hospital Name:",
                                style: TextStyle(
                                  fontSize: compact ? 18 : 20,
                                  fontFamily: "BricolageGrotesque SemiBold",
                                ),
                              ),
                              const SizedBox(height: 5),
                              DropdownButtonFormField<String>(
                                initialValue: _selectedHospital,
                                decoration: InputDecoration(
                                  labelStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  hintText:
                                      hospitalState.status ==
                                          HospitalStatus.loading
                                      ? "Loading Hospitals..."
                                      : "Choose Hospital",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
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
                                items: hospitalState.hospitals
                                    .where((h) => h.isActive)
                                    .map(
                                      (h) => DropdownMenuItem<String>(
                                        value: h.id,
                                        child: Text(h.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() => _selectedHospital = value);
                                },
                              ),
                              if (_isOthers) ...[
                                const SizedBox(height: 25),
                                Text(
                                  "Patient's Information:",
                                  style: TextStyle(
                                    fontSize: compact ? 18 : 20,
                                    fontFamily: "BricolageGrotesque SemiBold",
                                  ),
                                ),
                                const SizedBox(height: 5),
                                MyTextFormField(
                                  controller: _relationController,
                                  hintText:
                                      "Relation to patient (e.g. Brother)",
                                  validator: (v) {
                                    if (!_isOthers) return null;
                                    if (v == null || v.trim().length < 2) {
                                      return "Relation is required";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                MyTextFormField(
                                  controller: _patientNameController,
                                  hintText: "Patient name",
                                  validator: (v) {
                                    if (!_isOthers) return null;
                                    if (v == null || v.trim().length < 2) {
                                      return "Patient name is required";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _patientPhoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Patient phone number",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (!_isOthers) return null;
                                    if (v == null || v.trim().length < 6) {
                                      return "Patient phone is required";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              const SizedBox(height: 25),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _handleUpdateRequest,
                                  child: const Text("Update Request"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
