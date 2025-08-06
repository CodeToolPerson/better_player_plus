import 'dart:convert';
import 'dart:io';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:better_player_plus/src/core/better_player_utils.dart';
import 'better_player_subtitle.dart';

class BetterPlayerSubtitlesFactory {
  static Future<List<BetterPlayerSubtitle>> parseSubtitles(
      BetterPlayerSubtitlesSource source) async {
    switch (source.type) {
      case BetterPlayerSubtitlesSourceType.file:
        return _parseSubtitlesFromFile(source);
      case BetterPlayerSubtitlesSourceType.network:
        return _parseSubtitlesFromNetwork(source);
      case BetterPlayerSubtitlesSourceType.memory:
        return _parseSubtitlesFromMemory(source);
      default:
        return [];
    }
  }

  static Future<List<BetterPlayerSubtitle>> _parseSubtitlesFromFile(
      BetterPlayerSubtitlesSource source) async {
    try {
      final List<BetterPlayerSubtitle> subtitles = [];
      for (final String? url in source.urls!) {
        final file = File(url!);
        if (file.existsSync()) {
          final String fileContent = await file.readAsString();
          final subtitlesCache = _parseString(fileContent);
          subtitles.addAll(subtitlesCache);
        } else {
          BetterPlayerUtils.log("$url doesn't exist!");
        }
      }
      return subtitles;
    } on Exception catch (exception) {
      BetterPlayerUtils.log("Failed to read subtitles from file: $exception");
    }
    return [];
  }

  static Future<List<BetterPlayerSubtitle>> _parseSubtitlesFromNetwork(
      BetterPlayerSubtitlesSource source) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 30);
      final List<BetterPlayerSubtitle> subtitles = [];
      
      for (final String? url in source.urls!) {
        if (url == null || url.trim().isEmpty) {
          continue;
        }

        try {
          final request = await client.getUrl(Uri.parse(url));
          source.headers?.keys.forEach((key) {
            final value = source.headers![key];
            if (value != null) {
              request.headers.add(key, value);
            }
          });
          
          final response = await request.close();
          
          if (response.statusCode != 200) {
            continue;
          }

          final data = await response.transform(const Utf8Decoder()).join();
          
          if (data.trim().isEmpty) {
            continue;
          }

          if (data.trim().startsWith('#EXTM3U') && !_isValidSubtitleContent(data)) {
            continue;
          }

          final cacheList = _parseString(data);
          subtitles.addAll(cacheList);
          
        } catch (e) {
          BetterPlayerUtils.log("Failed to load subtitle from $url: $e");
          continue;
        }
      }
      client.close();

      BetterPlayerUtils.log("Parsed total subtitles: ${subtitles.length}");
      return subtitles;
    } on Exception catch (exception) {
      BetterPlayerUtils.log(
          "Failed to read subtitles from network: $exception");
    }
    return [];
  }

  static List<BetterPlayerSubtitle> _parseSubtitlesFromMemory(
      BetterPlayerSubtitlesSource source) {
    try {
      return _parseString(source.content!);
    } on Exception catch (exception) {
      BetterPlayerUtils.log("Failed to read subtitles from memory: $exception");
    }
    return [];
  }

  static List<BetterPlayerSubtitle> _parseString(String value) {
    try {
      if (value.trim().isEmpty) {
        return [];
      }

      if (value.trim().startsWith('#EXTM3U') && !_isValidSubtitleContent(value)) {
        return [];
      }

      List<String> components = value.split('\r\n\r\n');
      if (components.length == 1) {
        components = value.split('\n\n');
      }

      // Skip parsing files with no cues
      if (components.length == 1) {
        return [];
      }

      final List<BetterPlayerSubtitle> subtitlesObj = [];
      final bool isWebVTT = components.contains("WEBVTT");

      for (final component in components) {
        if (component.trim().isEmpty) {
          continue;
        }
        
        try {
          final subtitle = BetterPlayerSubtitle(component, isWebVTT);
          if (subtitle.start != null &&
              subtitle.end != null &&
              subtitle.texts != null &&
              subtitle.texts!.isNotEmpty) {
            subtitlesObj.add(subtitle);
          }
        } catch (e) {
          continue;
        }
      }

      return subtitlesObj;
    } catch (e) {
      BetterPlayerUtils.log("Failed to parse subtitle string: $e");
      return [];
    }
  }

  /// Validates whether content is actual subtitle content and not an M3U8 playlist
  static bool _isValidSubtitleContent(String content) {
    final lines = content.split('\n');
    
    // WebVTT subtitles should contain WEBVTT header
    if (content.contains('WEBVTT')) {
      return true;
    }
    
    // SRT subtitles usually contain timestamp format
    for (final line in lines) {
      if (line.contains('-->') && 
          (line.contains(':') || line.contains('.'))) {
        return true;
      }
    }
    
    // If it contains M3U8 specific tags but no subtitle timestamps, it's not subtitle
    final hasM3u8Tags = content.contains('#EXT-X-') || 
                       content.contains('#EXTINF') ||
                       content.contains('#EXT-X-TARGETDURATION');
    
    return !hasM3u8Tags;
  }
}
