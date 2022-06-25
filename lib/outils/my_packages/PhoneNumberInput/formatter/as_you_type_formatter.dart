import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libphonenumber_plugin/libphonenumber_plugin.dart' as p;

typedef OnInputFormatted<T> = void Function(T value);

/// [AsYouTypeFormatter] is a custom formatter that extends [TextInputFormatter]
/// which provides as you type validation and formatting for phone number inputted.
class AsYouTypeFormatter extends TextInputFormatter {
  /// Contains characters allowed as seperators.
  final RegExp separatorChars = RegExp(r'[^\d]+');

  /// The [allowedChars] contains [RegExp] for allowable phone number characters.
  final RegExp allowedChars = RegExp(r'[\d+]');

  /// The [isoCode] of the [Country] formatting the phone number to
  final String isoCode;

  /// The [phoneCode] of the [Country] formatting the phone number to
  final String phoneCode;

  /// [onInputFormatted] is a callback that passes the formatted phone number
  final OnInputFormatted<TextEditingValue> onInputFormatted;

  AsYouTypeFormatter(
      {required this.isoCode,
      required this.phoneCode,
      required this.onInputFormatted});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int oldValueLength = oldValue.text.length;
    int newValueLength = newValue.text.length;

    if (newValueLength > 0 && newValueLength > oldValueLength) {
      String newValueText = newValue.text;
      String rawText = newValueText.replaceAll(separatorChars, '');
      String textToParse = phoneCode + rawText;

      final _ = newValueText
          .substring(
              oldValue.selection.start == -1 ? 0 : oldValue.selection.start,
              newValue.selection.end == -1 ? 0 : newValue.selection.end)
          .replaceAll(separatorChars, '');

      formatAsYouType(input: textToParse).then(
        (String? value) {
          String parsedText = parsePhoneNumber(value);

          int offset =
              newValue.selection.end == -1 ? 0 : newValue.selection.end;

          if (separatorChars.hasMatch(parsedText)) {
            String valueInInputIndex = parsedText[offset - 1];

            if (offset < parsedText.length) {
              int offsetDifference = parsedText.length - offset;

              if (offsetDifference < 2) {
                if (separatorChars.hasMatch(valueInInputIndex)) {
                  offset += 1;
                } else {
                  bool isLastChar;
                  try {
                    var _ = newValueText[newValue.selection.end];
                    isLastChar = false;
                  } on RangeError {
                    isLastChar = true;
                  }
                  if (isLastChar) {
                    offset += offsetDifference;
                  }
                }
              } else {
                if (parsedText.length > offset - 1) {
                  if (separatorChars.hasMatch(valueInInputIndex)) {
                    offset += 1;
                  }
                }
              }
            }

            this.onInputFormatted(
              TextEditingValue(
                text: parsedText,
                selection: TextSelection.collapsed(offset: offset),
              ),
            );
          }
        },
      );
    }
    return newValue;
  }

  Future<String?> formatAsYouType({required String input}) async {
    try {
      String? formattedPhoneNumber =
          await p.PhoneNumberUtil.formatAsYouType(input, isoCode);
      return formattedPhoneNumber;
    } on Exception {
      return '';
    }
  }

  /// Accepts a formatted [phoneNumber]
  /// returns a [String] of `phoneNumber` with the dialCode replaced with an empty String
  String parsePhoneNumber(String? phoneNumber) {
    if (phoneCode.length > 4) {
      if (isPartOfNorthAmericanNumberingPlan(phoneCode)) {
        String northAmericaDialCode = '+1';
        String countryDialCodeWithSpace = northAmericaDialCode +
            ' ' +
            phoneCode.replaceFirst(northAmericaDialCode, '');

        return phoneNumber!
            .replaceFirst(countryDialCodeWithSpace, '')
            .replaceFirst(separatorChars, '')
            .trim();
      }
    }
    return phoneNumber!.replaceFirst(phoneCode, '').trim();
  }

  /// Accepts a [dialCode]
  /// returns a [bool], true if the `dialCode` is part of North American Numbering Plan
  bool isPartOfNorthAmericanNumberingPlan(String dialCode) {
    return dialCode.contains('+1');
  }
}
