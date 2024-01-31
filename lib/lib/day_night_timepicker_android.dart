import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/ampm.dart';
import 'package:day_night_time_picker/lib/common/action_buttons.dart';
import 'package:day_night_time_picker/lib/common/display_value.dart';
import 'package:day_night_time_picker/lib/common/filter_wrapper.dart';
import 'package:day_night_time_picker/lib/common/wrapper_container.dart';
import 'package:day_night_time_picker/lib/common/wrapper_dialog.dart';
import 'package:day_night_time_picker/lib/daynight_banner.dart';
import 'package:day_night_time_picker/lib/state/state_container.dart';
import 'package:day_night_time_picker/lib/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as dt;

/// Private class. [StatefulWidget] that renders the content of the picker.
// ignore: must_be_immutable
class DayNightTimePickerAndroid extends StatefulWidget {
  const DayNightTimePickerAndroid({
    Key? key,
    required this.sunrise,
    required this.sunset,
    required this.duskSpanInMinutes,
    required this.isArabic,
  }) : super(key: key);
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final int duskSpanInMinutes;
  final bool isArabic;

  @override
  DayNightTimePickerAndroidState createState() =>
      DayNightTimePickerAndroidState();
}

/// Picker state class
class DayNightTimePickerAndroidState extends State<DayNightTimePickerAndroid> {
  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);

    double min =
        getMin(timeState.widget.minMinute, timeState.widget.minuteInterval);
    double max =
        getMax(timeState.widget.maxMinute, timeState.widget.minuteInterval);

    int minDiff = (max - min).round();
    int divisions = getDivisions(minDiff, timeState.widget.minuteInterval);

    if (timeState.selected == SelectedInput.HOUR) {
      min = timeState.widget.minHour!;
      max = timeState.widget.maxHour!;
      divisions = (max - min).round();
    }

    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;

    final hourValue = timeState.widget.is24HrFormat
        ? timeState.time.hour
        : timeState.time.hourOfPeriod;

    final hideButtons = timeState.widget.hideButtons;

    Orientation currentOrientation = MediaQuery.of(context).orientation;

    double value = timeState.time.hour.roundToDouble();
    if (timeState.selected == SelectedInput.MINUTE) {
      value = timeState.time.minute.roundToDouble();
    } else if (timeState.selected == SelectedInput.SECOND) {
      value = timeState.time.second.roundToDouble();
    }

    final now = DateTime.now();

    return Center(
      child: SingleChildScrollView(
        physics: currentOrientation == Orientation.portrait
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        child: FilterWrapper(
          child: WrapperDialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DayNightBanner(
                  sunrise: widget.sunrise,
                  sunset: widget.sunset,
                  duskSpanInMinutes: widget.duskSpanInMinutes,
                ),
                WrapperContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AmPm(isArabic: widget.isArabic),
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DisplayValue(
                                onTap: timeState.widget.disableHour!
                                    ? null
                                    : () {
                                        timeState.onSelectedInputChange(
                                          SelectedInput.HOUR,
                                        );
                                      },
                                value: dt.DateFormat.H(
                                        widget.isArabic ? 'ar' : 'en')
                                    .format(
                                  DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    hourValue,
                                    timeState.time.minute,
                                    timeState.time.second,
                                  ),
                                ),
                                // value: hourValue.toString().padLeft(2, '0'),
                                isSelected:
                                    timeState.selected == SelectedInput.HOUR,
                              ),
                              const DisplayValue(
                                value: ':',
                              ),
                              DisplayValue(
                                onTap: timeState.widget.disableMinute!
                                    ? null
                                    : () {
                                        timeState.onSelectedInputChange(
                                          SelectedInput.MINUTE,
                                        );
                                      },
                                value: dt.DateFormat.m(
                                        widget.isArabic ? 'ar' : 'en')
                                    .format(
                                  DateTime(
                                    now.year,
                                    now.month,
                                    now.day,
                                    hourValue,
                                    timeState.time.minute,
                                    timeState.time.second,
                                  ),
                                ),
                                // value: timeState.time.minute
                                //     .toString()
                                //     .padLeft(2, '0'),
                                isSelected:
                                    timeState.selected == SelectedInput.MINUTE,
                              ),
                              ...timeState.widget.showSecondSelector
                                  ? [
                                      const DisplayValue(
                                        value: ':',
                                      ),
                                      DisplayValue(
                                        onTap: () {
                                          timeState.onSelectedInputChange(
                                            SelectedInput.SECOND,
                                          );
                                        },
                                        value: dt.DateFormat.s(
                                                widget.isArabic ? 'ar' : 'en')
                                            .format(
                                          DateTime(
                                            now.year,
                                            now.month,
                                            now.day,
                                            hourValue,
                                            timeState.time.minute,
                                            timeState.time.second,
                                          ),
                                        ),
                                        // value: timeState.time.second
                                        //     .toString()
                                        //     .padLeft(2, '0'),
                                        isSelected: timeState.selected ==
                                            SelectedInput.SECOND,
                                      ),
                                    ]
                                  : [],
                            ],
                          ),
                        ),
                      ),
                      Directionality(
                        textDirection: widget.isArabic
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                        child: Slider(
                          onChangeEnd: (value) {
                            if (!timeState.widget.disableAutoFocusToNextInput) {
                              if (timeState.selected == SelectedInput.HOUR) {
                                timeState.onSelectedInputChange(
                                    SelectedInput.MINUTE);
                              } else if (timeState.selected ==
                                      SelectedInput.MINUTE &&
                                  timeState.widget.showSecondSelector) {
                                timeState.onSelectedInputChange(
                                    SelectedInput.SECOND);
                              }
                            }
                            if (timeState.widget.isOnValueChangeMode) {
                              timeState.onOk();
                            }
                          },
                          value: value,
                          onChanged: timeState.onTimeChange,
                          min: min,
                          max: max,
                          divisions: divisions,
                          activeColor: color,
                          inactiveColor: color.withAlpha(55),
                        ),
                      ),
                      if (!hideButtons)
                        ActionButtons(isArabic: widget.isArabic),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
