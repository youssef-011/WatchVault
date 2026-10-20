import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

const double mediaCardGridMaxCrossAxisExtent = 180;
const double mediaCardGridSpacing = AppSpacing.md;
const double mediaCardGridPadding = AppSpacing.lg;

double mediaCardHeight(BuildContext context, double width) {
  final theme = Theme.of(context);
  final textScaler = MediaQuery.textScalerOf(context);
  final direction = Directionality.of(context);
  final titleHeight = _measuredLineHeight(
    theme.textTheme.titleSmall ?? DefaultTextStyle.of(context).style,
    textScaler,
    direction,
  );
  final subtitleHeight = _measuredLineHeight(
    theme.textTheme.bodySmall ?? DefaultTextStyle.of(context).style,
    textScaler,
    direction,
  );
  const titleGap = 8.0;
  const subtitleGap = 3.0;
  const safetyMargin = 8.0;

  return width * 1.5 +
      titleGap +
      titleHeight +
      subtitleGap +
      subtitleHeight +
      safetyMargin;
}

SliverGridDelegateWithFixedCrossAxisCount mediaCardGridDelegate(
  BuildContext context,
  double viewportWidth,
) {
  final contentWidth =
      (viewportWidth - mediaCardGridPadding * 2)
          .clamp(0.0, double.infinity)
          .toDouble();
  final calculatedColumnCount = ((contentWidth + mediaCardGridSpacing) /
          (mediaCardGridMaxCrossAxisExtent + mediaCardGridSpacing))
      .ceil();
  final columnCount = calculatedColumnCount < 1 ? 1 : calculatedColumnCount;
  final cellWidth =
      (contentWidth - mediaCardGridSpacing * (columnCount - 1)) / columnCount;

  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: columnCount,
    crossAxisSpacing: mediaCardGridSpacing,
    mainAxisSpacing: mediaCardGridSpacing,
    mainAxisExtent: mediaCardHeight(context, cellWidth),
  );
}

double _measuredLineHeight(
  TextStyle style,
  TextScaler textScaler,
  TextDirection textDirection,
) {
  final painter = TextPainter(
    text: TextSpan(text: 'Ag', style: style),
    textDirection: textDirection,
    textScaler: textScaler,
    maxLines: 1,
  )..layout();
  final height = painter.height;
  painter.dispose();
  return height;
}
