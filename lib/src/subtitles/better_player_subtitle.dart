import 'package:better_player_plus/src/core/better_player_utils.dart';

class BetterPlayerSubtitle {
  static const String timerSeparator = ' --> ';
  final int? index;
  final Duration? start;
  final Duration? end;
  final List<String>? texts;

  BetterPlayerSubtitle._({
    this.index,
    this.start,
    this.end,
    this.texts,
  });

  factory BetterPlayerSubtitle(String value, bool isWebVTT) {
    try {
      final scanner = value.split('\n');
      if (scanner.length == 2) {
        return _handle2LinesSubtitles(scanner);
      }
      if (scanner.length > 2) {
        return _handle3LinesAndMoreSubtitles(scanner, isWebVTT);
      }
      return BetterPlayerSubtitle._();
    } on Exception catch (_) {
      BetterPlayerUtils.log("Failed to parse subtitle line: $value");
      return BetterPlayerSubtitle._();
    }
  }

  static BetterPlayerSubtitle _handle2LinesSubtitles(List<String> scanner) {
    try {
      if (scanner.isEmpty || !scanner[0].contains(timerSeparator)) {
        return BetterPlayerSubtitle._();
      }

      final timeSplit = scanner[0].split(timerSeparator);
      if (timeSplit.length != 2) {
        return BetterPlayerSubtitle._();
      }

      final start = _stringToDuration(timeSplit[0]);
      final end = _stringToDuration(timeSplit[1]);
      
      if (start == const Duration() && end == const Duration()) {
        return BetterPlayerSubtitle._();
      }

      List<String> texts = [];
      if (scanner.length > 1) {
        texts = scanner.sublist(1, scanner.length);
      } else {
        return BetterPlayerSubtitle._();
      }

      return BetterPlayerSubtitle._(
        index: -1,
        start: start,
        end: end,
        texts: texts,
      );
    } on Exception catch (_) {
      BetterPlayerUtils.log("Failed to parse subtitle line: $scanner");
      return BetterPlayerSubtitle._();
    }
  }

  static BetterPlayerSubtitle _handle3LinesAndMoreSubtitles(
      List<String> scanner, bool isWebVTT) {
    try {
      if (scanner.isEmpty) {
        return BetterPlayerSubtitle._();
      }
      
      int? index = -1;
      List<String> timeSplit = [];
      int firstLineOfText = 0;
      
      if (scanner[0].contains(timerSeparator)) {
        timeSplit = scanner[0].split(timerSeparator);
        firstLineOfText = 1;
      } else {
        if (scanner.length < 2 || !scanner[1].contains(timerSeparator)) {
          return BetterPlayerSubtitle._();
        }
        index = int.tryParse(scanner[0]);
        timeSplit = scanner[1].split(timerSeparator);
        firstLineOfText = 2;
      }

      if (timeSplit.length != 2) {
        return BetterPlayerSubtitle._();
      }

      final start = _stringToDuration(timeSplit[0]);
      final end = _stringToDuration(timeSplit[1]);
      
      if (start == const Duration() && end == const Duration()) {
        return BetterPlayerSubtitle._();
      }

      List<String> texts = [];
      if (firstLineOfText < scanner.length) {
        texts = scanner.sublist(firstLineOfText, scanner.length);
      } else {
        return BetterPlayerSubtitle._();
      }

      return BetterPlayerSubtitle._(
          index: index, start: start, end: end, texts: texts);
    } on Exception catch (_) {
      BetterPlayerUtils.log("Failed to parse subtitle line: $scanner");
      return BetterPlayerSubtitle._();
    }
  }

  static Duration _stringToDuration(String value) {
    try {
      if (value.trim().isEmpty) {
        return const Duration();
      }

      final valueSplit = value.split(" ");
      String componentValue;

      if (valueSplit.length > 1) {
        componentValue = valueSplit[0];
      } else {
        componentValue = value;
      }

      final component = componentValue.split(':');
      // Interpret a missing hour component to mean 00 hours
      if (component.length == 2) {
        component.insert(0, "00");
      } else if (component.length != 3) {
        return const Duration();
      }

      final secsAndMillisSplitChar = component[2].contains(',') ? ',' : '.';
      final secsAndMillsSplit = component[2].split(secsAndMillisSplitChar);
      if (secsAndMillsSplit.length != 2) {
        return const Duration();
      }

      final hours = int.tryParse(component[0]);
      final minutes = int.tryParse(component[1]);
      final seconds = int.tryParse(secsAndMillsSplit[0]);
      final milliseconds = int.tryParse(secsAndMillsSplit[1]);

      if (hours == null || minutes == null || seconds == null || milliseconds == null) {
        return const Duration();
      }

      if (hours < 0 || minutes < 0 || minutes >= 60 || seconds < 0 || seconds >= 60 || milliseconds < 0) {
        return const Duration();
      }

      final result = Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
      );
      return result;
    } on Exception catch (_) {
      BetterPlayerUtils.log("Failed to process value: $value");
      return const Duration();
    }
  }

  @override
  String toString() {
    return 'BetterPlayerSubtitle{index: $index, start: $start, end: $end, texts: $texts}';
  }
}
