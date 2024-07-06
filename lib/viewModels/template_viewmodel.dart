import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class TemplateViewModel extends ChangeNotifier {
  String templateContent = '';
  String configContent = '';

  String result = '';
  String _fileName = '';

  String get getFileName {
    return _fileName;
  }

  void pickTemplateFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      templateContent = await file.readAsString();
      notifyListeners();
    }
  }

  void pickConfigFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      configContent = await file.readAsString();
      notifyListeners();
    }
  }

  void generateResult() {
    if (templateContent.isNotEmpty && configContent.isNotEmpty) {
      Map<String, dynamic> config = json.decode(configContent);
      result = _replaceVariables(templateContent, config);
      updateFileName();
      notifyListeners();
    }
  }

  Future<void> exportJSON() async {
    String? outputFilePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: getFileName,
        type: FileType.custom,
        allowedExtensions: ['json']);

    if (outputFilePath != null) {
      File outputFile = File(outputFilePath);
      await outputFile.writeAsString(result);
    }
  }

  void updateTemplateContent(String newContent) {
    templateContent = newContent;
    notifyListeners();
  }

  void updateConfigContent(String newContent) {
    configContent = newContent;
    notifyListeners();
  }

  void updateFileName() {
    if (templateContent.isEmpty && configContent.isEmpty) {
      return;
    }
    String productId = extractValue(configContent, 'PRODUCT_ID');
    String templateVersion = extractValue(configContent, 'TEMPLATE_VERSION');

    if (productId.isNotEmpty && templateVersion.isNotEmpty) {
      _fileName = '${productId}_$templateVersion.json';
    } else if (productId.isNotEmpty) {
      _fileName = '$productId.json';
    } else {
      _fileName = 'result.json';
    }
    notifyListeners();
  }

  String _replaceVariables(String template, Map<String, dynamic> config) {
    var modifiedTemplate = template;
    final variableRegex = RegExp(r'\$\{(\w+)(\|[\w\s\-\\\/\*\[\]=,]+)?\}');

    modifiedTemplate =
        modifiedTemplate.replaceAllMapped(variableRegex, (match) {
      var variable = match.group(1);
      var modifier = match.group(2);
      if (variable != null && config.containsKey(variable)) {
        var value = config[variable].toString();
        if (modifier != null) {
          value = _applyModifier(value, modifier);
        }
        return value;
      }
      return match.group(0) ?? '';
    });

    return modifiedTemplate;
  }

  String _applyModifier(String value, String modifier) {
    if (modifier.contains('|format=[')) {
      final formatRegex = RegExp(r'\|format=\[([A-Za-z\s\\\/-]+)\]');
      if (formatRegex.hasMatch(modifier)) {
        var formatMatch = formatRegex.firstMatch(modifier);
        if (formatMatch != null) {
          var format = formatMatch.group(1);
          if (format != null) {
            try {
              var dateTime = DateTime.parse(value);
              return DateFormat(format).format(dateTime);
            } catch (e) {
              // Ignore for now 
            }
          }
        }
      }
    } else if (modifier.contains('|money')) {
      final moneyRegex = RegExp(r'\|money(\[.*?\])?');
      if (moneyRegex.hasMatch(modifier)) {
        try {
          double amount = double.parse(value);
          if (amount >= 1000000) {
            return '${(amount / 1000000).toStringAsFixed(2)} million';
          } else if (amount >= 1000) {
            return '${(amount / 1000).toStringAsFixed(2)} thousand';
          } else {
            return '$amount';
          }
        } catch (e) {
          // Ignore for now 
        }
      }
    }

    return value;
  }

  String extractValue(String jsonString, String key) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return jsonMap[key] ?? '';
  }
}
