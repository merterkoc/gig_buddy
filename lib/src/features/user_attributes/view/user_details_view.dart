import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_action_button.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_elevated_button.dart';
import 'package:gig_buddy/src/app_ui/widgets/buttons/gig_text_button.dart';
import 'package:gig_buddy/src/bloc/profile/profile_bloc.dart';
import 'package:gig_buddy/src/features/user_attributes/widgets/birth_date_select.dart';
import 'package:gig_buddy/src/features/user_attributes/widgets/gender_step.dart';
import 'package:gig_buddy/src/route/router.dart';
import 'package:gig_buddy/src/service/model/enum/gender.dart';
import 'package:gig_buddy/src/service/model/update_user_request/update_user_request.dart';
import 'package:gig_buddy/src/service/model/user/user_dto.dart';
import 'package:go_router/go_router.dart';

class UserDetailsView extends StatefulWidget {
  const UserDetailsView({required this.user, super.key});

  final UserDto user;

  @override
  UserAttributeSliderState createState() => UserAttributeSliderState();
}

class UserAttributeSliderState extends State<UserDetailsView> {
  final PageController _pageController = PageController();
  late int _currentPage;
  DateTime? _birthdate;
  Gender? _gender;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
  }

  void _onBirthdateSelected(DateTime date) {
    setState(() {
      _birthdate = date;
    });
  }

  void _onGenderSelected(Gender gender) {
    setState(() {
      _gender = gender;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          previous.requestSetUserAttributes != current.requestSetUserAttributes,
      listener: (context, state) {
        if (state.requestSetUserAttributes!.isOk) {
          context.goNamed(AppRoute.homeView.name);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Çok az kaldı')),
        body: SafeArea(
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  if (widget.user.birthdate == null)
                    BirthdateStep(
                      onSelected: (date) {
                        _onBirthdateSelected(date);
                      },
                    ),
                  if (widget.user.gender == null)
                    GenderStep(onSelected: _onGenderSelected),
                ],
              ),
              if ((_currentPage == 0 && widget.user.birthdate == null && _birthdate != null) ||
                  (_currentPage == (widget.user.birthdate == null ? 1 : 0) && widget.user.gender == null && _gender != null))
                Positioned(
                  bottom: 40,
                  right: 20,
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    buildWhen: (previous, current) =>
                        previous.requestSetUserAttributes !=
                        current.requestSetUserAttributes,
                    builder: (context, state) {
                      return GigTextButton(
                        isLoading:
                            state.requestSetUserAttributes?.status.isLoading ??
                                false,
                        onPressed: () {
                          final isLastPage = _currentPage ==
                              [
                                if (widget.user.birthdate == null) 'birthdate',
                                if (widget.user.gender == null) 'gender'
                              ].length -
                                  1;

                          if (isLastPage) {
                            context.read<ProfileBloc>().add(
                                  UpdateUserDetails(UpdateUserRequestDTO(
                                    birthdate: _birthdate ?? widget.user.birthdate!,
                                    gender: _gender ?? widget.user.gender!,
                                  )),
                                );
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
