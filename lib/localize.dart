import 'package:flutter/cupertino.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ja'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class AppLocalizations {
  final LocalizeMessages messages;

  AppLocalizations(Locale locale) : this.messages = LocalizeMessages.of(locale);

  static LocalizeMessages of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!
        .messages;
  }
}

class LocalizeMessages {
  final String greet;

  LocalizeMessages({
    required this.greet,
  });

  factory LocalizeMessages.of(Locale locale) {
    switch (locale.languageCode) {
      case 'ja':
        return LocalizeMessages.ja();
      case 'en':
        return LocalizeMessages.en();
      default:
        return LocalizeMessages.en();
    }
  }

  factory LocalizeMessages.ja() => LocalizeMessages(
        greet: 'こんにちは',
      );

  factory LocalizeMessages.en() => LocalizeMessages(
        greet: 'Hello',
      );
}
