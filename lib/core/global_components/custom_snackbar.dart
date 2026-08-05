import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  static OverlayEntry? _currentOverlay;

  static void show({
    required String title,
    required String message,
    bool isError = false,
    IconData? icon,
  }) {
    final context = Get.overlayContext ?? Get.context;
    if (context == null) return;

    final overlayState = Overlay.of(context);

    // Tutup snackbar lama biar tidak bentrok
    if (_currentOverlay != null) {
      try {
        _currentOverlay!.remove();
      } catch (_) {}
      _currentOverlay = null;
    }

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: _AnimatedSnackbarContent(
          title: title,
          message: message,
          isError: isError,
          icon: icon,
          onDismiss: () {
            try {
              overlayEntry.remove();
            } catch (_) {}
            if (_currentOverlay == overlayEntry) {
              _currentOverlay = null;
            }
          },
        ),
      ),
    );

    _currentOverlay = overlayEntry;
    overlayState.insert(overlayEntry);
  }
}

class _AnimatedSnackbarContent extends StatefulWidget {
  final String title;
  final String message;
  final bool isError;
  final IconData? icon;
  final VoidCallback onDismiss;

  const _AnimatedSnackbarContent({
    required this.title,
    required this.message,
    required this.isError,
    this.icon,
    required this.onDismiss,
  });

  @override
  State<_AnimatedSnackbarContent> createState() => _AnimatedSnackbarContentState();
}

class _AnimatedSnackbarContentState extends State<_AnimatedSnackbarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
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
                        widget.icon ?? (widget.isError ? Icons.error_rounded : Icons.check_circle_rounded),
                        color: widget.isError ? const Color(0xFFD32F2F) : const Color(0xFF388E3C),
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
                            widget.title,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.message,
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
    );
  }
}
