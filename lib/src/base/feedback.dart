import 'package:arna/arna.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/rendering.dart' show LongPressSemanticsEvent;
import 'package:flutter/services.dart' show HapticFeedback;

/// Provides platform-specific acoustic and/or haptic feedback for certain actions.
///
/// For the Android-specific vibration when long pressing an element, call [forLongPress]. Alternatively, you can also
/// wrap your [GestureDetector.onLongPress] callback in [wrapForLongPress] to achieve the same.
///
/// Calling any of these methods is a no-op on iOS as actions on that platform typically don't provide haptic feedback.
///
/// All methods in this class are usually called from within a [StatelessWidget.build] method or from a [State]'s
/// methods as you have to provide a [BuildContext].
///
/// {@tool snippet}
///
/// To trigger platform-specific feedback before executing the actual callback:
///
/// ```dart
/// class WidgetWithWrappedHandler extends StatelessWidget {
///   const WidgetWithWrappedHandler({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onLongPress: ArnaFeedback.wrapForLongPress(_onLongPressHandler, context),
///       child: const Text('X'),
///     );
///   }
///
///   void _onLongPressHandler() {
///     // Respond to long press.
///   }
/// }
/// ```
/// {@end-tool}
/// {@tool snippet}
///
/// Alternatively, you can also call [forLongPress] directly within your long press handler:
///
/// ```dart
/// class WidgetWithExplicitCall extends StatelessWidget {
///   const WidgetWithExplicitCall({Key? key}) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return GestureDetector(
///       onLongPress: () {
///         // Do some work (e.g. check if the long press is valid)
///         ArnaFeedback.forLongPress(context);
///         // Do more work (e.g. respond to the long press)
///       },
///       child: const Text('X'),
///     );
///   }
/// }
/// ```
/// {@end-tool}
class ArnaFeedback {
  // This class is not meant to be instantiated or extended; this constructor prevents instantiation and extension.
  ArnaFeedback._();

  /// Provides platform-specific feedback for a long press.
  ///
  /// On Android the platform-typical vibration is triggered. On iOS this is a no-op as that platform usually doesn't
  /// provide feedback for long presses.
  ///
  /// See also:
  ///
  ///  * [wrapForLongPress] to trigger platform-specific feedback before executing a [GestureLongPressCallback].
  static Future<void> forLongPress(BuildContext context) {
    context.findRenderObject()!.sendSemanticsEvent(const LongPressSemanticsEvent());
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return HapticFeedback.vibrate();
      case TargetPlatform.iOS:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return Future<void>.value();
    }
  }

  /// Wraps a [GestureLongPressCallback] to provide platform specific feedback for a long press before the provided
  /// callback is executed.
  ///
  /// On Android the platform-typical vibration is triggered. On iOS this is a no-op as that platform usually doesn't
  /// provide feedback for a long press.
  ///
  /// See also:
  ///
  ///  * [forLongPress] to just trigger the platform-specific feedback without wrapping a [GestureLongPressCallback].
  static GestureLongPressCallback? wrapForLongPress(GestureLongPressCallback? callback, BuildContext context) {
    if (callback == null) {
      return null;
    }
    return () {
      ArnaFeedback.forLongPress(context);
      callback();
    };
  }
}
