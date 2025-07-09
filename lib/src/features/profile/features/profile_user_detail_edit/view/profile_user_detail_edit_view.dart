import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_text_button.dart';
import 'package:gig_buddy/src/app_ui/widgets/date_picker/gig_date_picker.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/enum/gender.dart';
import 'package:gig_buddy/src/service/model/update_user_request/update_user_request.dart';
import 'package:go_router/go_router.dart';

class ProfileUserDetailEditView extends StatefulWidget {
  const ProfileUserDetailEditView({super.key});

  @override
  State<ProfileUserDetailEditView> createState() =>
      _ProfileUserDetailEditViewState();
}

class _ProfileUserDetailEditViewState extends State<ProfileUserDetailEditView> {
  late DateTime? _selectedDate;
  late Gender? _selectedGender;

  @override
  void initState() {
    final profileState = context.read<LoginBloc>().state;
    _selectedDate = profileState.user!.birthdate;
    _selectedGender = profileState.user!.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          previous.requestSetUserAttributes != current.requestSetUserAttributes,
      listener: (context, state) {
        if (state.requestSetUserAttributes!.status.isSuccess) {
          context.read<LoginBloc>().add(const FetchUserInfo());
          context.goNamed(AppRoute.profileView.name);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10.profile_edit_view_title)),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10.profile_edit_view_birthdate,
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              GigDatePicker(
                initialDate: _selectedDate ?? DateTime(2000),
                onChanged: (DateTime date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
              const SizedBox(height: 24),
              Text(context.l10.profile_edit_view_gender,
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              DropdownButtonFormField<Gender>(
                value: _selectedGender,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: Text(context.l10.gender_male),
                onChanged: (Gender? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: Gender.values.map((Gender gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(gender.value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (previous, current) =>
                    previous.requestSetUserAttributes !=
                    current.requestSetUserAttributes,
                builder: (context, state) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: GigElevatedButton(
                      isLoading: context
                              .read<ProfileBloc>()
                              .state
                              .requestSetUserAttributes
                              ?.status
                              .isLoading ??
                          false,
                      onPressed: () {
                        if (_selectedDate == null || _selectedGender == null) {
                          return;
                        }
                        context.read<ProfileBloc>().add(UpdateUserDetails(
                              UpdateUserRequestDTO(
                                birthdate: _selectedDate!,
                                gender: _selectedGender!,
                              ),
                            ));
                      },
                      child: Text(context.l10.save),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
