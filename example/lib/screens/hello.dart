import 'package:arna/arna.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<int> counterProvider = StateProvider<int>((StateProviderRef<int> ref) => 0);

class HelloWorld extends ConsumerWidget {
  const HelloWorld({super.key});

  void add(WidgetRef ref) => ref.read(counterProvider.state).state++;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('You have pushed the button this many times:', style: ArnaTheme.of(context).textTheme.body),
          const SizedBox(height: Styles.padding),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, _) => Text(
              '${ref.watch(counterProvider.state).state}',
              style: ArnaTheme.of(context).textTheme.title,
            ),
          ),
        ],
      ),
    );
  }
}
