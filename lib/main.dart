import 'package:flutter/material.dart';
import 'package:my_tool_box/l10n/l10n.dart';
import 'package:my_tool_box/languageChangeProvider.dart';
import 'package:my_tool_box/pages/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LanguageChangeProvider>(
        create: (context) => LanguageChangeProvider(),
        child: Builder(
            builder: (context) => MaterialApp(
                  locale:
                      Provider.of<LanguageChangeProvider>(context, listen: true)
                          .currentLocale,
                  theme: ThemeData(
                    primarySwatch: Colors.red,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  localeResolutionCallback: (
                    Locale? locale,
                    Iterable<Locale> supportedLocales,
                  ) {
                    return locale;
                  },
                  supportedLocales: L10n.all,
                  home: Home(),
                )));
  }
}
