import 'package:kunet_app/components/buttons/primary.dart';
import 'package:kunet_app/components/cards/giftcard_item.dart';
import 'package:kunet_app/components/inputfield/textfield.dart';
import 'package:kunet_app/components/text/textComponents.dart';
import 'package:kunet_app/helper/preference/preference_manager.dart';
import 'package:kunet_app/helper/state/state_manager.dart';
import 'package:kunet_app/screens/payment/payment_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class ConfirmPurchase extends StatefulWidget {
  final PreferenceManager manager;
  final Map payload;
  const ConfirmPurchase({
    Key? key,
    required this.manager,
    required this.payload,
  }) : super(key: key);

  @override
  State<ConfirmPurchase> createState() => _ConfirmPurchaseState();
}

class _ConfirmPurchaseState extends State<ConfirmPurchase> {
  final _controller = Get.find<StateController>();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isValidEmail = false;

  @override
  void initState() {
    super.initState();
    // if (mounted) {
    //   setState(() {
    //     _emailController.text = widget.manager.getUser()['email_address'];
    //   });
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => LoadingOverlayPro(
        isLoading: _controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 6.0,
                    top: 4.0,
                    bottom: 4.0,
                    left: 0.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      CupertinoIcons.back,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                TextMedium(
                  text: "Confirm Purchase",
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/giftcard_bg.png'),
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeat,
                ),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const SizedBox(height: 16.0),
                    Text(
                      "Purchase Info",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 32.0),
                    SizedBox(
                      height: 230,
                      width: double.infinity,
                      child: GiftCardItem(
                        width: double.infinity,
                        amount: widget.payload['finalValue'],
                        status: "unused",
                        code: "XYZ**********",
                        bgType: widget.payload['voucherIndex'] == 0
                            ? "blue"
                            : widget.payload['voucherIndex'] == 1
                                ? "white"
                                : "black",
                        type: widget.payload['voucherType'],
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Text(
                      "Alt email for 2FA",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      placeholder: "Enter a valid email",
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _isValidEmail = false;
                          });
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                            .hasMatch(value)) {
                          setState(() {
                            _isValidEmail = false;
                          });
                        } else {
                          setState(() {
                            _isValidEmail = true;
                          });
                        }
                      },
                      endIcon: _isValidEmail
                          ? const Icon(
                              Icons.done,
                              color: Colors.green,
                            )
                          : _emailController.text.isNotEmpty
                              ? const Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  color: Colors.red,
                                )
                              : const SizedBox(),
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return null;
                        }
                        if (value != null || value.isNotEmpty) {
                          if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                              .hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                        }
                        return null;
                      },
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                    PrimaryButton(
                      fontSize: 16,
                      buttonText: "Confirm",
                      bgColor: Theme.of(context).colorScheme.primaryContainer,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // _purchaseVoucher();
                          Get.to(
                            PaymentOptions(
                              manager: widget.manager,
                              payload: {
                                "voucherType":
                                    "${widget.payload['voucherType']}",
                                "finalValue": "${widget.payload['finalValue']}",
                                "amount": "${widget.payload['amount']}"
                                    .replaceAll("₦", "")
                                    .replaceAll(",", ""),
                                "voucherIndex": widget.payload['voucherIndex'],
                                "email": _emailController.text.isEmpty
                                    ? widget.manager.getUser()['email_address']
                                    : _emailController.text,
                                "phone":
                                    widget.manager.getUser()['phone_number'],
                              },
                              onChecked: (params, name) {},
                            ),
                            transition: Transition.cupertino,
                          );
                        }
                      },
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
