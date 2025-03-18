import 'package:kunet_app/components/text/textComponents.dart';
import 'package:kunet_app/forms/forgotpassword/changepasswordform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import '../../../helper/state/state_manager.dart';

class ChangePassword extends StatefulWidget {
  final String emailAddress;
  const ChangePassword({
    Key? key,
    required this.emailAddress,
  }) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _controller = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context)
                        .size
                        .height, // Ensure it takes full screen height
                  ),
                  child: IntrinsicHeight(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 21,
                        vertical: 16,
                      ),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                          ),
                          TextLarge(
                            text: "Change Password",
                            align: TextAlign.center,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(
                            height: 32.0,
                          ),
                          ChangePasswordForm(
                            emailAddress: widget.emailAddress,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
