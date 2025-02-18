import 'dart:async';

import 'package:categorease/config/routes/app_router.dart';
import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/home/bloc/home_bloc.dart';
import 'package:categorease/feature/home/model/user.dart';
import 'package:categorease/feature/room/create_room.dart';
import 'package:categorease/feature/search/bloc/search_bloc.dart';
import 'package:categorease/feature/search/widgets/search_delegate.dart';
import 'package:categorease/feature/search/widgets/user_tile.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/app_dialog.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/widgets/app_refresh_indicator.dart';
import 'package:categorease/utils/widgets/error_widget.dart';
import 'package:categorease/utils/widgets/loading.dart';
import 'package:categorease/utils/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final FocusNode _focusNode;
  late SearchLoaded? successSearchState;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _usernameController = TextEditingController();
  Timer? _debouncer;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    context.read<SearchBloc>().add(FetchUser(username: ''));
    // This is a workaround of [https://github.com/flutter/flutter/issues/106789]
    // an hero animation on textfield dismiss a keyboard.
    Future.delayed(const Duration(milliseconds: 400))
        .then((val) => _focusNode.requestFocus());

    _scrollController.addListener(() {
      if (successSearchState == null) return;

      if (_scrollController.position.pixels <=
          _scrollController.position.maxScrollExtent - 100) return;

      if (successSearchState!.nextPageStatus.isLoading) return;

      context.read<SearchBloc>().add(FetchUserNextPage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: AppRefreshIndicator(
        onRefresh: () async {
          context
              .read<SearchBloc>()
              .add(FetchUser(username: _usernameController.text));
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            20.sliverHeightMargin,
            SliverPersistentHeader(
              floating: true,
              delegate: MySliverAppBarDelegate(
                minHeight: 70,
                maxHeight: 70,
                child: Container(
                  color: AppTheme.primaryBackground,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Hero(
                      tag: 'search',
                      child: Material(
                        child: TextField(
                          controller: _usernameController,
                          focusNode: _focusNode,
                          onChanged: (val) {
                            if (_debouncer?.isActive ?? false) {
                              _debouncer?.cancel();
                            }
                            _debouncer = Timer(200.milliseconds, () {
                              context
                                  .read<SearchBloc>()
                                  .add(FetchUser(username: val));
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search for users',
                            suffixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: SvgPicture.asset(
                                Assets.icons.search,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading || state is SearchInitial) {
                  return const SliverPadding(
                    padding: EdgeInsets.only(top: 10.0),
                    sliver: SliverToBoxAdapter(
                      child: Center(child: Loading()),
                    ),
                  );
                } else if (state is SearchError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: AppErrorWidget(
                        message: state.failure.message,
                        subMessage:
                            'You can refresh by pulling the current page',
                      ),
                    ),
                  );
                }

                successSearchState = state as SearchLoaded;

                if (successSearchState!.users.data.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: NoData(
                      message: 'No users found',
                    ),
                  );
                }

                return SliverList.builder(
                  itemBuilder: (context, index) {
                    if (index == (state.users.data.length + 1) - 1) {
                      return 60.heightMargin;
                    }
                    final User user = state.users.data[index];
                    return UserTile(
                      username: user.username,
                      onTap: () => _showConfirmationDialog(context, user),
                    );
                  },
                  itemCount: state.users.data.length + 1,
                );
              },
            ),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is! SearchLoaded) {
                  return const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  );
                }

                if (!state.nextPageStatus.isLoading) {
                  return const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  );
                }

                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 8),
                    child: Center(
                      child: Loading(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _showConfirmationDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: 'Create a room with this person ?',
          subtitle: 'Are you sure you want to chat with this person?',
          rejectAction: () {
            context.pop();
          },
          confirmAction: () {
            context.pop();
            context.push('/create-room', extra: CreateRoomArgs(user: user));
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }
}
