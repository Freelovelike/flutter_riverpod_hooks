import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';

class Aaa extends HookConsumerWidget {
  const Aaa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = useState('aaa');
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showToast(text.value);
          },
          child: Text('aaa'),
        ),
      ),
    );
  }
}
