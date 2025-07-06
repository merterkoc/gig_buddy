import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_text_button.dart';
import 'package:gig_buddy/src/common/util/date_util.dart';
import 'package:go_router/go_router.dart';

class BirthdateStep extends StatefulWidget {
  final Function(DateTime) onSelected;

  BirthdateStep({required this.onSelected});

  @override
  State<BirthdateStep> createState() => _BirthdateStepState();
}

class _BirthdateStepState extends State<BirthdateStep> {
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Select Birthday", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          GigElevatedButton(
            onPressed: () async {
              await showCupertinoDatePickerSheet(
                context: context,
                initialDate: DateTime(2000),
                onSelected: (DateTime date) {
                  setState(() {
                    _selectedDate = date;
                    widget.onSelected(date);
                  });
                },
              );

            },
            child:  Text(
              _selectedDate != null
                  ? DateUtil.getBirthDate(_selectedDate!)
                  : 'Choose birthdate',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showCupertinoDatePickerSheet({
    required BuildContext context,
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    DateTime tempPickedDate = initialDate;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // Üst bar
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  onSelected(tempPickedDate);
                },
                child: GigTextButton(
                  onPressed: () {
                    onSelected(tempPickedDate);
                    context.pop();
                  },
                  child: Text(
                    'Tamam',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),

            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate,
                minimumDate: DateTime(1900),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) {
                  tempPickedDate = newDate;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
