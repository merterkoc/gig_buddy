import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/login/login_bloc.dart';
import 'package:gig_buddy/src/common/modal/action_sheet.dart';
import 'package:gig_buddy/src/common/util/image_util.dart';
import 'package:gig_buddy/src/features/login/widgets/login_buttons.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) =>
          previous.createAccountRequestState !=
          current.createAccountRequestState,
      listener: (context, state) {
        if (state.createAccountRequestState.isSuccess) {
          CupertinoAction.showModalPopup(
            context,
            title: const Text('Success'),
            message: const Text('Account created successfully'),
            actions: [],
          );
        } else if (state.createAccountRequestState.isError) {
          CupertinoAction.showModalPopup(
            context,
            title: const Text('Error'),
            message: const Text('Something went wrong'),
            actions: [],
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register', style: TextStyle(fontSize: 18)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _registerFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(99999),
                        onTap: () async {
                          final picker = ImagePicker();
                          await picker
                              .pickImage(source: ImageSource.gallery)
                              .then(
                            (image) {
                              if (image != null) {
                                setState(() {
                                  _image = image;
                                });
                              }
                            },
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99999),
                          child: _image?.path.isNotEmpty ?? false
                              ? Image.file(
                                  ImageHelper.getImageFromFile(_image!),
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(99999),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      size: 50,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  if (_image != null)
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _image = null;
                          });
                        },
                        child: Text(
                          'Remove',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )),
                  const SizedBox(height: 20),
                  const Text('Email'),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20),
                  const Text('Password'),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 20),
                  const Text('Confirm Password'),
                  TextFormField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.createAccountRequestState !=
                        current.createAccountRequestState,
                    builder: (context, state) {
                      return LoginButtons.email(
                        text: 'Submit',
                        isActive: true,
                        inProgress: state.createAccountRequestState.isLoading,
                        onPressed: () {
                          context.read<LoginBloc>().add(
                                CreateAccount(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  image: _image,
                                ),
                              );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
