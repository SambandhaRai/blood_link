import 'package:blood_link/core/widgets/my_multi_line_text_form_field.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/presentation/widgets/blood_type_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestBloodPage extends ConsumerStatefulWidget {
  const RequestBloodPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RequestBloodPageState();
}

class _RequestBloodPageState extends ConsumerState<RequestBloodPage> {
  final TextEditingController _recipientDetailsController =
      TextEditingController();
  String? _recipientBloodId;
  String? _recipientBloodLabel;
  ConditionType? _selectedCondition;
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

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFA72636),
        elevation: 0,
        toolbarHeight: 80,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          "Find Donors",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "BricolageGrotesque SemiBold",
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFA72636),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: Card(
                      color: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Recipient Blood Type:",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "BricolageGrotesque SemiBold",
                              ),
                            ),
                            const SizedBox(height: 12),

                            BloodTypeSelector(
                              initialSelectedBloodId: _recipientBloodId,
                              onSelected:
                                  ({
                                    required String bloodId,
                                    required String bloodGroupLabel,
                                  }) {
                                    setState(() {
                                      _recipientBloodId = bloodId;
                                      _recipientBloodLabel = bloodGroupLabel;
                                    });
                                  },
                            ),

                            const SizedBox(height: 10),
                            Text(
                              _recipientBloodLabel == null
                                  ? "No blood type selected"
                                  : "Selected: $_recipientBloodLabel",
                            ),

                            const SizedBox(height: 25),
                            const Text(
                              "Recipient's Details:",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "BricolageGrotesque SemiBold",
                              ),
                            ),
                            const SizedBox(height: 5),
                            MyMultiLineTextFormField(
                              controller: _recipientDetailsController,
                              labelText: "Recipient Details",
                              hintText: "Type Here...",
                            ),

                            const SizedBox(height: 25),
                            const Text(
                              "Recipient's Condition:",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "BricolageGrotesque SemiBold",
                              ),
                            ),
                            const SizedBox(height: 5),
                            DropdownButtonFormField<ConditionType>(
                              initialValue: _selectedCondition,
                              decoration: InputDecoration(
                                labelStyle: const TextStyle(color: Colors.grey),
                                hintText: "Choose recipient condition",
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
                              items: ConditionType.values.map((c) {
                                return DropdownMenuItem<ConditionType>(
                                  value: c,
                                  child: Text(_conditionLabel(c)),
                                );
                              }).toList(),
                              onChanged: (ConditionType? value) {
                                setState(() {
                                  _selectedCondition = value;
                                });
                              },
                            ),

                            const SizedBox(height: 25),
                            const Text(
                              "Hospital Name:",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "BricolageGrotesque SemiBold",
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
