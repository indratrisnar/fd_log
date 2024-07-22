library fd_log;

import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Log for your flow prosess
class FDLog {
  /// Log for your flow prosess
  FDLog({
    this.titleColorCode = 177,
    this.bodyColorCode = 111,
    this.prefix = 'FDLog',
    this.maxCharPerRow = 90,
    this.showHorizontalLine = true,
    this.showVerticalLine = true,
    this.lineColorCode = 244,
    this.countMaxCharPerRow = true,
    this.enable = true,
    this.useDebug = false,
  });

  static const String _resetColor = '\x1B[0m';
  static const String _topLeftCorner = '┌';
  static const String _topRightCorner = '┐';
  static const String _bottomLeftCorner = '└';
  static const String _bottomRightCorner = '┘';
  static const String _centerLeftCorner = '├';
  static const String _centerRightCorner = '┤';
  static const String _sideLine = '│';
  static const String _dashLine = '─';

  /// color code for title log, default: 177
  ///
  /// Order by Number
  ///
  /// ![Order by Number](https://raw.githubusercontent.com/indratrisnar/fd_log/main/pic/ordered_color_code.png)
  ///
  /// Order by Palette
  ///
  /// ![Order by Palette](https://raw.githubusercontent.com/indratrisnar/fd_log/main/pic/256_color_palette.png)
  final int titleColorCode;

  /// color code for body log, default: 111
  ///
  /// Order by Number
  ///
  /// ![Order by Number](https://raw.githubusercontent.com/indratrisnar/fd_log/main/pic/ordered_color_code.png)
  ///
  /// Order by Palette
  ///
  /// ![Order by Palette](https://raw.githubusercontent.com/indratrisnar/fd_log/main/pic/256_color_palette.png)
  final int bodyColorCode;

  /// color for line/border, default: 244
  ///
  /// Order by Number
  ///
  /// ![Order by Number](https://raw.githubusercontent.com/indratrisnar/fd_log/main/pic/ordered_color_code.png)
  ///
  /// Order by Palette
  ///
  /// ![Order by Palette](https://raw.githubusercontent.com/indratrisnar/fd_log/main/pic/256_color_palette.png)
  final int lineColorCode;

  /// header of log, default: 'FDLog'
  final String prefix;

  /// default: 90
  final int maxCharPerRow;

  /// show vertical line for each row
  ///
  /// default: true
  final bool showVerticalLine;

  /// show horizontal line for each row
  ///
  /// default: true
  final bool showHorizontalLine;

  /// count max char for each line
  final bool countMaxCharPerRow;

  /// log will be print out to console if true
  ///
  /// false == no execute it
  ///
  /// default: true
  final bool enable;

  /// print to console using debugPrint from material package
  ///
  /// default: false
  final bool useDebug;

  _execute(List<String?> messages) {
    for (String? e in messages) {
      if (e == null) continue;
      if (useDebug) {
        debugPrint(e);
      } else {
        developer.log(e, name: prefix);
      }
    }
  }

  String _ansiForegroundColor(int code) => '\x1B[38;5;${code}m';

  String _topLine(int maxChar) {
    int newMaxCharPerRow = maxChar > maxCharPerRow ? maxCharPerRow : maxChar;
    String message = showVerticalLine
        ? '${_ansiForegroundColor(lineColorCode)}$_topLeftCorner${_dashLine * (newMaxCharPerRow + 2)}$_topRightCorner$_resetColor'
        : '${_ansiForegroundColor(lineColorCode)}${_dashLine * (newMaxCharPerRow + 2)}$_resetColor';
    return message;
  }

  String _middleLine(int maxChar) {
    int newMaxCharPerRow = maxChar > maxCharPerRow ? maxCharPerRow : maxChar;
    String message = showVerticalLine
        ? '${_ansiForegroundColor(lineColorCode)}$_centerLeftCorner${_dashLine * (newMaxCharPerRow + 2)}$_centerRightCorner$_resetColor'
        : '${_ansiForegroundColor(lineColorCode)}${_dashLine * (newMaxCharPerRow + 2)}$_resetColor';
    return message;
  }

  String _bottomLine(int maxChar) {
    int newMaxCharPerRow = maxChar > maxCharPerRow ? maxCharPerRow : maxChar;
    String message = showVerticalLine
        ? '${_ansiForegroundColor(lineColorCode)}$_bottomLeftCorner${_dashLine * (newMaxCharPerRow + 2)}$_bottomRightCorner$_resetColor'
        : '${_ansiForegroundColor(lineColorCode)}${_dashLine * (newMaxCharPerRow + 2)}$_resetColor';
    return message;
  }

  List<String> _modifyRow(String text, int colorCode, int maxChar) {
    int newMaxCharPerRow = maxChar > maxCharPerRow ? maxCharPerRow : maxChar;
    final pattern = RegExp('.{1,$newMaxCharPerRow}');

    final textModified = pattern.allMatches(text).map((match) {
      String itemText = match.group(0) ?? '';
      String sentence = itemText.length < maxCharPerRow
          ? '$itemText${' ' * (newMaxCharPerRow - itemText.length)}'
          : itemText;
      String message = showVerticalLine
          ? '${_ansiForegroundColor(lineColorCode)}$_sideLine ${_ansiForegroundColor(colorCode)}$sentence$_resetColor ${_ansiForegroundColor(lineColorCode)}$_sideLine'
          : '${_ansiForegroundColor(colorCode)}$sentence$_resetColor';
      return message;
    }).toList();
    return textModified;
  }

  /// basic log with border/side line
  void basic(String body) {
    if (!enable) return;

    int maxChar = 0;
    if (countMaxCharPerRow) {
      maxChar = body
          .split('\n')
          .map((e) => e.length)
          .toList()
          .fold(maxChar, (prev, e) => max(prev, e));
    } else {
      maxChar = body.length;
    }
    _execute([
      if (showHorizontalLine) _topLine(maxChar),
      ..._modifyRow(body, bodyColorCode, maxChar),
      if (showHorizontalLine) _bottomLine(maxChar)
    ]);
  }

  /// basic with title/header
  void title(String title, String body) async {
    if (!enable) return;

    int maxChar = 0;
    if (countMaxCharPerRow) {
      maxChar = title
          .split('\n')
          .map((e) => e.length)
          .toList()
          .fold(maxChar, (prev, e) => max(prev, e));
      maxChar = body
          .split('\n')
          .map((e) => e.length)
          .toList()
          .fold(maxChar, (prev, e) => max(prev, e));
    } else {
      maxChar = max(title.length, body.length);
    }

    _execute([
      if (showHorizontalLine) _topLine(maxChar),
      ..._modifyRow(title, titleColorCode, maxChar),
      if (showHorizontalLine) _middleLine(maxChar),
      ..._modifyRow(body, bodyColorCode, maxChar),
      if (showHorizontalLine) _bottomLine(maxChar),
    ]);
  }

  /// response from http package
  void response(http.Response response) {
    if (!enable) return;

    String method = response.request!.method;
    String url = response.request!.url.toString();
    int statusCode = response.statusCode;
    String title = "[$method] $url [$statusCode]";
    String body = response.body;

    int maxChar = 0;
    if (countMaxCharPerRow) {
      maxChar = title
          .split('\n')
          .map((e) => e.length)
          .toList()
          .fold(maxChar, (prev, e) => max(prev, e));
      maxChar = body
          .split('\n')
          .map((e) => e.length)
          .toList()
          .fold(maxChar, (prev, e) => max(prev, e));
    } else {
      maxChar = max(title.length, body.length);
    }

    _execute([
      if (showHorizontalLine) _topLine(maxChar),
      ..._modifyRow(title, titleColorCode, maxChar),
      if (showHorizontalLine) _middleLine(maxChar),
      ..._modifyRow(body, bodyColorCode, maxChar),
      if (showHorizontalLine) _bottomLine(maxChar),
    ]);
  }
}
