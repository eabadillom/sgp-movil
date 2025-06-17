import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sgp_movil/conf/util/format_util.dart';

class DatePickerField extends StatefulWidget 
{
  final TextEditingController controller;
  final String? Function(String?)? validator; 

  const DatePickerField({
    super.key, 
    required this.controller,
    this.validator,
  });

  @override
  DatePickerFieldState createState() => DatePickerFieldState();
}

class DatePickerFieldState extends State<DatePickerField> 
{
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyyTHH:mm');

  Future<void> _selectDate(BuildContext context) async 
  {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // fecha inicial
      firstDate: DateTime(1900),   // fecha mínima
      lastDate: DateTime(2100),    // fecha máxima
    );

    if (picked != null) 
    {
      String formatted = _dateFormat.format(picked);
      DateTime parsed = _dateFormat.parse(formatted);
      setState(() {
        widget.controller.text = FormatUtil.stringToStandard(FormatUtil.dateFormated(parsed));
      });
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Fecha',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: widget.validator,
      onTap: () => _selectDate(context),
    );
  }
}
