import 'dart:convert';
import 'dart:io';

import 'options.dart';

class ArbMerge {
  final Options options;

  const ArbMerge(this.options);

  Future<void> run() async {
    options.verify();

    final files = options.files().toList();

    if (options.secondarySource != null) {
      final secondaryFiles = options.secondaryFiles();
      files.addAll(secondaryFiles);
    }

    final Map<String, Map<String, dynamic>> localeMap = {};

    for (var file in files) {
      final content = await File(file.path).readAsString();
      final Map<String, dynamic> jsonContent = json.decode(content);

      final locale = jsonContent['@@locale'];
      if (locale != null) {
        if (!localeMap.containsKey(locale)) {
          localeMap[locale] = {};
        }
        localeMap[locale]?.addAll(jsonContent);
      }
    }
    const encoder = JsonEncoder.withIndent('  ');
    final sortedLocaleKeys = localeMap.keys.toList()..sort();
    for (var locale in sortedLocaleKeys) {
      final mergedContent = encoder.convert(localeMap[locale]);
      options.write(locale, mergedContent);
    }
  }
}



/* main(List<String> args) {
  const options = Options(
      source: '/Volumes/WD_SN770_2TB/Github/abcx3_flutter/lib/l10n_static',
      secondarySource:
          '/Volumes/WD_SN770_2TB/Github/abcx3_flutter/lib/l10n_auto_translate',
      destination: '/Volumes/WD_SN770_2TB/Github/abcx3_flutter/lib/l10n',
      fileTemplate: "intl_{lang}.arb");
  const arbGlue = ArbGlue(options);
  arbGlue.run();
} */