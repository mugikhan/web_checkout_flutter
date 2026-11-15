import 'package:api/domain/domain.dart';
import 'package:checkout/checkout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui/ui.dart';

import 'mocks.dart';

/// CheckoutCalls records every callback the checkout page makes.
class CheckoutCalls {
  /// drafts holds each requested URL draft as "bag,ids|slot".
  final drafts = <String>[];
  final closes = <String>[];
  final startAgains = <String>[];
  final completed = <String>[];
}

/// UrlHost stands in for the router: it feeds each requested draft back to the page.
class UrlHost extends StatefulWidget {
  const UrlHost({
    super.key,
    required this.bagIds,
    required this.slot,
    required this.calls,
  });

  final List<String> bagIds;
  final String? slot;
  final CheckoutCalls calls;

  @override
  State<UrlHost> createState() => _UrlHostState();
}

class _UrlHostState extends State<UrlHost> {
  late List<String> _bagIds = widget.bagIds;
  late String? _slot = widget.slot;

  @override
  Widget build(BuildContext context) => CheckoutPage(
    bagIds: _bagIds,
    slot: _slot,
    onDraftChanged: (bagIds, slot) {
      widget.calls.drafts.add('${bagIds.join(',')}|$slot');
      setState(() {
        _bagIds = bagIds;
        _slot = slot;
      });
    },
    onClose: (bagIds) => widget.calls.closes.add(bagIds.join(',')),
    onStartAgain: (bagIds, slot) =>
        widget.calls.startAgains.add('${bagIds.join(',')}|$slot'),
    onCompleted: widget.calls.completed.add,
  );
}

/// pumpCheckout pumps the checkout page for session `cs_1`; pass `settle: false` while it loads.
Future<CheckoutCalls> pumpCheckout(
  WidgetTester tester, {
  required CheckoutRepository checkout,
  required CatalogRepository catalog,
  List<String> bagIds = const ['bag_cafe'],
  String? slot,
  Size size = const Size(400, 1600),
  bool settle = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final calls = CheckoutCalls();
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(textTheme: ThemeData().textTheme),
      home: BlocProvider(
        create: (_) => CheckoutBloc(
          checkoutRepository: checkout,
          catalogRepository: catalog,
          clock: () => now,
        )..add(const CheckoutLoadRequested('cs_1')),
        child: UrlHost(bagIds: bagIds, slot: slot, calls: calls),
      ),
    ),
  );
  if (settle) await tester.pumpAndSettle();
  return calls;
}
