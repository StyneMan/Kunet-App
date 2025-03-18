import 'package:kunet_app/components/text/textComponents.dart';
import 'package:kunet_app/helper/state/state_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankCard2 extends StatefulWidget {
  var data;
  int index;
  var list;
  final bool isChecked;
  BankCard2({
    Key? key,
    required this.data,
    required this.list,
    required this.index,
    this.isChecked = false,
  }) : super(key: key);

  @override
  State<BankCard2> createState() => _BankCard2State();
}

class _BankCard2State extends State<BankCard2> {
  final _controller = Get.find<StateController>();

  _obscurer(String value) {
    if (value.length == 3 || value.length == 4) {
      var lhs = value.substring(0, 1);
      var rhs = value.substring(value.length - 1, value.length);
      return "$lhs***$rhs";
    } else if (value.length == 5 || value.length == 6 || value.length == 7) {
      var lhs = value.substring(0, 2);
      var rhs = value.substring(value.length - 2, value.length);
      return "$lhs***$rhs";
    } else {
      var lhs = value.substring(0, 3);
      var rhs = value.substring(value.length - 3, value.length);
      return "$lhs***$rhs";
    }
  }

  // _removeBank() async {
  //   try {
  //     _controller.setLoading(true);
  //     Map _payload = {
  //       "email_address": widget.data['user_id'],
  //     };

  //     print("ID :: ${widget.data['id']}");
  //     print("ID :: $_payload");

  //     final _prefs = await SharedPreferences.getInstance();
  //     final _accessToken = _prefs.getString('accessToken') ?? "";

  //     final _response = await APIService().removeBank(
  //         accessToken: _accessToken, payload: _payload, bankId: widget.data['id']);
  //     _controller.setLoading(false);
  //   } catch (e) {
  //     _controller.setLoading(false);
  //     debugPrint(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Container(
          padding: const EdgeInsets.only(
            top: 8.0,
            left: 8.0,
            bottom: 8.0,
            right: 0.0,
          ),
          decoration: widget.isChecked
              ? BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                )
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: '${widget.data['logo']}',
                    width: 48,
                  ),
                  const SizedBox(height: 2.0),
                  TextBody2(
                    text: '${widget.data['name']}',
                    color: Theme.of(context).colorScheme.tertiary,
                    align: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(width: 3.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextMedium(
                      text: '${widget.data['account_name']}',
                      align: TextAlign.center,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    TextBody2(
                      text: '${_obscurer(widget.data['account_number'])}',
                      color: Theme.of(context).colorScheme.tertiary,
                      align: TextAlign.center,
                    )
                  ],
                ),
              ),
              const SizedBox(width: 3.0),
              widget.isChecked
                  ? CupertinoCheckbox(
                      value: true,
                      onChanged: (val) {},
                    )
                  : Radio(
                      activeColor: Theme.of(context).colorScheme.tertiary,
                      value: widget.data,
                      groupValue: widget.list,
                      onChanged: null,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
