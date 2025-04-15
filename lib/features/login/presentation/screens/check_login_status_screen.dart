import 'package:flutter/material.dart';

class CheckLoginStatusScreen extends StatelessWidget 
{
  const CheckLoginStatusScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {  
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
