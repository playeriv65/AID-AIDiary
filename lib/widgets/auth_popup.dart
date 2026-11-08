// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
// Additional terms under GPLv3 section 7 apply; see ADDITIONAL_TERMS.md.

import 'package:aid_diary/l10n/generated/app_localizations.dart';
import 'package:aid_diary/utils/password_store.dart';
import 'package:aid_diary/widgets/new_password_fields.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

/// Asks the platform whether the person at the device is its owner, with
/// [reason] on the prompt: a fingerprint or face, or with [biometricOnly]
/// off also the screen lock. False when they are not, or when this device
/// cannot ask.
Future<bool> authenticateOnDevice(
    {required String reason, bool biometricOnly = true}) async {
  try {
    final auth = LocalAuthentication();
    if (biometricOnly && !await auth.canCheckBiometrics) return false;
    return await auth.authenticate(
      localizedReason: reason,
      biometricOnly: biometricOnly,
      persistAcrossBackgrounding: false,
    );
  } on PlatformException {
    return false;
  } on LocalAuthException {
    return false;
  } on MissingPluginException {
    return false;
  }
}

enum AuthPopupMode { unlock, enterPassword, setPassword, changePassword }

class AuthPopup extends StatefulWidget {
  final AuthPopupMode mode;
  final String title;
  final String? description;
  final bool showBiometrics;
  final bool dismissable;
  final PasswordStore store;
  final void Function(String password)? onSuccess;

  const AuthPopup({
    super.key,
    required this.mode,
    required this.title,
    this.description,
    required this.showBiometrics,
    required this.dismissable,
    this.store = const AppPasswordStore(),
    this.onSuccess,
  });

  @override
  State<AuthPopup> createState() => _AuthPopupState();
}

class _AuthPopupState extends State<AuthPopup> {
  final _formKey = GlobalKey<FormState>();
  final _oldController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  String? _error;
  bool _showPassword = false;
  bool _biometricsPrompted = false;
  bool _isPin = false;
  bool _passwordFocusRequested = false;
  Animation<double>? _routeAnimation;

  bool get _asksForNewPassword =>
      widget.mode == AuthPopupMode.setPassword ||
      widget.mode == AuthPopupMode.changePassword;

  @override
  void initState() {
    super.initState();
    if (widget.mode == AuthPopupMode.unlock) {
      _isPin = widget.store.isPin;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Request keyboard focus after dialog animation completes
    if (!_asksForNewPassword && !widget.showBiometrics) {
      final animation = ModalRoute.of(context)?.animation;
      if (animation != _routeAnimation) {
        _routeAnimation?.removeStatusListener(_handleRouteAnimationStatus);
        _routeAnimation = animation;
        _routeAnimation?.addStatusListener(_handleRouteAnimationStatus);
        if (_routeAnimation == null || _routeAnimation!.isCompleted) {
          _requestPasswordFocus();
        }
      }
    }
  }

  void _handleRouteAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _requestPasswordFocus();
    }
  }

  void _requestPasswordFocus() {
    if (_passwordFocusRequested) return;
    _passwordFocusRequested = true;
    _passwordFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_handleRouteAnimationStatus);
    _oldController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _succeed(String password) {
    if (!mounted) return;
    widget.onSuccess?.call(password);
    Navigator.of(context).pop();
  }

  Future<void> _handleSubmit() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      switch (widget.mode) {
        case AuthPopupMode.unlock:
          if (await widget.store.validate(_passwordController.text)) {
            _succeed(_passwordController.text);
          } else {
            setState(
              () => _error = AppLocalizations.of(context)!
                  .settingsSecurityIncorrectPassword,
            );
          }
          break;

        case AuthPopupMode.enterPassword:
          _succeed(_passwordController.text);
          break;

        case AuthPopupMode.setPassword:
        case AuthPopupMode.changePassword:
          if (widget.mode == AuthPopupMode.changePassword &&
              !await widget.store.validate(_oldController.text)) {
            setState(
              () => _error = AppLocalizations.of(context)!
                  .settingsSecurityIncorrectPassword,
            );
            break;
          }
          await widget.store.save(_passwordController.text);
          _succeed(_passwordController.text);
          break;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleBiometric() async {
    final reason = AppLocalizations.of(context)!.unlockAppPrompt;
    if (await authenticateOnDevice(reason: reason)) _succeed('');
  }

  /// A password the user already has: the current one, or one to open
  /// something with.
  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
    TextInputType keyboardType = TextInputType.text,
  }) =>
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: !_showPassword,
        autocorrect: false,
        enableSuggestions: false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
        validator: (v) =>
            v!.isEmpty ? AppLocalizations.of(context)!.requiredPrompt : null,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (widget.showBiometrics && !_biometricsPrompted) {
      _biometricsPrompted = true;
      _handleBiometric();
    }
    return PopScope(
      canPop: widget.dismissable,
      child: AlertDialog(
        title: Column(
          children: [
            Center(
              child: Icon(
                Icons.lock_rounded,
                color: Theme.of(context).colorScheme.onSurface,
                size: 32,
              ),
            ),
            SizedBox(height: 4),
            Text(widget.title),
          ],
        ),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.description != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(widget.description!),
                ),
              if (widget.mode == AuthPopupMode.changePassword) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _passwordField(
                    controller: _oldController,
                    label: l10n.settingsSecurityOldPassword,
                  ),
                ),
                Divider(),
              ],
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _asksForNewPassword
                    ? NewPasswordFields(
                        password: _passwordController,
                        repeat: _confirmController,
                        minLength: widget.store.minLength,
                        label: l10n.settingsSecurityPassword,
                        repeatLabel: l10n.settingsSecurityConfirmPassword,
                        obscure: !_showPassword,
                        fieldKey: const ValueKey('auth-new-password'),
                        repeatKey: const ValueKey('auth-repeat-password'),
                      )
                    : _passwordField(
                        controller: _passwordController,
                        label: l10n.settingsSecurityPassword,
                        focusNode: _passwordFocusNode,
                        keyboardType:
                            widget.mode == AuthPopupMode.unlock && _isPin
                                ? TextInputType.number
                                : TextInputType.text,
                      ),
              ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              if (widget.mode == AuthPopupMode.unlock && widget.showBiometrics)
                IconButton(
                  onPressed: _handleBiometric,
                  icon: const Icon(Icons.fingerprint),
                  iconSize: 32,
                ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        !_showPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : IconButton.filled(
                            onPressed: _handleSubmit,
                            icon: Icon(Icons.check_rounded),
                            iconSize: 28,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
