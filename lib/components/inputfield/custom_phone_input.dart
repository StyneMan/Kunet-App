import 'package:kunet_app/components/text/textComponents.dart';
import 'package:kunet_app/helper/state/state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'textfield.dart';

typedef void InitCallback(var value);

class CustonPhoneInputWithSheet extends StatefulWidget {
  final InitCallback onSelected;
  var items;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final String hintText;
  final String errorText;
  final String helperText;
  final String caller;
  var validator;

  CustonPhoneInputWithSheet({
    Key? key,
    required this.items,
    required this.onSelected,
    required this.onChanged,
    required this.controller,
    required this.validator,
    this.hintText = "",
    this.helperText = "",
    this.errorText = "",
    required this.caller,
  }) : super(key: key);

  @override
  State<CustonPhoneInputWithSheet> createState() =>
      _CustonPhoneInputWithSheetState();
}

class _CustonPhoneInputWithSheetState extends State<CustonPhoneInputWithSheet> {
  var selectVal;
  final _searchController = TextEditingController();
  final _phoneController = TextEditingController();
  final _controller = Get.find<StateController>();

  String _countryCode = "+234",
      _errorMsg = "",
      _countryFlag = 'https://vtpass.com/resources/images/flags/NG.png';

  @override
  void initState() {
    super.initState();
  }

  _filter(String keyword) {
    print("FILTERING  ::: $keyword");
    if (keyword.isNotEmpty) {
      final _filtered = widget.items
          .where(
            (element) => element['name'].toString().toLowerCase().contains(
                  keyword.toLowerCase(),
                ),
          )
          .toList();

      print("FILTERED LIST  ::: ${_filtered}");
      if (widget.caller == "data") {
        _controller.filteredVTUDataCountries.value = _filtered;
      } else if (widget.caller == "topup") {
        _controller.filteredVTUCountries.value = _filtered;
      }
    } else {
      if (widget.caller == "data") {
        _controller.filteredVTUDataCountries.value = widget.items;
      } else if (widget.caller == "topup") {
        _controller.filteredVTUCountries.value = widget.items;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomTextField(
        onChanged: widget.onChanged,
        controller: widget.controller,
        validator: widget.validator,
        errorText: widget.errorText,
        hintText: widget.hintText,
        inputType: TextInputType.number,
        prefix: SizedBox(
          width: 105.0,
          child: TextButton(
            onPressed: () {
              _showChooser();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 4.0),
                Image.network(
                  _countryFlag,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 8.0),
                TextBody2(
                  text: _countryCode,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const Icon(Icons.keyboard_arrow_down, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showChooser() {
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(21),
            topRight: Radius.circular(21),
          ),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            CustomTextField(
              onChanged: (e) {
                _filter(e);
              },
              prefix: const Icon(CupertinoIcons.search),
              controller: _searchController,
              validator: (value) {},
              inputType: TextInputType.text,
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  itemBuilder: (context, index) => TextButton(
                    onPressed: () {
                      widget.onSelected(
                        widget.caller == "topup"
                            ? _controller.filteredVTUCountries.value[index]
                            : _controller.filteredVTUDataCountries.value[index],
                      );
                      setState(() {
                        selectVal = widget.caller == "topup"
                            ? _controller.filteredVTUCountries.value[index]
                                ['name']
                            : _controller.filteredVTUDataCountries.value[index]
                                ['name'];

                        _countryCode =
                            "+${widget.caller == "topup" ? _controller.filteredVTUCountries.value[index]['prefix'] : _controller.filteredVTUDataCountries.value[index]['prefix']}";

                        _countryFlag = widget.caller == "topup"
                            ? _controller.filteredVTUCountries.value[index]
                                ['flag']
                            : _controller.filteredVTUDataCountries.value[index]
                                ['flag'];
                      });
                      // _controller.filteredStates.value =
                      //     _controller.filteredCountries.value[index]['states'];
                      Get.back();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 4.0),
                        Image.network(
                          '${widget.caller == "topup" ? _controller.filteredVTUCountries.value[index]['flag'] : _controller.filteredVTUDataCountries.value[index]['flag']}',
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8.0),
                        TextBody2(
                          text:
                              '${widget.caller == "topup" ? _controller.filteredVTUCountries.value[index]['prefix'] : _controller.filteredVTUDataCountries.value[index]['prefix']}',
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          '${widget.caller == "topup" ? _controller.filteredVTUCountries.value[index]['name'] : _controller.filteredVTUDataCountries.value[index]['name']}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: widget.caller == "topup"
                      ? _controller.filteredVTUCountries.value.length
                      : _controller.filteredVTUDataCountries.value.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
