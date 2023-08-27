import 'package:flutter/material.dart';
import 'dart:ui';

abstract class AppLocales {
  static const es = LangVo('Espanol', 'Spanish', 'es', Locale('es'), '🇪🇸');
  static const en = LangVo('English', 'English', 'en', Locale('en'), '🇬🇧');
  static List<Locale> get supportedLocales => [en.locale, es.locale];
  static List<LangVo> get listedLocales => [en, es];
}

class LangVo {
  final String nativeName, englishName, key, flagChar;
  final Locale locale;
  const LangVo(
    this.nativeName,
    this.englishName,
    this.key,
    this.locale, [
    this.flagChar = '',
  ]);
  @override
  String toString() =>
      'LangVo {nativeName: "$nativeName", englishName: "$englishName", locale: $locale, emoji: this.flagChar}';
}
