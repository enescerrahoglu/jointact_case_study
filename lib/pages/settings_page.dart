import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/localization/language.dart';
import 'package:jointact_case_study/localization/language_localization.dart';
import 'package:jointact_case_study/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Language? selectedLanguage;
  List<Language>? languages;

  @override
  void initState() {
    super.initState();
    languages = Language.languageList();
  }

  void _changeLanguage(Language language) async {
    Locale locale = await setLocale(language.languageCode);

    if (mounted) {
      MyApp.setLocale(context, locale);
    }
  }

  _setSelectedLang(Language lang) {
    setState(() {
      selectedLanguage = lang;
    });
  }

  Locale? _locale;
  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      if (locale == null) {
        setState(() {
          _locale = View.of(context).platformDispatcher.locale;
          selectedLanguage = languages!.firstWhere(
              (element) => element.languageCode == _locale!.languageCode);
        });
      } else {
        setState(() {
          _locale = locale;
          selectedLanguage = languages!.firstWhere(
              (element) => element.languageCode == _locale!.languageCode);
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        title: Text(
          getTranslated(context, StringKeys.settings),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text(
                getTranslated(context, StringKeys.appLanguage),
                style: const TextStyle(fontSize: 18),
              ),
              leading: const Icon(Icons.language_rounded),
              onTap: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  useSafeArea: true,
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          AppBar(
                            surfaceTintColor: Colors.transparent,
                            systemOverlayStyle: const SystemUiOverlayStyle(
                              statusBarColor: Colors.transparent,
                              statusBarIconBrightness: Brightness.dark,
                              statusBarBrightness: Brightness.light,
                            ),
                            centerTitle: true,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            title: Text(
                              getTranslated(context, StringKeys.appLanguage),
                              style: const TextStyle(fontSize: 16),
                            ),
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_rounded),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          ...languages!.map((language) {
                            return Padding(
                              padding: languages!.indexOf(language) == 0
                                  ? const EdgeInsets.only(
                                      top: 10, left: 10, right: 10)
                                  : languages!.indexOf(language) ==
                                          (languages!.length - 1)
                                      ? const EdgeInsets.only(
                                          bottom: 10, left: 10, right: 10)
                                      : const EdgeInsets.only(
                                          left: 10, right: 10),
                              child: ListTile(
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                title: Text(
                                  language.name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                leading: Radio(
                                  visualDensity: const VisualDensity(
                                      horizontal: VisualDensity.minimumDensity,
                                      vertical: VisualDensity.minimumDensity),
                                  // activeColor: primaryColor,
                                  value: language,
                                  groupValue: selectedLanguage,
                                  onChanged: (selectedLanguage) async {
                                    _setSelectedLang(
                                        selectedLanguage as Language);
                                    _changeLanguage(selectedLanguage);
                                    selectedLanguage = language;
                                    Navigator.pop(context);
                                  },
                                ),
                                onTap: () async {
                                  _setSelectedLang(
                                      selectedLanguage as Language);
                                  _changeLanguage(language);
                                  selectedLanguage = language;
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
