import 'package:bloc/bloc.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/home/model/user.dart';
import 'package:categorease/feature/search/repository/user_repository.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:categorease/utils/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserRepository _userRepository;
  String? username;

  SearchBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SearchInitial()) {
    on<FetchUser>(_onFetchUser);
    on<FetchUserNextPage>(_onFetchUserNextPage);
  }

  _onFetchUser(FetchUser event, Emitter<SearchState> emit) async {
    emit(SearchLoading());

    username = event.username;
    final response = await _userRepository.getAllUser(username: username);

    response.fold(
      (l) => emit(SearchError(l)),
      (r) => emit(SearchLoaded(
        users: r,
        nextPageStatus: Status.initial,
      )),
    );
  }

  _onFetchUserNextPage(
      FetchUserNextPage event, Emitter<SearchState> emit) async {
    if (state is! SearchLoaded) return;

    final castedState = state as SearchLoaded;

    // no next page left
    if (castedState.users.next == null) return;

    emit(castedState.copyWith(nextPageStatus: Status.loading));

    final result = await _userRepository.getAllUser(
      page: castedState.users.next!,
      username: username,
    );

    result.fold(
      (l) => emit(castedState.copyWith(
        nextPageFailure: l,
        nextPageStatus: Status.error,
      )),
      (r) {
        emit(
          castedState.copyWith(
            nextPageStatus: Status.loaded,
            users: r.copyWith(data: castedState.users.data + r.data),
          ),
        );
      },
    );
  }
}
