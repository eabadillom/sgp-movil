import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

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
      setState(() {
        widget.controller.text = _dateFormat.format(picked);
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
