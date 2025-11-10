import 'package:flutter/material.dart';

import 'global_elevated_button.dart';
import 'global_icon_button.dart';
import 'global_text_button.dart';

enum DialogType {
  confirmation,
  form,
  custom,
}

class GlobalDialog extends StatefulWidget {
  final String title;
  final String? message;
  final DialogType dialogType;
  final Widget? customContent;
  final List<Widget>? formFields;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool barrierDismissible;
  final Color? barrierColor;
  final BorderRadius? borderRadius;
  final double? maxWidth;
  final double? maxHeight;
  final String? Function(Map<String, String>)? formValidator;
  final Map<String, TextEditingController>? formControllers;
  final bool showCloseButton;
  final bool isConfirmLoading; // New property for confirm button loading state
  final bool isCancelLoading; // New property for cancel button loading state

  const GlobalDialog({
    super.key,
    required this.title,
    this.message,
    this.dialogType = DialogType.confirmation,
    this.customContent,
    this.formFields,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.barrierDismissible = true,
    this.barrierColor,
    this.borderRadius,
    this.maxWidth = 400,
    this.maxHeight,
    this.formValidator,
    this.formControllers,
    this.showCloseButton = true,
    this.isConfirmLoading = false,
    this.isCancelLoading = false,
  }) : assert(
          dialogType != DialogType.form ||
              (formFields != null && formControllers != null),
          'Form dialogs require formFields and formControllers',
        );

  @override
  State<GlobalDialog> createState() => _GlobalDialogState();

  static Future<void> show({
    required BuildContext context,
    required String title,
    String? message,
    DialogType dialogType = DialogType.confirmation,
    Widget? customContent,
    List<Widget>? formFields,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    Color? barrierColor,
    BorderRadius? borderRadius,
    double? maxWidth,
    double? maxHeight,
    String? Function(Map<String, String>)? formValidator,
    Map<String, TextEditingController>? formControllers,
    bool showCloseButton = true,
    bool isConfirmLoading = false,
    bool isCancelLoading = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      builder: (context) => GlobalDialog(
        title: title,
        message: message,
        dialogType: dialogType,
        customContent: customContent,
        formFields: formFields,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        maxWidth: maxWidth ?? 400.0,
        maxHeight: maxHeight ?? double.infinity,
        formValidator: formValidator,
        formControllers: formControllers ?? {},
        showCloseButton: showCloseButton,
        isConfirmLoading: isConfirmLoading,
        isCancelLoading: isCancelLoading,
      ),
    );
  }
}

class _GlobalDialogState extends State<GlobalDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  String? _errorText;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (widget.dialogType == DialogType.form) {
      if (_formKey.currentState!.validate()) {
        if (widget.formValidator != null && widget.formControllers != null) {
          final formData = widget.formControllers!
              .map((key, controller) => MapEntry(key, controller.text));
          final error = widget.formValidator!(formData);
          if (error != null) {
            setState(() {
              _errorText = error;
            });
            return;
          }
        }
        widget.onConfirm?.call();
        Navigator.of(context).pop();
      }
    } else {
      widget.onConfirm?.call();
      Navigator.of(context).pop();
    }
  }

  void _handleCancel() {
    widget.onCancel?.call();
    Navigator.of(context).pop();
  }

  Widget _buildContent() {
    switch (widget.dialogType) {
      case DialogType.confirmation:
        return _buildConfirmationContent();
      case DialogType.form:
        return _buildFormContent();
      case DialogType.custom:
        return widget.customContent ?? const SizedBox.shrink();
    }
  }

  Widget _buildConfirmationContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.message != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              widget.message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...?widget.formFields?.map((field) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: field,
              )),
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Text(
                _errorText!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (widget.cancelText != null)
            GlobalTextButton(
              text: widget.cancelText!,
              onPressed: _handleCancel,
              isLoading: widget.isCancelLoading,
              foregroundColor: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(8),
              tooltip: 'Cancel',
            ),
          const SizedBox(width: 8),
          if (widget.confirmText != null)
            GlobalElevatedButton(
              text: widget.confirmText!,
              onPressed: _handleConfirm,
              isLoading: widget.isConfirmLoading,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(8),
              tooltip: 'Confirm',
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth ?? double.infinity,
          maxHeight: widget.maxHeight ?? double.infinity,
        ),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (widget.showCloseButton)
                        GlobalIconButton(
                          iconData: Icons.close,
                          onPressed: _handleCancel,
                          iconColor: Theme.of(context).colorScheme.onSurface,
                          borderRadius: BorderRadius.circular(8),
                          tooltip: 'Close',
                        ),
                    ],
                  ),
                ),
                // Content
                Flexible(child: _buildContent()),
                // Actions
                _buildActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
