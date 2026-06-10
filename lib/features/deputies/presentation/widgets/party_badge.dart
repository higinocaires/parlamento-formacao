import 'package:flutter/material.dart';

/// A badge that displays a political party name or abbreviation.
///
/// It accepts a [partyName] and an optional [color].
/// If [color] is not provided, it falls back to the theme's primary color.
class PartyBadge extends StatelessWidget {
  final String partyName;
  final Color? color;

  const PartyBadge({required this.partyName, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Determine the base color (passed color or primary theme color)
    final baseColor = color ?? theme.colorScheme.primary;

    // Create a premium, modern chip style with a light tinted background and solid border/text.
    final backgroundColor = baseColor.withValues(alpha: 0.12);
    final borderColor = baseColor.withValues(alpha: 0.3);
    final textColor = baseColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Text(
        partyName,
        style: theme.textTheme.labelLarge?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
