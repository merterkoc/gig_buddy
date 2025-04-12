import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gig_buddy/src/http/dio/model/request_state.dart';
import 'package:gig_buddy/src/repository/identity_repository.dart';
import 'package:gig_buddy/src/service/model/public_user/public_user_dto.dart';
import 'package:gig_buddy/src/service/model/user/user_dto.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this.identityRepository) : super(const ProfileState()) {
    on<FetchUserProfile>(_onFetchUserProfile);
  }

  final IdentityRepository identityRepository;

  Future<void> _onFetchUserProfile(
    FetchUserProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(requestState: RequestState.loading));
    try {
      final response = await identityRepository.fetchUserProfile(event.userId);
      final user = PublicUserDto.fromJson(response.data as Map<String, dynamic>);
      emit(
        state.copyWith(user: user, requestState: RequestState.success),
      );
    } catch (e) {
      emit(state.copyWith(requestState: RequestState.error));
      rethrow;
    }
  }
}
