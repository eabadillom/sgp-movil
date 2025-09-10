import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItems {
  final String title;
  final String link;
  final IconData icon;

  const MenuItems({
    required this.title,
    required this.link,
    required this.icon,
  });
}

const appMenuItem = <MenuItems>[
  MenuItems(
    title: 'Incapacidades',
    link: '/incapacidades',
    icon: Icons.health_and_safety_outlined,
  ),

  MenuItems(
    title: 'Vacaciones',
    link: '/vacaciones',
    icon: FontAwesomeIcons.suitcaseRolling,
  ),

  MenuItems(
    title: 'Permisos',
    link: '/Permisos',
    icon: Icons.assignment_turned_in,
  ),

  MenuItems(
    title: 'Ausencias',
    link: '/justificar_faltas',
    icon: Icons.person_off,
  ),

  MenuItems(
    title: 'Retardos',
    link: '/justificar_retardos',
    icon: Icons.hourglass_empty,
  ),

  MenuItems(
    title: 'Uniformes',
    link: '/uniformes',
    icon: FontAwesomeIcons.shirt ,
  ),

  MenuItems(
    title: 'Artículos',
    link: '/articulos',
    icon: Icons.cleaning_services_rounded,
  ),
];
