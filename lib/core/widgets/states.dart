// Error, empty, and loading state widgets

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'app_button.dart';

/// Generic error state with retry action
class ErrorState extends StatelessWidget {
  const ErrorState({
    required this.message, super.key,
    this.title = 'Something went wrong',
    this.icon,
    this.onRetry,
    this.retryLabel = 'Try again',
    this.assetPath,
  });

  final String message;
  final String title;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String retryLabel;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetPath != null)
              SizedBox(
                width: 120,
                height: 120,
                child: Lottie.asset(
                  assetPath!,
                  fit: BoxFit.contain,
                ),
              )
            else
              Icon(
                icon ?? Icons.error_outline,
                size: 64,
                color: colorScheme.error,
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                onPressed: onRetry,
                child: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state with illustration
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.message, super.key,
    this.title = 'Nothing here yet',
    this.icon,
    this.actionLabel,
    this.onAction,
    this.assetPath,
  });

  final String message;
  final String title;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetPath != null)
              SizedBox(
                width: 160,
                height: 160,
                child: Lottie.asset(
                  assetPath!,
                  fit: BoxFit.contain,
                ),
              )
            else
              Icon(
                icon ?? Icons.inbox_outlined,
                size: 80,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              AppButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading state with shimmer or spinner
class LoadingState extends StatelessWidget {
  const LoadingState({
    super.key,
    this.message,
    this.showSpinner = true,
    this.assetPath,
  });

  final String? message;
  final bool showSpinner;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetPath != null)
              SizedBox(
                width: 80,
                height: 80,
                child: Lottie.asset(
                  assetPath!,
                  fit: BoxFit.contain,
                ),
              )
            else if (showSpinner)
              CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Offline state widget
class OfflineState extends StatelessWidget {
  const OfflineState({
    super.key,
    this.message = 'You are offline. Some features may be unavailable.',
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Offline',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                onPressed: onRetry,
                variant: AppButtonVariant.outline,
                child: const Text('Check Connection'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Success state widget
class SuccessState extends StatelessWidget {
  const SuccessState({
    required this.message, super.key,
    this.title = 'Success!',
    this.onContinue,
    this.continueLabel = 'Continue',
    this.assetPath,
  });

  final String message;
  final String title;
  final VoidCallback? onContinue;
  final String continueLabel;
  final String? assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (assetPath != null)
              SizedBox(
                width: 120,
                height: 120,
                child: Lottie.asset(
                  assetPath!,
                  fit: BoxFit.contain,
                ),
              )
            else
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: colorScheme.primary,
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onContinue != null) ...[
              const SizedBox(height: 24),
              AppButton(
                onPressed: onContinue,
                child: Text(continueLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network status banner
class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({
    super.key,
    this.isOnline = true,
    this.onlineMessage = 'Back online',
    this.offlineMessage = 'You are offline. Changes will sync when reconnected.',
  });

  final bool isOnline;
  final String onlineMessage;
  final String offlineMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isOnline) {
      return SizedBox(
        height: 48,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: const ValueKey('online'),
            width: double.infinity,
            color: colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(
                  Icons.wifi,
                  size: 18,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    onlineMessage,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 48,
      child: Container(
        width: double.infinity,
        color: colorScheme.errorContainer,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.wifi_off,
              size: 18,
              color: colorScheme.onErrorContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                offlineMessage,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}