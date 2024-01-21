import 'package:day_night_time_picker/lib/state/state_container.dart';
import 'package:flutter/material.dart';

/// Render the [Ok] and [Cancel] buttons
class ActionButtons extends StatelessWidget {
  final bool isArabic;
  const ActionButtons({Key? key, required this.isArabic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeState = TimeModelBinding.of(context);
    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;
    final defaultButtonStyle = TextButton.styleFrom(
      textStyle: TextStyle(color: color),
    );

    if (timeState.widget.isOnValueChangeMode) {
      return const SizedBox(
        height: 8,
      );
    }

    if (!timeState.widget.showCancelButton) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: <Widget>[
            TextButton(
              onPressed: timeState.onOk,
              style: timeState.widget.buttonStyle ?? defaultButtonStyle,
              child: Text(
                timeState.widget.okText,
                style: timeState.widget.okStyle,
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: <Widget>[
          TextButton(
            style: (timeState.widget.cancelButtonStyle ??
                    timeState.widget.buttonStyle) ??
                defaultButtonStyle,
            onPressed: timeState.onCancel,
            child: Text(
              timeState.widget.cancelText,
              style: timeState.widget.cancelStyle,
            ),
          ),
          SizedBox(width: timeState.widget.buttonsSpacing ?? 0),
          TextButton(
            onPressed: timeState.onOk,
            style: timeState.widget.buttonStyle ?? defaultButtonStyle,
            child: Text(
              timeState.widget.okText,
              style: timeState.widget.okStyle,
            ),
          ),
        ],
      ),
    );
  }
}
