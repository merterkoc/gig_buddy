import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_text_button.dart';
import 'package:go_router/go_router.dart';

class GigDatePicker extends StatefulWidget {
  const GigDatePicker({
    required this.onChanged,
    required this.initialDate,
    super.key,
  });

  final ValueChanged<DateTime> onChanged;
  final DateTime initialDate;

  @override
  State<GigDatePicker> createState() => _GigDatePickerState();
}

class _GigDatePickerState extends State<GigDatePicker> {
  @override
  void initState() {
    _selectedDate = widget.initialDate;
    super.initState();
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    await showCupertinoDatePickerSheet(
      context: context,
      initialDate: _selectedDate ?? widget.initialDate,
      onSelected: (DateTime newDate) {
        if (newDate != _selectedDate) {
          setState(() {
            _selectedDate = newDate;
            widget.onChanged.call(newDate);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Select birthdate',
        ),
        child: Text(
          _selectedDate != null
              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
              : 'No date selected',
        ),
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
                  Navigator.of(context).pop();
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
