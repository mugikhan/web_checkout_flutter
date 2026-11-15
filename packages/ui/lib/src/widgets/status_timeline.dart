import 'package:material_ui/material_ui.dart';

import '../tokens/app_motion.dart';
import '../tokens/app_spacing.dart';

enum TimelineStepState { reached, upcoming, failed }

/// TimelineStep is one row of a [StatusTimeline].
class TimelineStep {
  const TimelineStep({required this.label, required this.state, this.timeText});

  final String label;
  final TimelineStepState state;

  /// timeText is the step's time, shown once the step is reached or failed.
  final String? timeText;
}

/// StatusTimeline lists the steps of a process and animates a step as it is reached.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.steps});

  final List<TimelineStep> steps;

  /// markerKey keys the marker of the step at [index], for tests.
  static Key markerKey(int index) => ValueKey('status-timeline-marker-$index');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, step) in steps.indexed)
          _StepRow(
            key: ValueKey('status-timeline-step-$index'),
            step: step,
            markerKey: markerKey(index),
            last: index == steps.length - 1,
          ),
      ],
    );
  }
}

class _StepRow extends StatefulWidget {
  const _StepRow({
    super.key,
    required this.step,
    required this.markerKey,
    required this.last,
  });

  final TimelineStep step;
  final Key markerKey;
  final bool last;

  @override
  State<_StepRow> createState() => _StepRowState();
}

class _StepRowState extends State<_StepRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.long,
    value: 1,
  );
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: AppMotion.longCurve,
  );

  @override
  void didUpdateWidget(_StepRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    final reachedNow =
        oldWidget.step.state == TimelineStepState.upcoming &&
        widget.step.state != TimelineStepState.upcoming;
    if (!reachedNow) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final step = widget.step;
    final (markerColor, labelColor, icon) = switch (step.state) {
      TimelineStepState.reached => (
        scheme.primary,
        scheme.onSurface,
        Icons.check_circle,
      ),
      TimelineStepState.upcoming => (
        scheme.onSurfaceVariant,
        scheme.onSurfaceVariant,
        Icons.circle_outlined,
      ),
      TimelineStepState.failed => (scheme.error, scheme.error, Icons.cancel),
    };
    final timeText = step.state == TimelineStepState.upcoming
        ? null
        : step.timeText;

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: timeText == null
          ? '${step.label}, not reached yet'
          : '${step.label}, $timeText',
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          final t = _progress.value;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Transform.scale(
                      scale: 0.6 + 0.4 * t,
                      child: Icon(
                        icon,
                        key: widget.markerKey,
                        color: markerColor,
                      ),
                    ),
                    if (!widget.last)
                      Expanded(
                        child: Container(width: 2, color: scheme.outline),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: widget.last ? 0 : AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.label,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: labelColor,
                          ),
                        ),
                        if (timeText != null)
                          Opacity(
                            opacity: t,
                            child: Text(
                              timeText,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
