import 'package:bloc/bloc.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:equatable/equatable.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit()
      : super(
          HomePageState(),
        );
}
