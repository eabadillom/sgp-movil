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
    required this.icon,
  });
}

const appMenuItem = <MenuItems> 
[
  MenuItems(
    title: 'Incapacidad', 
    subTitle: 'Solicitud de incapacidades', 
    link: '/incapacidades',
    icon: Icons.health_and_safety_outlined,
  ),

  MenuItems(
    title: 'Vacaciones',
    subTitle: 'Solicitud de vacaciones',
    link: '/vacaciones',
    icon: Icons.airplanemode_active,
  ),

  MenuItems(
    title: 'Permisos',
    subTitle: 'Solicitud de permisos',
    link: '/permisos',
    icon: Icons.assignment_turned_in,
  ),

  MenuItems(
    title: 'Faltas',
    subTitle: 'Justificar las faltas',
    link: '/justificar_faltas',
    icon: Icons.account_box_rounded,
  ),

  MenuItems(
    title: 'Retardos',
    subTitle: 'Justificar los retardos',
    link: '/justificar_retardos',
    icon: Icons.alarm,
  ),

  MenuItems(
    title: 'Uniformes',
    subTitle: 'Solicitud de uniformes',
    link: '/uniformes',
    icon: Icons.dry_cleaning,
  ),
  
  MenuItems(
    title: 'Articulos',
    subTitle: 'Solicitud de articulos',
    link: '/articulos',
    icon: Icons.handyman,
  ),

];