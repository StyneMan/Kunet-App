import 'package:kunet_app/components/buttons/primary.dart';
import 'package:kunet_app/components/buttons/secondary.dart';
import 'package:kunet_app/components/text/textComponents.dart';
import 'package:kunet_app/helper/constants/constants.dart';
import 'package:kunet_app/helper/state/state_manager.dart';
import 'package:kunet_app/screens/auth/login/login.dart';
import 'package:kunet_app/screens/auth/register/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetStarted extends StatelessWidget {
  GetStarted({Key? key}) : super(key: key);

  final _controller = Get.find<StateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image.asset('assets/images/get_started.png'),
                  SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        TextLarge(
                          text: "Let's Get Started",
                          align: TextAlign.center,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextBody1(
                            text:
                                "Start generating, gifting, sharing and connecting with loved ones via vouchers.",
                            align: TextAlign.center,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PrimaryButton(
                            buttonText: "Sign Up",
                            onPressed: () {
                              Get.to(
                                const Register(),
                                transition: Transition.cupertino,
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SecondaryButton(
                            buttonText: "Log In",
                            onPressed: () {
                              Get.to(
                                const Login(),
                                transition: Transition.cupertino,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }
}
