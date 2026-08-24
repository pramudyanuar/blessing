import 'dart:async';

import 'package:flutter/material.dart';

/// Data for a single in-app notification banner.
class _NotificationData {
  final String title;
  final String message;
  final bool isError;
  final IconData? icon;

  const _NotificationData({
    required this.title,
    required this.message,
    required this.isError,
    this.icon,
  });
}

/// App-wide notification banner, deliberately independent of GetX and of
/// Flutter's Overlay/ScaffoldMessenger.
///
/// Earlier versions of this went through Get.snackbar, then Get.rawSnackbar,
/// then a manually-inserted OverlayEntry, then ScaffoldMessenger — all of
/// them route through some form of BuildContext -> Overlay/Navigator
/// resolution (Get.overlayContext, Overlay.of(context), or
/// ScaffoldMessenger's own internal overlay), and all of them were observed
/// to fail intermittently on-device with "No Overlay widget found" or to
/// silently show nothing, most often right after a route change.
///
/// This version has none of that: `AppNotificationHost` is mounted once,
/// directly in the widget returned by GetMaterialApp's builder, and never
/// gets removed or recreated as a route pushes/pops. CustomSnackbar.show()
/// just writes into a ValueNotifier that the host listens to — no context,
/// no overlay, no navigator lookup, callable from anywhere (including a
/// GetxController with no BuildContext at all).
class CustomSnackbar {
  static final ValueNotifier<_NotificationData?> _notifier =
      ValueNotifier<_NotificationData?>(null);

  static void show({
    required String title,
    required String message,
    bool isError = false,
    IconData? icon,
  }) {
    _notifier.value = _NotificationData(
      title: title,
      message: message,
      isError: isError,
      icon: icon,
    );
  }
}

/// Wrap the app's root content with this once (see MainApp). Renders
/// whatever CustomSnackbar.show() posts as a banner pinned to the top of
/// the screen, above everything else, auto-dismissing after 3 seconds.
class AppNotificationHost extends StatefulWidget {
  final Widget child;

  const AppNotificationHost({super.key, required this.child});

  @override
  State<AppNotificationHost> createState() => _AppNotificationHostState();
}

class _AppNotificationHostState extends State<AppNotificationHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;

  _NotificationData? _current;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    CustomSnackbar._notifier.addListener(_onNotification);
  }

  void _onNotification() {
    final data = CustomSnackbar._notifier.value;
    if (data == null) return;

    _dismissTimer?.cancel();
    setState(() => _current = data);
    _controller.forward(from: 0);

    _dismissTimer = Timer(const Duration(seconds: 3), _dismiss);
  }

  void _dismiss() {
    if (!mounted || _current == null) return;
    _controller.reverse().then((_) {
      if (mounted) setState(() => _current = null);
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    CustomSnackbar._notifier.removeListener(_onNotification);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_current != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: SlideTransition(
                position: _offsetAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: _dismiss,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200, width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Icon(
                                  _current!.icon ??
                                      (_current!.isError
                                          ? Icons.error_rounded
                                          : Icons.check_circle_rounded),
                                  color: _current!.isError
                                      ? const Color(0xFFD32F2F)
                                      : const Color(0xFF388E3C),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _current!.title,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _current!.message,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
