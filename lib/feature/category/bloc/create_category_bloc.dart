import 'package:bloc/bloc.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/repository/category_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'create_category_event.dart';
part 'create_category_state.dart';

class CreateCategoryBloc
    extends Bloc<CreateCategoryEvent, CreateCategoryBlocState> {
  final CategoryRepository _categoryRepository;

  CreateCategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CreateCategoryInitial()) {
    on<CreateCategoryCreate>(_onCreateCategoryCreate);
  }

  _onCreateCategoryCreate(
      CreateCategoryCreate event, Emitter<CreateCategoryBlocState> emit) async {
    emit(CreateCategoryLoading());

    if (event.roomIds.isEmpty) {
      emit(
        CreateCategoryFailed(
          const Failure(message: 'Rooms must be selected at least 1'),
          roomEmpty: true,
        ),
      );
      return;
    }

    final response = await _categoryRepository.create(
      name: event.name,
      roomIds: event.roomIds,
      hexColor: event.color,
    );

    response.fold(
      (l) => emit(CreateCategoryFailed(l)),
      (r) => emit(CreateCategorySuccess()),
    );
  }
}
