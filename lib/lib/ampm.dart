import 'package:day_night_time_picker/lib/state/state_container.dart';
import 'package:flutter/material.dart';

/// [Widget] for rendering the AM/PM button
class AmPm extends StatelessWidget {
  /// Default [TextStyle]
  final _style = const TextStyle(fontSize: 20);
  final bool isArabic;

  const AmPm({Key? key, required this.isArabic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var timeState = TimeModelBinding.of(context);
    final isAm = timeState.time.period == DayPeriod.am;
    const unselectedOpacity = 0.5;

    final shouldDisablePM = !timeState.checkIfWithinRange(DayPeriod.pm);
    final shouldDisableAM = !timeState.checkIfWithinRange(DayPeriod.am);

    if (timeState.widget.is24HrFormat) {
      return Container();
    }

    final accentColor =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;
    final unselectedColor = timeState.widget.unselectedColor ?? Colors.grey;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: !isAm && !shouldDisableAM
                  ? () {
                      timeState.onAmPmChange(DayPeriod.am);
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: Opacity(
                  opacity: !isAm ? unselectedOpacity : 1,
                  child: Text(
                    isArabic ? 'ص' : 'am',
                    style: _style.copyWith(
                      color: isAm ? accentColor : unselectedColor,
                      fontWeight: isAm ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isAm && !shouldDisablePM
                  ? () {
                      timeState.onAmPmChange(DayPeriod.pm);
                    }
                  : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                child: Opacity(
                  opacity: isAm ? unselectedOpacity : 1,
                  child: Text(
                    isArabic ? 'م' : 'pm',
                    style: _style.copyWith(
                      color: !isAm ? accentColor : unselectedColor,
                      fontWeight: !isAm ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
