import 'dart:collection';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:drishti/src/db/database_helper.dart';
import 'package:drishti/src/cash_recognition/models/note_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:drishti/src/utils/colors.dart';

// All Items for Dropdown Menu
List<String> historyOptionNames = [
  'Today',
  'This Week',
  'This Month',
];

// All the Options and their format
// [datetimeFormat] -> For Display
// [semanticsFormat] -> For Screen Readers
List<Map<String, dynamic>> historyMaps = [
  {
    'queryFunction': DatabaseHelper.instance.queryToday,
    'datetimeFormat': 'hh:mm a',
    'semanticsFormat': 'hh:mm a',
  },
  {
    'queryFunction': DatabaseHelper.instance.queryWeek,
    'datetimeFormat': 'EEE\nhh:mm a',
    'semanticsFormat': 'EEEE\nhh:mm a',
  },
  {
    'queryFunction': DatabaseHelper.instance.queryMonth,
    'datetimeFormat': 'MMM d\nhh:mm a',
    'semanticsFormat': 'MMMM d\nhh:mm a',
  }
];

LinkedHashMap<String, Map<String, dynamic>> historyOptions =
    LinkedHashMap.fromIterables(historyOptionNames, historyMaps);

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _currentOption;
  Future<List<Note>>? notes;
  late int sum;
  String? dateFormat;
  String? semanticsFormat;

  @override
  void initState() {
    super.initState();
    // define an initial Dropdown Option
    _currentOption = historyOptionNames[0];
    notes = historyOptions[_currentOption]?['queryFunction']();
    dateFormat = historyOptions[_currentOption]?['datetimeFormat'];
    semanticsFormat = historyOptions[_currentOption]?['semanticsFormat'];
  }

  void noteSum(Note note) {
    sum += note.value!;
  }

  @override
  Widget build(BuildContext context) {
    sum = 0;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            title: Center(
              child: Text(
                "HISTORY",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 25),
                ),
              ),
            ),
            backgroundColor: appBarBgColor,
            elevation: 15,
            actions: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: DropdownButton<String>(
                  dropdownColor: dropdownColor,
                  value: _currentOption,
                  items: historyOptionNames.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // change [currentOption]
                    setState(() {
                      _currentOption = newValue;
                      notes =
                          historyOptions[_currentOption]?['queryFunction']();
                      dateFormat =
                          historyOptions[_currentOption]?['datetimeFormat'];
                      semanticsFormat =
                          historyOptions[_currentOption]?['semanticsFormat'];
                    });
                  },
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: dropdownColor,
                ),
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<Note>>(
              future: notes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  snapshot.data?.forEach(noteSum);
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.03,
                              bottom: MediaQuery.of(context).size.height * 0.03,
                            ),
                            child: Text(
                              "TOTAL SUM = Rs. " + sum.toString(),
                              style: const TextStyle(
                                  fontSize: 27, fontWeight: FontWeight.w600),
                              semanticsLabel: "Total Scanned Sum" +
                                  sum.toString() +
                                  " Rupees",
                            )),
                        SafeArea(
                            child: SizedBox(
                                child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Note? currentNote = snapshot.data?[index];
                            String? noteName = currentNote?.label;

                            return Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width * 0.03,
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.width * 0.22,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Note.noteToColor[noteName],
                                  ),
                                  child: Stack(children: [
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.08),
                                            child: Text(
                                              'Rs. ${currentNote?.value.toString()}',
                                              semanticsLabel:
                                                  "${currentNote?.label} rupees",
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      color: defaultTextColor,
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ))),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2),
                                            child: Text(
                                              DateFormat(dateFormat).format(
                                                  currentNote!.datetime),
                                              semanticsLabel: DateFormat(
                                                      semanticsFormat)
                                                  .format(currentNote.datetime),
                                              style: TextStyle(
                                                  color: defaultTextColor,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w400),
                                            ))),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          tooltip: "Delete Note",
                                          onPressed: () {
                                            DatabaseHelper.instance
                                                .delete(currentNote.id)
                                                .whenComplete(
                                                    () => setState(() {
                                                          snapshot.data
                                                              ?.removeAt(index);
                                                        }));
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            // size: iconSize,
                                            color: deleteiconColor,
                                          ),
                                        ))
                                  ])),
                            );
                          },
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data?.length,
                        ))),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('No Data Found'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
