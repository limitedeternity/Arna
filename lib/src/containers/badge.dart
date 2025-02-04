import 'package:arna/arna.dart';

/// An Arna-styled badge.
class ArnaBadge extends StatelessWidget {
  /// Creates a badge in the Arna style.
  const ArnaBadge({
    super.key,
    required this.label,
    this.accentColor,
    this.textColor,
  });

  /// The text label of the badge.
  final String label;

  /// The background color of the badge.
  final Color? accentColor;

  /// The label color of the badge.
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final Color accent = accentColor ?? ArnaTheme.of(context).accentColor;
    return Padding(
      padding: Styles.small,
      child: AnimatedContainer(
        height: Styles.badgeSize,
        duration: Styles.basicDuration,
        curve: Styles.basicCurve,
        decoration: BoxDecoration(
          borderRadius: Styles.badgeBorderRadius,
          border: Border.all(color: ArnaDynamicColor.outerColor(accent)),
          color: accent,
        ),
        padding: Styles.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Text(
                label,
                style: ArnaTheme.of(context).textTheme.body!.copyWith(
                      color: textColor ?? ArnaDynamicColor.onBackgroundColor(accent),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
