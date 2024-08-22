import 'dart:io';

import 'package:logging/logging.dart';
import 'package:path/path.dart';

class FileOperations {
  static Iterable<File> getMultiFiles(List<String> folders) sync* {
    for (var folder in folders) {
      yield* getFiles(folder);
    }
  }

  static Iterable<File> getFiles(String folder) sync* {
    final directory = Directory(folder);
    if (!directory.existsSync()) {
      Logger.root.warning('Directory $folder does not exist.');
      return;
    }

    final all = directory.listSync(recursive: true);
    final arbFiles = all
        .where((e) =>
            e is File && (e.path.endsWith('.arb') || e.path.endsWith('.json')))
        .cast<File>();

    if (arbFiles.isEmpty) {
      Logger.root.warning('No .arb files found in directory $folder.');
    } else {
      Logger.root
          .info('Found ${arbFiles.length} .arb files in directory $folder.');
    }
    yield* arbFiles;
  }

  static void write(String folder, String fileName, String content) {
    final path = join(folder, fileName);
    Logger.root.info('writing to $path');
    File(path).writeAsStringSync(content);
  }
}
