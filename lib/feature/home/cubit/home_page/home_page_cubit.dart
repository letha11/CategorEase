import 'package:bloc/bloc.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/feature/home/model/participant.dart';
import 'package:categorease/feature/home/model/user.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:equatable/equatable.dart';

part 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit()
      : super(
          HomePageState(
            rooms: [
              Room(
                id: 1,
                name: 'Trio Kece',
                participants: [
                  Participant(
                    id: 1,
                    user: User(
                      id: 1,
                      username: 'Goofy',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                    lastViewed: DateTime.now(),
                  ),
                  Participant(
                    id: 2,
                    user: User(
                      id: 2,
                      username: 'Mickey',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                    lastViewed: DateTime.now(),
                  ),
                  Participant(
                    id: 3,
                    user: User(
                      id: 3,
                      username: 'Donald',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                    lastViewed: DateTime.now(),
                  ),
                ],
                lastChat: Chat(
                  id: 1,
                  content:
                      'Haloo Semuanya ini adalah text yang terlalu panjang di bagian chat room ya',
                  sentBy: 'Goofy',
                  type: ChatType.text,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
                categories: [
                  const Category(
                    id: 1,
                    name: 'Work',
                    hexColor: '347BD5',
                    // createdAt: DateTime.now(),
                    // updatedAt: DateTime.now(),
                  ),
                  const Category(
                    id: 2,
                    name: 'Personal',
                    hexColor: '347BD5',
                  ),
                ],
                unreadMessageCount: 3,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
              Room(
                id: 2,
                name: 'Si Kemplang',
                participants: [
                  Participant(
                    id: 1,
                    user: User(
                      id: 1,
                      username: 'Goofy',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                    lastViewed: DateTime.now(),
                  ),
                  Participant(
                    id: 2,
                    user: User(
                      id: 2,
                      username: 'Mickey',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                    lastViewed: DateTime.now(),
                  ),
                ],
                lastChat: Chat(
                  id: 1,
                  content: 'Eh goofy kenapa deh dia ?',
                  sentBy: 'Mickey',
                  type: ChatType.text,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
                categories: [
                  const Category(
                    id: 1,
                    name: 'Personal',
                    hexColor: '347BD5',
                  ),
                ],
                unreadMessageCount: 0,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
              Room(
                id: 3,
                name: 'Ketiga',
                participants: [
                  Participant(
                    id: 1,
                    user: User(
                      id: 1,
                      username: 'Goofy',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                    lastViewed: DateTime.now(),
                  ),
                  Participant(
                    id: 2,
                    user: User(
                      id: 2,
                      username: 'Mickey',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                    lastViewed: DateTime.now(),
                  ),
                  Participant(
                    id: 3,
                    user: User(
                      id: 3,
                      username: 'Donald',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                    lastViewed: DateTime.now(),
                  ),
                ],
                lastChat: Chat(
                  id: 1,
                  content: 'Halo',
                  sentBy: 'Goofy',
                  type: ChatType.text,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
                categories: [
                  const Category(
                    id: 5,
                    name: 'Touring',
                    hexColor: '347BD5',
                  ),
                ],
                unreadMessageCount: 5,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              ),
            ],
          ),
        );
}
