import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watchvault/core/models/media_item.dart';
import 'package:watchvault/features/catalog/application/catalog_scope.dart';
import 'package:watchvault/features/home/application/home_controller.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/router/details_route_arguments.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/load_state_view.dart';
import '../../../core/widgets/media_card.dart';
import '../../../core/widgets/media_card_sizing.dart';
import '../../../core/widgets/section_header.dart';
import '../../library/application/library_scope.dart';
import '../../library/domain/watch_status.dart';
import '../../library/domain/watch_status_label.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController _controller;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _controller = HomeController(catalog: CatalogScope.of(context));
    unawaited(_controller.loadIfNeeded());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = (MediaQuery.sizeOf(context).width * 0.38)
        .clamp(120.0, 180.0)
        .toDouble();
    final listHeight = mediaCardHeight(context, cardWidth);
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => RefreshIndicator(
        onRefresh: _controller.loadAll,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text(
                'WatchVault',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            for (final section in HomeSection.values)
              _MediaSection(
                controller: _controller,
                section: section,
                cardWidth: cardWidth,
                listHeight: listHeight,
              ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}

class _MediaSection extends StatelessWidget {
  const _MediaSection({
    required this.controller,
    required this.section,
    required this.cardWidth,
    required this.listHeight,
  });

  final HomeController controller;
  final HomeSection section;
  final double cardWidth;
  final double listHeight;

  String get title => switch (section) {
        HomeSection.trending => 'Trending',
        HomeSection.popularMovies => 'Popular Movies',
        HomeSection.popularSeries => 'Popular Series',
        HomeSection.topRatedMovies => 'Top Rated Movies',
        HomeSection.topRatedSeries => 'Top Rated Series',
      };

  @override
  Widget build(BuildContext context) {
    final state = controller.section(section);
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          SizedBox(
            height: listHeight,
            child: LoadStateView(
              compact: true,
              status: state.status,
              errorMessage: state.errorMessage,
              onRetry: () => unawaited(controller.loadSection(section)),
              childBuilder: (context) => _cards(state.items),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cards(List<MediaItem> items) => ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          0,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final heroTag = '${section.name}-${item.key.value}';
          return Padding(
            padding: EdgeInsetsDirectional.only(
              end: index == items.length - 1 ? 0 : AppSpacing.md,
            ),
            child: ListenableBuilder(
              listenable: LibraryScope.of(context),
              builder: (context, _) {
                final library = LibraryScope.of(context);
                return MediaCard(
                  item: item,
                  heroTag: heroTag,
                  width: cardWidth,
                  libraryStatusLabel:
                      library.entryFor(item.key)?.status.label,
                  libraryStatusIcon:
                      _statusIcon(library.entryFor(item.key)?.status),
                  onTap: () => Navigator.of(context).pushNamed(
                    AppRoutes.details,
                    arguments: DetailsRouteArguments(
                      item: item,
                      heroTag: heroTag,
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
}

IconData? _statusIcon(WatchStatus? status) => switch (status) {
      WatchStatus.wantToWatch => Icons.bookmark_border,
      WatchStatus.watching => Icons.play_circle_outline,
      WatchStatus.watched => Icons.check_circle_outline,
      null => null,
    };
