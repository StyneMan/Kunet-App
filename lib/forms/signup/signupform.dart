import 'dart:convert';

import 'package:kunet_app/components/buttons/primary.dart';
import 'package:kunet_app/components/text/textComponents.dart';
import 'package:kunet_app/helper/preference/preference_manager.dart';
import 'package:kunet_app/helper/service/api_service.dart';
import 'package:kunet_app/screens/auth/login/login.dart';
import 'package:kunet_app/screens/auth/otp/verifyotp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kunet_app/components/inputfield/passwordfield.dart';
import 'package:kunet_app/components/inputfield/textfield.dart';

import '../../helper/constants/constants.dart';
import '../../helper/state/state_manager.dart';

typedef InitCallback(bool params);

class SignupForm extends StatefulWidget {
  final PreferenceManager manager;
  SignupForm({
    Key? key,
    required this.manager,
  }) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  String _isoCode = "+234", _countryCode = "NG";
  bool _obscureText = true, _loading = false, _isChecked = false;

  bool _isNumberOk = false,
      _isLowercaseOk = false,
      _isCapitalOk = false,
      _isSpecialCharOk = false;

  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<StateController>();
  String _number = '';

  _register() async {
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.setLoading(true);

    Map _payload = {
      "email_address": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
      "first_name": _fnameController.text.trim(),
      "last_name": _lnameController.text.trim(),
      "iso_code": _isoCode,
      "country_code": _countryCode.trim(),
      "phone_number": _phoneController.text,
      "international_phone_format": "$_isoCode ${_phoneController.text}"
    };

    try {
      final _response = await APIService().signup(_payload);
      _controller.setLoading(false);
      debugPrint("SIGUP RESPONSE :: ${_response.body}");
      Map<String, dynamic> map = jsonDecode(_response.body);
      if (_response.statusCode >= 200 &&
          _response.statusCode <= 299 &&
          (map['message'] != 'Account already exist' &&
              map['message'] != 'Phone number is taken')) {
        // Successful
        Map<String, dynamic> _mapper = jsonDecode(_response.body);
        Constants.toast("${_mapper['message']}");

        Get.to(
          VerifyOTP(
            email: _emailController.text,
            caller: "signup",
            manager: widget.manager,
          ),
          transition: Transition.cupertino,
        );
      } else {
        Map<String, dynamic> _errorMapper = jsonDecode(_response.body);
        Constants.showInfoDialog(
          context: context,
          message: _errorMapper['message'],
          status: "error",
        );
      }
    } catch (e) {
      debugPrint("ERROR: $e");
      _controller.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 4.0,
          ),
          CustomTextField(
            hintText: "",
            placeholder: "Email",
            onChanged: (val) {},
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email or phone';
              }
              if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                  .hasMatch(value)) {
                return 'Enter a valid email address';
              }
              return null;
            },
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 16.0,
          ),
          PasswordField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please type password';
              }
              if (value.toString().length < 8) {
                return "Password must be at least 8 characters!";
              }
              if (!_isNumberOk ||
                  !_isCapitalOk ||
                  !_isLowercaseOk ||
                  !_isSpecialCharOk) {
                return 'Weak password. See hint below';
              }
              return null;
            },
            controller: _passwordController,
            onChanged: (value) {
              if (value.contains(RegExp(r'[0-9]'))) {
                setState(() {
                  _isNumberOk = true;
                });
              } else {
                setState(() {
                  _isNumberOk = false;
                });
              }

              if (value.contains(RegExp(r'[A-Z]'))) {
                setState(() {
                  _isCapitalOk = true;
                });
              } else {
                setState(() {
                  _isCapitalOk = false;
                });
              }

              if (value.contains(RegExp(r'[a-z]'))) {
                setState(() {
                  _isLowercaseOk = true;
                });
              } else {
                setState(() {
                  _isLowercaseOk = false;
                });
              }

              if (value.contains(RegExp(r'[!@#$%^&*(),.?"_:;{}|<>/+=-]'))) {
                setState(() {
                  _isSpecialCharOk = true;
                });
              } else {
                setState(() {
                  _isSpecialCharOk = false;
                });
              }
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          PasswordField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please type password';
              }
              if (value.toString().length < 8) {
                return "Password must be at least 8 characters!";
              }
              if (_passwordController.text != value) {
                return "Password does not match";
              }
              if (!_isNumberOk ||
                  !_isCapitalOk ||
                  !_isLowercaseOk ||
                  !_isSpecialCharOk) {
                return 'Weak password. See hint below';
              }
              return null;
            },
            controller: _retypePasswordController,
            onChanged: (value) {
              if (value.contains(RegExp(r'[0-9]'))) {
                setState(() {
                  _isNumberOk = true;
                });
              } else {
                setState(() {
                  _isNumberOk = false;
                });
              }

              if (value.contains(RegExp(r'[A-Z]'))) {
                setState(() {
                  _isCapitalOk = true;
                });
              } else {
                setState(() {
                  _isCapitalOk = false;
                });
              }

              if (value.contains(RegExp(r'[a-z]'))) {
                setState(() {
                  _isLowercaseOk = true;
                });
              } else {
                setState(() {
                  _isLowercaseOk = false;
                });
              }

              if (value.contains(RegExp(r'[!@#$%^&*(),.?"_:;{}|<>/+=-]'))) {
                setState(() {
                  _isSpecialCharOk = true;
                });
              } else {
                setState(() {
                  _isSpecialCharOk = false;
                });
              }
            },
          ),
          const SizedBox(
            height: 6.0,
          ),
          RichText(
            text: TextSpan(
              text: "Use at least one ",
              style: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 12,
              ),
              children: [
                const TextSpan(
                  text: "uppercase",
                  style: TextStyle(
                    color: Constants.primaryColor,
                  ),
                ),
                TextSpan(
                  text: ", one ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const TextSpan(
                  text: "lowercase",
                  style: TextStyle(
                    color: Constants.primaryColor,
                  ),
                ),
                TextSpan(
                  text: ", one ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const TextSpan(
                  text: "numeric digit",
                  style: TextStyle(
                    color: Constants.primaryColor,
                  ),
                ),
                TextSpan(
                  text: " and one ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const TextSpan(
                  text: "special character",
                  style: TextStyle(
                    color: Constants.primaryColor,
                  ),
                ),
                TextSpan(
                  text: ". ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 48.0,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.82,
            child: PrimaryButton(
              buttonText: 'Create',
              foreColor: Colors.white,
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: _isChecked
                  ? () {
                      if (_formKey.currentState!.validate()) {
                        _register();
                      }
                    }
                  : null,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox.adaptive(
                value: _isChecked,
                splashRadius: 2.0,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Constants.primaryColor;
                  }
                  return Colors.grey.shade100;
                }),
                onChanged: (e) {
                  setState(() {
                    _isChecked = !_isChecked;
                  });
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 2.0, top: 8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "By continuing you accept our standard terms and ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: "conditions",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Constants.toast("Not yet implemented!"),
                        ),
                        const TextSpan(text: " and our "),
                        TextSpan(
                          text: "privacy policy",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Constants.toast("Not yet implemented!"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextSmall(
                text: "Already have an account?",
                color: Theme.of(context).colorScheme.tertiary,
              ),
              TextButton(
                onPressed: () {
                  Get.to(const Login(), transition: Transition.cupertino);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                ),
                child: TextSmall(
                  text: "Log In ",
                  fontWeight: FontWeight.w600,
                  color: Constants.primaryColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
