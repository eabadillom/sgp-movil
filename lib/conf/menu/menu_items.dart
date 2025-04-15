import 'package:flutter/material.dart';

class MenuItems 
{
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItems({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon
  });
}

const appMenuItem = <MenuItems> 
[
  MenuItems(
    title: 'Incapacidades', 
    subTitle: 'Solicitud de incapacidades del empleado', 
    link: '/incapacidades', 
    icon: Icons.clear_all_rounded
  ),

  MenuItems(
    title: 'Vacaciones',
    subTitle: 'Solicitud de vacaciones del empleado',
    link: '/vacaciones',
    icon: Icons.clear_all_rounded
  ),

  MenuItems(
    title: 'Permisos',
    subTitle: 'Solicitud de permisos del empleado',
    link: '/permisos',
    icon: Icons.clear_all_rounded
  ),

  MenuItems(
    title: 'Justificar Faltas',
    subTitle: 'Justificar las faltas del empleado',
    link: '/justificar_faltas',
    icon: Icons.clear_all_rounded
  ),

  MenuItems(
    title: 'Justificar Retardos',
    subTitle: 'Justificar los retardos del empleado',
    link: '/justificar_retardos',
    icon: Icons.clear_all_rounded
  ),

  MenuItems(
    title: 'Uniformes',
    subTitle: 'Solicitud de uniformes del empleado',
    link: '/uniformes',
    icon: Icons.clear_all_rounded
  ),
  
  MenuItems(
    title: 'Articulos',
    subTitle: 'Solicitud de articulos del empleado',
    link: '/articulos',
    icon: Icons.clear_all_rounded
  ),

];