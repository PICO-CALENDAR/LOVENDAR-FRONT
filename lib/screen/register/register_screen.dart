import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pico/components/common/action_button.dart';
import 'package:pico/components/common/input_field.dart';
import 'package:pico/theme/theme_light.dart';

class RegisterScreen extends StatefulWidget {
  final GoogleSignInAccount user;
  const RegisterScreen(this.user, {super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  bool _isServiceAgreementChecked = false;
  bool _isMarketingAgreementChecked = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showDatePicker(BuildContext context, FormFieldState<DateTime> state) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: 250,
          child: CupertinoDatePicker(
            initialDateTime: DateTime(2000, 1, 1),
            mode: CupertinoDatePickerMode.date,
            maximumDate: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              setState(() {
                _selectedDate = newDate;
              });
              state.didChange(newDate);
            },
          ),
        );
      },
    );
  }

  Widget _buildRoundCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
  }) {
    final selectedColor = Theme.of(context).primaryColor;
    final unselectedColor = Colors.grey.withOpacity(0.5);

    return ListTile(
      minLeadingWidth: 0,
      visualDensity: const VisualDensity(vertical: -4),
      leading: GestureDetector(
        onTap: () => onChanged(!value),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: value ? selectedColor : unselectedColor,
              width: 2.0,
            ),
            color: value ? selectedColor : Colors.transparent,
          ),
          width: 20,
          height: 20,
          child: value
              ? const Icon(Icons.check, size: 16.0, color: Colors.white)
              : null,
        ),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 0,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        ),
      ),
      onTap: () => onChanged(!value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "추가 정보를 입력해주세요",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name TextFormField
                        InputField(
                          title: "별명",
                          hint: "피코",
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '별명을 입력해주세요';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Birthday Picker with validation
                        FormField<DateTime>(
                          validator: (value) {
                            if (_selectedDate == null) {
                              return '생년월일을 선택해주세요';
                            }
                            return null;
                          },
                          builder: (FormFieldState<DateTime> state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    '생년월일',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _showDatePicker(context, state),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: AppTheme.greyColor,
                                      borderRadius: BorderRadius.circular(16.0),
                                      border: Border.all(
                                        color: _selectedDate != null
                                            ? AppTheme.primaryColor
                                            : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Text(
                                      _selectedDate == null
                                          ? "생년월일을 선택하세요"
                                          : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: _selectedDate == null
                                            ? Colors.grey
                                            : AppTheme.textColor,
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.hasError)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 5.0),
                                    child: Text(
                                      state.errorText!,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  // Terms and Marketing Agreement Round Checkboxes
                  _buildRoundCheckbox(
                    value: _isServiceAgreementChecked,
                    onChanged: (value) {
                      setState(() {
                        _isServiceAgreementChecked = value!;
                      });
                    },
                    label: "서비스 이용 및 개인정보 수집 약관에 동의합니다",
                  ),
                  _buildRoundCheckbox(
                    value: _isMarketingAgreementChecked,
                    onChanged: (value) {
                      setState(() {
                        _isMarketingAgreementChecked = value!;
                      });
                    },
                    label: "(선택) 마케팅 활용 동의 및 광고 수신 동의에 동의합니다",
                  ),
                  const SizedBox(height: 10),
                  ActionButton(
                      buttonName: "가입하기",
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _isServiceAgreementChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Name: ${_nameController.text}, '
                                'Birthday: ${_selectedDate != null ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}" : 'Not selected'}, '
                                'Marketing Agreement: $_isMarketingAgreementChecked',
                              ),
                            ),
                          );
                        } else if (!_isServiceAgreementChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("필수 약관에 동의해야 합니다."),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
