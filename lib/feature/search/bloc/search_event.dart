part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class FetchUser extends SearchEvent {
  final String username;

  FetchUser({required this.username});
}

class FetchUserNextPage extends SearchEvent {}
