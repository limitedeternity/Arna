import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Theme themeMode = ref.watch(themeProvider);
    final Color accentColor = ref.watch(accentProvider);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ArnaList(
            title: 'Theme',
            showDividers: true,
            showBackground: true,
            children: <Widget>[
              ArnaRadioListTile<Theme>(
                value: Theme.system,
                groupValue: themeMode,
                title: 'System',
                onChanged: (_) => ref.read(themeProvider.notifier).state = Theme.system,
              ),
              ArnaRadioListTile<Theme>(
                value: Theme.dark,
                groupValue: themeMode,
                title: 'Dark',
                onChanged: (_) => ref.read(themeProvider.notifier).state = Theme.dark,
              ),
              ArnaRadioListTile<Theme>(
                value: Theme.light,
                groupValue: themeMode,
                title: 'Light',
                onChanged: (_) => ref.read(themeProvider.notifier).state = Theme.light,
              ),
            ],
          ),
          ArnaList(
            title: 'Accent',
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            showBackground: true,
            children: <Widget>[
              ArnaColorButton<Color>(
                value: ArnaColors.blue,
                groupValue: accentColor,
                onPressed: () => ref.read(accentProvider.notifier).state = ArnaColors.blue,
                color: ArnaColors.blue,
              ),
              ArnaColorButton<Color>(
                value: ArnaColors.green,
                groupValue: accentColor,
                onPressed: () => ref.read(accentProvider.notifier).state = ArnaColors.green,
                color: ArnaColors.green,
              ),
              ArnaColorButton<Color>(
                value: ArnaColors.red,
                groupValue: accentColor,
                onPressed: () => ref.read(accentProvider.notifier).state = ArnaColors.red,
                color: ArnaColors.red,
              ),
              ArnaColorButton<Color>(
                value: ArnaColors.orange,
                groupValue: accentColor,
                onPressed: () => ref.read(accentProvider.notifier).state = ArnaColors.orange,
                color: ArnaColors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum Theme { system, dark, light }

final AutoDisposeStateProvider<Theme> themeProvider = StateProvider.autoDispose<Theme>(
  (AutoDisposeStateProviderRef<Theme> ref) => Theme.system,
);

final AutoDisposeStateProvider<Color> accentProvider = StateProvider.autoDispose<Color>(
  (AutoDisposeStateProviderRef<Color> ref) => ArnaColors.blue,
);
