import 'package:api/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui/ui.dart';

import '../catalog_keys.dart';
import 'catalog_bloc.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

/// CatalogPage lists the bags and shows the picks the URL holds.
class CatalogPage extends StatefulWidget {
  const CatalogPage({
    super.key,
    required this.bagIds,
    required this.onSelectionChanged,
    required this.onContinue,
  });

  /// bagIds holds the bag ids from the URL, as written.
  final List<String> bagIds;

  /// onSelectionChanged asks the app to replace the URL with these picks.
  final ValueChanged<List<String>> onSelectionChanged;

  /// onContinue asks the app to start checkout with these picks.
  final ValueChanged<List<String>> onContinue;

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(CatalogLinkChanged(widget.bagIds));
  }

  @override
  void didUpdateWidget(CatalogPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.bagIds, widget.bagIds)) {
      context.read<CatalogBloc>().add(CatalogLinkChanged(widget.bagIds));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CatalogBloc, CatalogState>(
      listenWhen: (previous, current) =>
          current.needsCleanUrl &&
          (!previous.needsCleanUrl ||
              !listEquals(previous.picked, current.picked)),
      listener: (context, state) => widget.onSelectionChanged(state.picked),
      builder: (context, state) => switch (state.status) {
        CatalogStatus.loading => const StateView.loading(title: 'Loading bags'),
        CatalogStatus.failed => StateView.error(
          title: 'Bags could not load',
          message: 'Something went wrong. Try again.',
          actionLabel: 'Try again',
          actionKey: CatalogKeys.retry,
          onAction: () =>
              context.read<CatalogBloc>().add(const CatalogLoadRequested()),
        ),
        CatalogStatus.loaded when state.bags.isEmpty => const StateView.empty(
          icon: Icons.shopping_bag_outlined,
          title: 'No bags today',
          message: 'Check back tomorrow for new bags.',
        ),
        CatalogStatus.loaded => _Catalog(
          state: state,
          onToggle: (id) =>
              widget.onSelectionChanged(BagSelection.toggle(state.picked, id)),
          onContinue: () => widget.onContinue(state.picked),
        ),
      },
    );
  }
}

class _Catalog extends StatelessWidget {
  const _Catalog({
    required this.state,
    required this.onToggle,
    required this.onContinue,
  });

  static const _maxWidth = 960.0;

  final CatalogState state;
  final ValueChanged<String> onToggle;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sizeClass = WindowSizeClass.fromWidth(
      MediaQuery.sizeOf(context).width,
    );
    final padding = sizeClass == WindowSizeClass.compact
        ? AppSpacing.lg
        : AppSpacing.xl;
    final columns = sizeClass == WindowSizeClass.compact ? 1 : 2;
    final tiles = [for (final bag in state.bags) _tile(bag)];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Bags', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Surplus bags from ${state.bags.first.store.name}. '
                      'Pick up to ${BagSelection.maxBags}.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (state.leftOut) ...[
                      const SizedBox(height: AppSpacing.lg),
                      InlineNotice(
                        key: CatalogKeys.notice,
                        message:
                            'A max of ${BagSelection.maxBags} bags can be selected, some bags were removed',
                        tone: InlineNoticeTone.error,
                        dismissKey: CatalogKeys.noticeDismiss,
                        onDismiss: () => context.read<CatalogBloc>().add(
                          const CatalogNoticeDismissed(),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    for (var i = 0; i < tiles.length; i += columns) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.lg),
                      _row(tiles.skip(i).take(columns).toList(), columns),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        _Summary(
          state: state,
          padding: padding,
          maxWidth: _maxWidth,
          onContinue: onContinue,
        ),
      ],
    );
  }

  Widget _tile(Bag bag) {
    final enabled = state.canPick(bag.id);
    return BagTile(
      key: CatalogKeys.bag(bag.id),
      title: bag.name,
      description: bag.description,
      priceCents: bag.price.cents,
      worthCents: bag.worth.cents,
      selected: state.picked.contains(bag.id),
      enabled: enabled,
      hint: enabled ? null : 'You can pick up to ${BagSelection.maxBags} bags',
      onTap: () => onToggle(bag.id),
    );
  }

  static Widget _row(List<Widget> tiles, int columns) {
    if (columns == 1) return tiles.single;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < columns; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.lg),
            Expanded(child: i < tiles.length ? tiles[i] : const SizedBox()),
          ],
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.state,
    required this.padding,
    required this.maxWidth,
    required this.onContinue,
  });

  final CatalogState state;
  final double padding;
  final double maxWidth;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = switch (state.picked.length) {
      0 => 'No bags picked',
      1 => '1 bag',
      final n => '$n bags',
    };

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: AppSpacing.md,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  container: true,
                  liveRegion: true,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          count,
                          key: CatalogKeys.summaryCount,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        'Total',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        formatZar(state.total.cents),
                        key: CatalogKeys.summaryTotal,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              AppButton(
                key: CatalogKeys.continueButton,
                label: 'Continue',
                onPressed: state.picked.isEmpty ? null : onContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
