import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HotKey {
  final PhysicalKeyboardKey key;
  final List<HotKeyModifier>? modifiers;
  final String? identifier;
  final HotKeyScope scope;

  HotKey({
    required this.key,
    this.modifiers,
    this.identifier,
    this.scope = HotKeyScope.system,
  });
}

enum HotKeyModifier { alt, control, shift, meta, capsLock, fn }

enum HotKeyScope { system, inapp }

class HotKeyRecorder extends StatelessWidget {
  final HotKey? initalHotKey;
  final ValueChanged<HotKey> onHotKeyRecorded;

  const HotKeyRecorder({
    super.key,
    this.initalHotKey,
    required this.onHotKeyRecorded,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
