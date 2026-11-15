import 'package:api/domain/domain.dart';
import 'package:catalog/catalog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

/// UrlHost stands in for the router: it feeds each requested selection back as bagIds.
class UrlHost extends StatefulWidget {
  const UrlHost({
    super.key,
    required this.initialIds,
    required this.changes,
    this.continues,
  });

  final List<String> initialIds;
  final List<List<String>> changes;
  final List<List<String>>? continues;

  @override
  State<UrlHost> createState() => _UrlHostState();
}

class _UrlHostState extends State<UrlHost> {
  late List<String> _ids = widget.initialIds;

  @override
  Widget build(BuildContext context) => CatalogPage(
    bagIds: _ids,
    onSelectionChanged: (ids) {
      widget.changes.add(ids);
      setState(() => _ids = ids);
    },
    onContinue: (ids) => widget.continues?.add(ids),
  );
}

/// pumpCatalog pumps the catalog page over [repository]; pass `settle: false` while it loads.
Future<List<List<String>>> pumpCatalog(
  WidgetTester tester,
  CatalogRepository repository, {
  List<String> bagIds = const [],
  Size size = const Size(400, 900),
  bool settle = true,
  List<List<String>>? continues,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final changes = <List<String>>[];
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(textTheme: ThemeData().textTheme),
      home: Scaffold(
        body: BlocProvider(
          create: (_) =>
              CatalogBloc(catalogRepository: repository)
                ..add(const CatalogLoadRequested()),
          child: UrlHost(
            initialIds: bagIds,
            changes: changes,
            continues: continues,
          ),
        ),
      ),
    ),
  );
  if (settle) await tester.pumpAndSettle();
  return changes;
}
