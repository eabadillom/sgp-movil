import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItems {
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

const appMenuItem = <MenuItems>[
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
    link: '/Permisos',
    icon: Icons.assignment_turned_in,
  ),

  MenuItems(
    title: 'Ausencias',
    subTitle: 'Justificar las ausencias',
    link: '/justificar_faltas',
    icon: Icons.person_off,
  ),

  MenuItems(
    title: 'Retardos',
    subTitle: 'Justificar los retardos',
    link: '/justificar_retardos',
    icon: Icons.hourglass_empty,
  ),

  MenuItems(
    title: 'Uniformes',
    subTitle: 'Solicitud de uniformes',
    link: '/uniformes',
    icon: FontAwesomeIcons.shirt ,
  ),

  MenuItems(
    title: 'Articulos',
    subTitle: 'Solicitud de articulos',
    link: '/articulos',
    icon: Icons.cleaning_services_rounded,
  ),
];
