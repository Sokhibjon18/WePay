import 'package:flutter/material.dart';
import 'package:we_pay/application/product/product_form/product_form_bloc.dart';
import 'package:we_pay/presentation/constants/colors.dart';
import 'package:we_pay/presentation/screens/expense/date_picker/product_date_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_pay/presentation/screens/utils/functions.dart';

class DateTextFormField extends StatefulWidget {
  const DateTextFormField({Key? key}) : super(key: key);

  @override
  State<DateTextFormField> createState() => _DateTextFormFieldState();
}

class _DateTextFormFieldState extends State<DateTextFormField> {
  DateTime date = DateTime.now();
  late TextEditingController tec;

  @override
  void initState() {
    tec = TextEditingController();
    tec.text = getDayMonthYear(date);
    super.initState();
  }

  @override
  void dispose() {
    tec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () async {
        date = await showDatePickerForProduct(context) ?? date;
        tec.text = getDayMonthYear(date);
        // ignore: use_build_context_synchronously
        context.read<ProductFormBloc>().add(ProductFormEvent.dateChanged(date));
      },
      cursorColor: Colors.white,
      readOnly: true,
      controller: tec,
      decoration: InputDecoration(
        labelText: 'Date',
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey[100]!),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: grey),
        ),
      ),
    );
  }
}
