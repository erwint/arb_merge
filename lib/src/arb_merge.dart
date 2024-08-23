import 'dart:convert';
import 'dart:io';

import 'package:arb_merge/src/file_operations.dart';

import 'options.dart';

class ArbMerge {
  final Options options;

  const ArbMerge(this.options);

  Future<void> run() async {
    options.validate();

    // final files = options.files().toList();
    final files = FileOperations.getMultiFiles(options.sources!).toList();

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
      var langContent = localeMap[locale];
      if (options.sort) {
        print('sorting $locale');
        langContent = sortArbKeys(langContent!);
      }
      final mergedContent = encoder.convert(langContent);
      // options.write(locale, mergedContent);
      final fileName = options.pattern.replaceAll('{lang}', locale);
      FileOperations.write(options.destination!, fileName, mergedContent);
    }
  }

  sortArbKeys(Map<String, dynamic> arb) {
    return Map.fromEntries(
      arb.entries.toList()
        ..sort((a, b) {
          final keyA = a.key.startsWith("@") ? a.key.substring(1) : a.key;
          final keyB = b.key.startsWith("@") ? b.key.substring(1) : b.key;
          return keyA.compareTo(keyB);
        }),
    );
  }
}

/* main(List<String> args) {
  const options = Options(
      source: '/Volumes/WD_SN770_2TB/Github/abcx3_flutter/lib/l10n_static',
      secondarySource:
          '/Volumes/WD_SN770_2TB/Github/abcx3_flutter/lib/l10n_auto_translate',
      destination: '/Volumes/WD_SN770_2TB/Github/abcx3_flutter/lib/l10n',
      fileTemplate: "intl_{lang}.arb");
  const arbMerge = ArbMerge(options);
  arbMerge.run();
} */
