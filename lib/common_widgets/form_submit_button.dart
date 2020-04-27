import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/common_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({@required String text, @required VoidCallback onPressed})
      : super(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 17.0,
            ),
          ),
          height: 44.0,
          color: Colors.indigo,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}
