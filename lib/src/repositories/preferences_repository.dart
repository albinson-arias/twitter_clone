import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../l10n/app_locales.dart';

enum PreferencesCollections { locale }

class PreferencesRepository {
  late final StreamingSharedPreferences prefs;
  PreferencesRepository() {
    _init();
  }

  void _init() {
    StreamingSharedPreferences.instance.then((value) => prefs = value);
  }

  Future<void> setString(String key, String data) async {
    await prefs.setString(key, data);
  }

  Future<void> setInt(String key, int data) async {
    await prefs.setInt(key, data);
  }

  int getInt(String key) {
    return prefs.getInt(key, defaultValue: 0).getValue();
  }

  Stream<int> watchInt(String key) {
    return prefs.getInt(key, defaultValue: 0);
  }

  String? getString(String key) {
    final result = prefs.getString(key, defaultValue: 'null').getValue();
    return result == 'null' ? null : result;
  }

  Stream<String> watchString(String key) {
    return prefs.getString(key, defaultValue: 'null');
  }
}

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepository();
});

final localeProvider = Provider.autoDispose<Locale>((ref) {
  final repository = ref.watch(preferencesRepositoryProvider);
  late final Locale locale;
  final preferenceLocale =
      repository.getString(PreferencesCollections.locale.name);
  if (preferenceLocale == null) {
    final localLocale = Platform.localeName;
    if (localLocale.split('_').first == 'es') {
      locale = AppLocales.es.locale;
    } else {
      locale = AppLocales.en.locale;
    }
    repository.setString(
        PreferencesCollections.locale.name, locale.languageCode);
  } else {
    locale = Locale(preferenceLocale);
  }

  return locale;
});

final localeStreamProvider = StreamProvider<Locale>((ref) {
  final repository = ref.watch(preferencesRepositoryProvider);

  return repository
      .watchString(PreferencesCollections.locale.name)
      .map((event) => Locale(event));
});
