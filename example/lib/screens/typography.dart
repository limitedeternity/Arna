import 'package:arna/arna.dart';

class Typography extends StatelessWidget {
  const Typography({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Styles.normal,
        child: SizedBox(
          width: deviceWidth(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: Styles.normal,
                child: Text('Lorem ipsum dolor', style: ArnaTheme.of(context).textTheme.titleLarge),
              ),
              Padding(
                padding: Styles.normal,
                child: Text('Lorem ipsum dolor', style: ArnaTheme.of(context).textTheme.title),
              ),
              Padding(
                padding: Styles.normal,
                child: Text('Lorem ipsum dolor', style: ArnaTheme.of(context).textTheme.body),
              ),
              Padding(
                padding: Styles.normal,
                child: Text('Lorem ipsum dolor', style: ArnaTheme.of(context).textTheme.button),
              ),
              Padding(
                padding: Styles.normal,
                child: Text('Lorem ipsum dolor', style: ArnaTheme.of(context).textTheme.subtitle),
              ),
              Padding(
                padding: Styles.normal,
                child: Text('Lorem ipsum dolor', style: ArnaTheme.of(context).textTheme.caption),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
