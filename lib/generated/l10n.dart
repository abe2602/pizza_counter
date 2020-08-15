// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `PizzaCounter`
  String get appName {
    return Intl.message(
      'PizzaCounter',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Generic Error`
  String get genericErrorMessage {
    return Intl.message(
      'Generic Error',
      name: 'genericErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get tryAgainButtonLabel {
    return Intl.message(
      'Try Again',
      name: 'tryAgainButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Looks like there's no internet , \n Try to connect into internet ;)`
  String get noInternetMessage {
    return Intl.message(
      'Looks like there\'s no internet , \n Try to connect into internet ;)',
      name: 'noInternetMessage',
      desc: '',
      args: [],
    );
  }

  /// `Empty Field`
  String get emptyFieldError {
    return Intl.message(
      'Empty Field',
      name: 'emptyFieldError',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Field`
  String get invalidFieldError {
    return Intl.message(
      'Invalid Field',
      name: 'invalidFieldError',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get nameLabel {
    return Intl.message(
      'Name',
      name: 'nameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message(
      'Email',
      name: 'emailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message(
      'Password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password Confirmation`
  String get passwordConfirmationLabel {
    return Intl.message(
      'Password Confirmation',
      name: 'passwordConfirmationLabel',
      desc: '',
      args: [],
    );
  }

  /// `Counter`
  String get pizzaCounterTabLabel {
    return Intl.message(
      'Counter',
      name: 'pizzaCounterTabLabel',
      desc: '',
      args: [],
    );
  }

  /// `Charts`
  String get pizzaChartsTabLabel {
    return Intl.message(
      'Charts',
      name: 'pizzaChartsTabLabel',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelLabel {
    return Intl.message(
      'Cancel',
      name: 'cancelLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get addLabel {
    return Intl.message(
      'Add',
      name: 'addLabel',
      desc: '',
      args: [],
    );
  }

  /// `Add a new player!`
  String get addPlayerLabel {
    return Intl.message(
      'Add a new player!',
      name: 'addPlayerLabel',
      desc: '',
      args: [],
    );
  }

  /// `There's no players right now :(.`
  String get noPlayersEmptyStatePrimaryText {
    return Intl.message(
      'There\'s no players right now :(.',
      name: 'noPlayersEmptyStatePrimaryText',
      desc: '',
      args: [],
    );
  }

  /// `Add some and start to competing!`
  String get noPlayersEmptyStateSecondaryText {
    return Intl.message(
      'Add some and start to competing!',
      name: 'noPlayersEmptyStateSecondaryText',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}