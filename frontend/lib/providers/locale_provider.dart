import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('id');

  Locale get locale => _locale;
  String get languageCode => _locale.languageCode;

  void setLocale(Locale newLocale) {
    if (newLocale.languageCode != _locale.languageCode) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  void toggleLocale() {
    if (_locale.languageCode == 'id') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('id'));
    }
  }
}

