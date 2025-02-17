part of 'create_category_bloc.dart';

@immutable
abstract class CreateCategoryEvent {}

class CreateCategoryCreate extends CreateCategoryEvent {
  final String name;
  final List<int> roomIds;
  final String color;

  CreateCategoryCreate({
    required this.name,
    required this.roomIds,
    required this.color,
  });
}

class CreateCategoryFetchRoom extends CreateCategoryEvent {}

class CreateCategoryFetchNextRoom extends CreateCategoryEvent {}
