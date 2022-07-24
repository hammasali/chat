import 'package:flutter/material.dart';
import '../const/colors.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    required String hintText,
    required onChange,
    required onSaved,
    required onValidate,
    EdgeInsets padding = const EdgeInsets.only(left: 20, right: 10),
    Key? key,
  })  : _hintText = hintText,
        _padding = padding,
        _onChange = onChange,
        _onSaved = onSaved,
        _onValidate = onValidate,
        super(key: key);

  final String _hintText;
  final EdgeInsets _padding;
  final _onChange, _onSaved, _onValidate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const ShapeDecoration(
        color: AppColor.placeholderBg,
        shape: StadiumBorder(),
      ),
      child: TextFormField(
        onChanged: _onChange,
        onSaved: _onSaved,
        validator: _onValidate,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: _hintText,
          hintStyle: const TextStyle(
            color: AppColor.placeholder,
          ),
          contentPadding: _padding,
        ),
      ),
    );
  }
}
