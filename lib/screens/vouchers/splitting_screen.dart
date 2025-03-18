import 'package:kunet_app/components/cards/giftcard_item.dart';
import 'package:kunet_app/components/cards/giftcard_mini.dart';
import 'package:kunet_app/components/text/textComponents.dart';
import 'package:kunet_app/forms/voucher/split_voucher_form.dart';
import 'package:kunet_app/helper/constants/constants.dart';
import 'package:kunet_app/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

class VoucherSplittingScreen extends StatelessWidget {
  final String type;
  const VoucherSplittingScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StateController>(builder: (controller) {
      return LoadingOverlayPro(
        isLoading: controller.isLoading.value,
        progressIndicator: const CircularProgressIndicator.adaptive(),
        backgroundColor: Colors.black54,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
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
              ],
            ),
            centerTitle: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Card(
                  elevation: 2.0,
                  child: type == "blue"
                      ? const SizedBox(
                          height: 165,
                          child: GiftCardMini(
                            amount: "1000",
                            bgImage: "assets/images/giftcard_bg.png",
                            code: "XDT12IUNWpo1HN",
                            logo: "assets/images/afrikunet_logo_white.png",
                            type: "blue",
                          ),
                        )
                      : const SizedBox(
                          height: 165,
                          child: GiftCardMini(
                            amount: "1000",
                            bgImage: "assets/images/giftcard_bg.png",
                            code: "XDT12IUNWpo1HN",
                            logo: "assets/images/logo_blue.png",
                            type: "white",
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24.0),
              SplitVoucherForm()
            ],
          ),
        ),
      );
    });
  }
}
