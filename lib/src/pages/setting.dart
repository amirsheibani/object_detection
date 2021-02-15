import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:object_detection/src/theme/theme.dart';
import 'package:object_detection/src/utils/utility.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  DateTime _dateSelected;
  bool _showLogs = false;
  String _logBody;
  ActionLog _actionLog = ActionLog.read;

  @override
  Widget build(BuildContext context) {

    return (Device.get().isPhone) ? _smartPhoneLayout() : (Device.width > Device.height ? _tabletLandscapeLayout() : _tabletPortraitLayout());
  }

  Widget _smartPhoneLayout() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      // color: Theme.of(context).backgroundColor,
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: _appBar(context)),
            Expanded(
              flex: 8,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            _showLogs = !_showLogs;
                          });
                        },
                        child: Center(
                          child: Text(
                            'Logs',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ),
                    ),
                    _selectDateLog(),
                    _selectActionLog(),
                    _showLogBody(),
                  ],
                ),
              ),
            ),
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     // color: Colors.red,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _tabletLandscapeLayout() {
    return _smartPhoneLayout();
  }

  Widget _tabletPortraitLayout() {
    return _smartPhoneLayout();
  }

  Widget _showLogBody() {
    if (_actionLog == ActionLog.read) {
      if (_logBody != null) {
        return Text(
          '''$_logBody''',
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.left,
          overflow: TextOverflow.visible,
        );
      }
    } else if (_actionLog == ActionLog.send) {
      AppendLog.sendLog(_dateSelected);
    } else if (_actionLog == ActionLog.clear) {
      AppendLog.clearLog(_dateSelected);
    }
    return Container();
  }

  Widget _selectActionLog() {
    if (_dateSelected != null) {
      return Column(
        children: [
          FlatButton(
            onPressed: () {
              setState(() {
                _actionLog = ActionLog.read;
                _logBody = '';
              });
            },
            child: Center(
              child: Text(
                'Show log',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                _actionLog = ActionLog.send;
              });
            },
            child: Center(
              child: Text(
                'Send log',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                _actionLog = ActionLog.clear;
                _logBody = '';
              });
            },
            child: Center(
              child: Text(
                'Clear log',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }

  Widget _selectDateLog() {
    if (_showLogs) {
      return FlatButton(
        onPressed: () {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(2019, 3, 1),
              maxTime: DateTime.now(),
              theme: DatePickerTheme(
                headerColor: Theme.of(context).colorScheme.secondaryVariant,
                backgroundColor: Theme.of(context).backgroundColor,
                itemStyle: Theme.of(context).textTheme.subtitle1,
                doneStyle: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
              ), onConfirm: (date) async {
            _logBody = await AppendLog.readLog(date);
            setState(() {
              _dateSelected = date;
            });
          }, currentTime: DateTime.now(), locale: LocaleType.en);
        },
        child: Center(
          child: Text(
            'Select Date',
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
      );
    }
    return Container();
  }

  Widget _appBar(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          color: ColorsBox.ColorsBoxItems[ColorsBoxType.dialog_title_background],
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max, //Center Column contents vertically,
              crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _backToHomePage();
                    },
                    child: SizedBox(
                      height: AppBar().preferredSize.height,
                      // width: 80,
                      child: Center(
                        child: Text(
                          "Close",
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .apply(color: ColorsBox.ColorsBoxItems[ColorsBoxType.dialog_title_close_text]),
                        ),
                      )
                    ),
                  ),
                ),
                SizedBox(
                  height: AppBar().preferredSize.height,
                  width: 80,
                ),
                SizedBox(
                  height: AppBar().preferredSize.height,
                  width: 80,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _backToHomePage() {
    Navigator.pop(context);
  }
}
