import 'package:categorease/config/theme/app_theme.dart';
import 'package:categorease/feature/search/widgets/search_delegate.dart';
import 'package:categorease/feature/search/widgets/user_tile.dart';
import 'package:categorease/gen/assets.gen.dart';
import 'package:categorease/utils/extension.dart';
import 'package:categorease/utils/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    // This is a workaround of [https://github.com/flutter/flutter/issues/106789]
    // an hero animation on textfield dismiss a keyboard.
    Future.delayed(const Duration(milliseconds: 400))
        .then((val) => _focusNode.requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: CustomScrollView(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Hero(
                    tag: 'search',
                    child: Material(
                      child: TextField(
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Search for users',
                          suffixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
          SliverList.builder(
            itemBuilder: (context, index) {
              if (index == (10 + 1) - 1) return 60.heightMargin;
              return const UserTile();
            },
            itemCount: 10 + 1,
          ),
          // NOTE: DO NOT REMOVE THIS SLIVER
          // const SliverToBoxAdapter(
          //   child: NoData(
          //     message: 'No users found',
          //   ),
          // ),
        ],
      ),
    );
  }
}
