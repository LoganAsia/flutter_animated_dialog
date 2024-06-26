import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_dialog_transitions.dart';

///Is dialog showing
bool isShowing = false;

enum DialogTransitionType {
  ///Fade animation
  fade,

  ///Slide from top animation
  slideFromTop,

  ///Slide from top fade animation
  slideFromTopFade,

  ///Slide from bottom animation
  slideFromBottom,

  ///Slide from bottom fade animation
  slideFromBottomFade,

  ///Slide from left animation
  slideFromLeft,

  ///Slide from left fade animation
  slideFromLeftFade,

  ///Slide from right animation
  slideFromRight,

  ///Slide from right fade animation
  slideFromRightFade,

  ///Scale animation
  scale,

  ///Fade scale animation
  fadeScale,

  ///Rotation animation
  rotate,

  ///Scale rotate animation
  scaleRotate,

  ///Fade rotate animation
  fadeRotate,

  ///3D Rotation animation
  rotate3D,

  ///Size animation
  size,

  ///Size fade animation
  sizeFade,

  ///No animation
  none,
}

/// Displays a Material dialog above the current contents of the app
// Updated BuildContext parameter to ensure that the parameter is always provided and is not null
Future<T> showAnimatedDialog<T>({
  required BuildContext context,
  bool barrierDismissible = false,
  required WidgetBuilder builder,
  DialogTransitionType animationType = DialogTransitionType.fade,
  Curve curve = Curves.linear,
  Duration? duration,
  AlignmentGeometry alignment = Alignment.center,
  Axis? axis,
}) {
  assert(context != null, 'A non-null BuildContext must be provided.');
  assert(builder != null, 'A non-null WidgetBuilder must be provided.');
  assert(debugCheckHasMaterialLocalizations(context), 'MaterialLocalizations are required.');

  final ThemeData theme = Theme.of(context);

  isShowing = true;
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        top: false,
        child: Builder(builder: (BuildContext context) {
          return theme != null
              ? Theme(data: theme, child: pageChild)
              : pageChild;
        }),
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: duration ?? const Duration(milliseconds: 400),
    transitionBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      switch (animationType) {
        case DialogTransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
          break;
        case DialogTransitionType.slideFromRight:
          return SlideTransition(
            transformHitTests: false,
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: child,
          );
          break;
        case DialogTransitionType.slideFromLeft:
          return SlideTransition(
            transformHitTests: false,
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: child,
          );
          break;
        case DialogTransitionType.slideFromRightFade:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
          break;
        case DialogTransitionType.slideFromLeftFade:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
          break;
        case DialogTransitionType.slideFromTop:
          return SlideTransition(
            transformHitTests: false,
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: child,
          );
          break;
        case DialogTransitionType.slideFromTopFade:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, -1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
          break;
        case DialogTransitionType.slideFromBottom:
          return SlideTransition(
            transformHitTests: false,
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: child,
          );
          break;
        case DialogTransitionType.slideFromBottomFade:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve)).animate(animation),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
          break;
        case DialogTransitionType.scale:
          return ScaleTransition(
            alignment: alignment,
            scale: CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.50,
                curve: curve,
              ),
            ),
            child: child,
          );
          break;
        case DialogTransitionType.fadeScale:
          return ScaleTransition(
            alignment: alignment,
            scale: CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.50,
                curve: curve,
              ),
            ),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              child: child,
            ),
          );
          break;
        case DialogTransitionType.scaleRotate:
          return ScaleTransition(
            alignment: alignment,
            scale: CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.50,
                curve: curve,
              ),
            ),
            child: CustomRotationTransition(
              alignment: alignment,
              turns: Tween<double>(begin: 1, end: 2).animate(CurvedAnimation(
                  parent: animation, curve: Interval(0.0, 1.0, curve: curve))),
              child: child,
            ),
          );
          break;
        case DialogTransitionType.rotate:
          return CustomRotationTransition(
            alignment: alignment,
            turns: Tween<double>(begin: 1, end: 2).animate(CurvedAnimation(
                parent: animation, curve: Interval(0.0, 1.0, curve: curve))),
            child: child,
          );
          break;
        case DialogTransitionType.fadeRotate:
          return CustomRotationTransition(
            alignment: alignment,
            turns: Tween<double>(begin: 1, end: 2).animate(CurvedAnimation(
                parent: animation, curve: Interval(0.0, 1.0, curve: curve))),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              child: child,
            ),
          );
          break;
        case DialogTransitionType.rotate3D:
          return Rotation3DTransition(
            alignment: alignment,
            turns: Tween<double>(begin: math.pi, end: 2.0 * math.pi).animate(
                CurvedAnimation(
                    parent: animation,
                    curve: Interval(0.0, 1.0, curve: curve))),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: animation,
                      curve: Interval(0.5, 1.0, curve: Curves.elasticOut))),
              child: child,
            ),
          );
          break;
        case DialogTransitionType.size:
          return Align(
            alignment: alignment ?? Alignment.center,
            child: SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              axis: axis ?? Axis.vertical,
              child: child,
            ),
          );
          break;
        case DialogTransitionType.sizeFade:
          return Align(
            alignment: alignment ?? Alignment.center,
            child: SizeTransition(
              sizeFactor: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
                child: child,
              ),
            ),
          );
          break;
        case DialogTransitionType.none:
          return child;
          break;
        default:
          return FadeTransition(opacity: animation, child: child);
      }
    },
  );
}

class CustomDialogWidget extends StatelessWidget {
  
  // Updated Key parameter to ensure that the parameter is always provided and is not null
  // Updated titleText parameter to ensure that the parameter is always provided and is not null
  const CustomDialogWidget({
    required Key key,
    required this.titleText,
    this.title,
    this.titlePadding,
    this.titleTextStyle,
    this.content,
    this.contentPadding = const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
    this.contentTextStyle,
    this.bottomWidget,
    this.actions,
    this.backgroundColor,
    this.elevation,
    this.semanticLabel,
    this.shape,
    this.minWidth,
  })  : assert(contentPadding != null),
        super(key: key);

  final Key key;
  final String titleText; // Make titleText non-nullable
  final Widget? title;
  final EdgeInsetsGeometry? titlePadding;
  final TextStyle? titleTextStyle;
  final Widget? content;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? contentTextStyle;
  final Widget? bottomWidget;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double? elevation;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final double? minWidth;

  @override
  // Updated BuildContext parameter to ensure that the parameter is always provided and is not null
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = Theme.of(context);
    final DialogTheme dialogTheme = DialogTheme.of(context);
    final List<Widget> children = <Widget>[];
    String label = semanticLabel;

    if (title != null) {
      children.add(Padding(
        padding: titlePadding ??
            EdgeInsets.fromLTRB(24.0, 24.0, 24.0, content == null ? 20.0 : 0.0),
        child: DefaultTextStyle(
          style: titleTextStyle ??
              dialogTheme.titleTextStyle ??
              theme.textTheme.titleLarge,
          child: Semantics(
            child: title,
            namesRoute: true,
            container: true,
          ),
        ),
      ));
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          label = semanticLabel;
          break;
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          label = semanticLabel ??
              MaterialLocalizations.of(context)?.alertDialogLabel;
          break;
        case TargetPlatform.linux:
          label = semanticLabel ??
              MaterialLocalizations.of(context)?.alertDialogLabel;
          break;
        case TargetPlatform.macOS:
          label = semanticLabel;
          break;
        case TargetPlatform.windows:
          label = semanticLabel ??
              MaterialLocalizations.of(context)?.alertDialogLabel;
          break;
      }
    }

    if (content != null) {
      children.add(
        Flexible(
          child: Padding(
            padding: contentPadding,
            child: DefaultTextStyle(
              style: contentTextStyle ??
                  dialogTheme.contentTextStyle ??
                  theme.textTheme.subtitle1,
              child: content,
            ),
          ),
        ),
      );
    }

    if (bottomWidget != null) {
      children.add(bottomWidget);
    } else if (actions != null) {
      children.add(
        ButtonBarTheme(
          data: ButtonBarTheme.of(context),
          child: ButtonBar(
            children: actions,
          ),
        ),
      );
    }

    Widget dialogChild = IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );

    if (label != null)
      dialogChild = Semantics(
        namesRoute: true,
        label: label,
        child: dialogChild,
      );

    dialogChild = CustomDialog(
      backgroundColor: backgroundColor,
      elevation: elevation,
      minWidth: minWidth,
      shape: shape,
      child: dialogChild,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarIconBrightness: Brightness.light,
            statusBarColor: Colors.transparent),
        child: dialogChild);
  }
}

class CustomDialog extends StatelessWidget {
  /// Creates a dialog.
  /// Typically used in conjunction with [showDialog].
  // Updated Key parameter to ensure that the parameter is always provided and is not null
  const CustomDialog({
    required Key key,
    this.backgroundColor,
    this.elevation,
    this.insetAnimationDuration = const Duration(milliseconds: 100),
    this.insetAnimationCurve = Curves.decelerate,
    this.minWidth = 280.0,
    this.shape,
    this.child,
  }) : super(key: key);

  final Color? backgroundColor;
  final double? elevation;
  final Duration insetAnimationDuration;
  final Curve insetAnimationCurve;
  final double minWidth;
  final ShapeBorder? shape;
  final Widget? child;

  // TODO(johnsonmh): Update default dialog border radius to 4.0 to match material spec.
  static const RoundedRectangleBorder _defaultDialogShape =
      RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)));
  static const double _defaultElevation = 24.0;

  @override
  Widget build(BuildContext context) {
  // Ensure context is not null
  assert(context != null, 'BuildContext cannot be null');

  final DialogTheme dialogTheme = DialogTheme.of(context);
  return AnimatedPadding(
    padding: MediaQuery.of(context).viewInsets +
        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
    duration: insetAnimationDuration,
    curve: insetAnimationCurve,
    child: MediaQuery.removeViewInsets(
      removeLeft: true,
      removeTop: true,
      removeRight: true,
      removeBottom: true,
      context: context,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: minWidth ?? 280.0),
          child: Material(
            color: backgroundColor ??
                dialogTheme.backgroundColor ??
                Theme.of(context).dialogBackgroundColor,
            elevation:
                elevation ?? dialogTheme.elevation ?? _defaultElevation,
            shape: shape ?? dialogTheme.shape ?? _defaultDialogShape,
            type: MaterialType.card,
            child: child,
          ),
        ),
      ),
    ),
  );
}
}
