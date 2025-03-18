import 'package:kunet_app/components/buttons/primary.dart';
import 'package:kunet_app/components/cards/giftcard_item.dart';
import 'package:kunet_app/components/text/textComponents.dart';
import 'package:kunet_app/helper/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'splitting_screen.dart';

class SelectSplitVoucher extends StatefulWidget {
  const SelectSplitVoucher({Key? key}) : super(key: key);

  @override
  State<SelectSplitVoucher> createState() => _SelectSplitVoucherState();
}

class _SelectSplitVoucherState extends State<SelectSplitVoucher> {
  String _type = "blue";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0, top: 4.0, bottom: 4.0),
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
              text: "Select voucher to split",
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SizedBox(
            width: double.infinity,
            child: InkWell(
              onTap: () {
                setState(() {
                  _type = "blue";
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 225,
                    child: GiftCardItem(
                      amount: "1000",
                      bgType: "blue",
                      code: "XDT12IUNWpo1HN",
                      status: "used",
                      type: "Gift Card",
                      width: double.infinity,
                    ),
                  ),
                  Radio(
                    activeColor: Constants.primaryColor,
                    value: "blue",
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = (value as String?)!;
                      });
                      // _controller.cableTvAmount.value = (value as double?)!;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _type = "white";
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 225,
                  child: GiftCardItem(
                    amount: "1000",
                    type: "Wedding",
                    code: "XDT12IUNWpo1HN",
                    status: "unused",
                    bgType: "white",
                    width: double.infinity,
                  ),
                ),
                Radio(
                  activeColor: Constants.primaryColor,
                  value: "white",
                  groupValue: _type,
                  onChanged: (value) {
                    setState(() {
                      _type = (value as String?)!;
                    });
                    // _controller.cableTvAmount.value = (value as double?)!;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              buttonText: "Continue",
              fontSize: 15,
              bgColor: Theme.of(context).colorScheme.primaryContainer,
              onPressed: () {
                Get.to(
                  VoucherSplittingScreen(type: _type),
                  transition: Transition.cupertino,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // List<int>? imageBytes;

  // Future<void> captureImage() async {
  //   RenderRepaintBoundary boundary =
  //       globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //   ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //   ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   imageBytes = byteData?.buffer.asUint8List();
  //   setState(() {
  //     _image = image;
  //   });
  // }
}
