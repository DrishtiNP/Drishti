import 'package:flutter/material.dart';
import 'package:drishti/src/utils/colors.dart';

class Note {
  static const Map<int, String> _intToNote = {
    0: 'fifty',
    1: 'five',
    2: 'fivehundred',
    3: 'hundred',
    4: 'ten',
    5: 'thousand',
    6: 'twenty'
  };
  static const Map<String, int> _noteToInt = {
    'fifty': 0,
    'five': 1,
    'fivehundred': 2,
    'hundred': 3,
    'ten': 4,
    'thousand': 5,
    'twenty': 6
  };
  static const Map<String, int> _noteToValues = {
    'fifty': 50,
    'five': 5,
    'fivehundred': 500,
    'hundred': 100,
    'ten': 10,
    'thousand': 1000,
    'twenty': 20
  };

  static final Map<String, Color> noteToColor = {
    'fifty': five,
    'five': five,
    'fivehundred': fivehundred,
    'hundred': hundred,
    'ten': ten,
    'thousand': thousand,
    'twenty': twenty
  };

  static const TABLE_NAME = "notes";
  static const COLUMN_ID = "id";
  static const COLUMN_NOTE = "note";
  static const COLUMN_DATETIME = "datetime";
  int id;
  int note;
  int datetimeInt;
  DateTime datetime;
  String label;
  int value;

  Note({this.id, this.label, this.datetimeInt});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      COLUMN_NOTE: _noteToInt[label],
    };
    if (id != null) {
      map[COLUMN_ID] = id;
    }
    if (datetimeInt != null) {
      map[COLUMN_DATETIME] = datetimeInt;
    }
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map[COLUMN_ID];
    note = map[COLUMN_NOTE];
    datetimeInt = map[COLUMN_DATETIME];
    datetime = DateTime.fromMicrosecondsSinceEpoch(datetimeInt);
    label = _intToNote[note];
    value = _noteToValues[label];
  }
}
