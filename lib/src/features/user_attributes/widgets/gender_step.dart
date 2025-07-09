import 'package:flutter/material.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/service/model/enum/gender.dart';

class GenderStep extends StatefulWidget {
  const GenderStep({required this.onSelected, super.key});

  final Function(Gender) onSelected;

  @override
  State<GenderStep> createState() => _GenderStepState();
}

class _GenderStepState extends State<GenderStep> {
  Gender? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Text(context.l10.profile_edit_view_gender, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            DropdownButtonFormField<Gender>(
              value: _selectedGender,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              hint: Text(context.l10.select_gender),
              onChanged: (Gender? newValue) {
                setState(() {
                  _selectedGender = newValue;
                  widget.onSelected(newValue!);
                });
              },
              items: Gender.values.map((Gender gender) {
                return DropdownMenuItem<Gender>(
                  value: gender,
                  child: Text(gender.value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
