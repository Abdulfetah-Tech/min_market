// Design system buttons

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.fullWidth = false,
    this.icon,
    this.iconAlignment = IconAlignment.start,
    this.tooltip,
    this.semanticLabel,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final bool fullWidth;
  final Widget? icon;
  final IconAlignment iconAlignment;
  final String? tooltip;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final effectiveOnPressed = (isLoading || isDisabled || onPressed == null)
        ? null
        : () {
            HapticFeedback.lightImpact();
            onPressed!();
          };

    Widget buttonChild = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: _iconSize(size),
            height: _iconSize(size),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AppButtonVariant.primary
                    ? colorScheme.onPrimary
                    : colorScheme.primary,
              ),
            ),
          )
        else if (icon != null && iconAlignment == IconAlignment.start) ...[
          icon!,
          SizedBox(width: _iconSpacing(size)),
        ],
        Flexible(child: child),
        if (icon != null && iconAlignment == IconAlignment.end) ...[
          SizedBox(width: _iconSpacing(size)),
          icon!,
        ],
      ],
    );

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(fullWidth ? double.infinity : 0, _height(size)),
            padding: _padding(size),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius(size)),
            ),
          ),
          child: buttonChild,
        ),
      AppButtonVariant.secondary => FilledButton.tonal(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(fullWidth ? double.infinity : 0, _height(size)),
            padding: _padding(size),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius(size)),
            ),
          ),
          child: buttonChild,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(fullWidth ? double.infinity : 0, _height(size)),
            padding: _padding(size),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius(size)),
            ),
          ),
          child: buttonChild,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(fullWidth ? double.infinity : 0, _height(size)),
            padding: _padding(size),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius(size)),
            ),
          ),
          child: buttonChild,
        ),
      AppButtonVariant.destructive => FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(fullWidth ? double.infinity : 0, _height(size)),
            padding: _padding(size),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_radius(size)),
            ),
            backgroundColor: colorScheme.errorContainer,
            foregroundColor: colorScheme.onErrorContainer,
          ),
          child: buttonChild,
        ),
    };

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: Semantics(
          label: semanticLabel,
          button: true,
          enabled: effectiveOnPressed != null,
          child: button,
        ),
      );
    }

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: effectiveOnPressed != null,
      child: button,
    );
  }

  double _height(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  EdgeInsetsGeometry _padding(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double _radius(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 8;
      case AppButtonSize.medium:
        return 12;
      case AppButtonSize.large:
        return 16;
    }
  }

  double _iconSize(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  double _iconSpacing(AppButtonSize size) {
    switch (size) {
      case AppButtonSize.small:
        return 6;
      case AppButtonSize.medium:
        return 8;
      case AppButtonSize.large:
        return 12;
    }
  }
}

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  text,
  destructive,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

enum IconAlignment { start, end }

/// Icon button with consistent styling
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = AppButtonSize.medium,
    this.variant = AppButtonVariant.outline,
    this.tooltip,
    this.semanticLabel,
    this.isDisabled = false,
    this.color,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final AppButtonSize size;
  final AppButtonVariant variant;
  final String? tooltip;
  final String? semanticLabel;
  final bool isDisabled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveOnPressed = (isDisabled || onPressed == null) ? null : onPressed;

    double dimension;
    EdgeInsetsGeometry padding;
    double radius;

    switch (size) {
      case AppButtonSize.small:
        dimension = 36;
        padding = EdgeInsets.zero;
        radius = 8;
        break;
      case AppButtonSize.medium:
        dimension = 48;
        padding = EdgeInsets.zero;
        radius = 12;
        break;
      case AppButtonSize.large:
        dimension = 56;
        padding = EdgeInsets.zero;
        radius = 16;
        break;
    }

    Widget button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(dimension, dimension),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: icon,
        ),
      AppButtonVariant.secondary => FilledButton.tonal(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(dimension, dimension),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: icon,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(dimension, dimension),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: icon,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(dimension, dimension),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: icon,
        ),
      AppButtonVariant.destructive => FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: Size(dimension, dimension),
            padding: padding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            backgroundColor: colorScheme.errorContainer,
            foregroundColor: colorScheme.onErrorContainer,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: icon,
        ),
    };

    if (color != null) {
      button = IconTheme(
        data: IconThemeData(color: color),
        child: button,
      );
    }

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: Semantics(
          label: semanticLabel,
          button: true,
          enabled: effectiveOnPressed != null,
          child: button,
        ),
      );
    }

    return Semantics(
      label: semanticLabel,
      button: true,
      enabled: effectiveOnPressed != null,
      child: button,
    );
  }
}