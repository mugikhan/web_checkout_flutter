import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

import 'schema.graphql.dart';

class Fragment$OrderFields {
  Fragment$OrderFields({
    required this.id,
    required this.status,
    required this.store,
    required this.bags,
    required this.totalCents,
    required this.window,
    required this.card,
    required this.createdAt,
    required this.holdConfirmsAt,
    this.$__typename = 'Order',
  });

  factory Fragment$OrderFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$store = json['store'];
    final l$bags = json['bags'];
    final l$totalCents = json['totalCents'];
    final l$window = json['window'];
    final l$card = json['card'];
    final l$createdAt = json['createdAt'];
    final l$holdConfirmsAt = json['holdConfirmsAt'];
    final l$$__typename = json['__typename'];
    return Fragment$OrderFields(
      id: (l$id as String),
      status: fromJson$Enum$OrderStatus((l$status as String)),
      store: (l$store as String),
      bags: (l$bags as List<dynamic>)
          .map(
            (e) =>
                Fragment$OrderFields$bags.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      totalCents: (l$totalCents as int),
      window: Fragment$OrderFields$window.fromJson(
        (l$window as Map<String, dynamic>),
      ),
      card: Fragment$OrderFields$card.fromJson(
        (l$card as Map<String, dynamic>),
      ),
      createdAt: (l$createdAt as String),
      holdConfirmsAt: (l$holdConfirmsAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$OrderStatus status;

  final String store;

  final List<Fragment$OrderFields$bags> bags;

  final int totalCents;

  final Fragment$OrderFields$window window;

  final Fragment$OrderFields$card card;

  final String createdAt;

  final String holdConfirmsAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson$Enum$OrderStatus(l$status);
    final l$store = store;
    _resultData['store'] = l$store;
    final l$bags = bags;
    _resultData['bags'] = l$bags.map((e) => e.toJson()).toList();
    final l$totalCents = totalCents;
    _resultData['totalCents'] = l$totalCents;
    final l$window = window;
    _resultData['window'] = l$window.toJson();
    final l$card = card;
    _resultData['card'] = l$card.toJson();
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$holdConfirmsAt = holdConfirmsAt;
    _resultData['holdConfirmsAt'] = l$holdConfirmsAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$store = store;
    final l$bags = bags;
    final l$totalCents = totalCents;
    final l$window = window;
    final l$card = card;
    final l$createdAt = createdAt;
    final l$holdConfirmsAt = holdConfirmsAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$store,
      Object.hashAll(l$bags.map((v) => v)),
      l$totalCents,
      l$window,
      l$card,
      l$createdAt,
      l$holdConfirmsAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$OrderFields || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$store = store;
    final lOther$store = other.store;
    if (l$store != lOther$store) {
      return false;
    }
    final l$bags = bags;
    final lOther$bags = other.bags;
    if (l$bags.length != lOther$bags.length) {
      return false;
    }
    for (int i = 0; i < l$bags.length; i++) {
      final l$bags$entry = l$bags[i];
      final lOther$bags$entry = lOther$bags[i];
      if (l$bags$entry != lOther$bags$entry) {
        return false;
      }
    }
    final l$totalCents = totalCents;
    final lOther$totalCents = other.totalCents;
    if (l$totalCents != lOther$totalCents) {
      return false;
    }
    final l$window = window;
    final lOther$window = other.window;
    if (l$window != lOther$window) {
      return false;
    }
    final l$card = card;
    final lOther$card = other.card;
    if (l$card != lOther$card) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$holdConfirmsAt = holdConfirmsAt;
    final lOther$holdConfirmsAt = other.holdConfirmsAt;
    if (l$holdConfirmsAt != lOther$holdConfirmsAt) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$OrderFields on Fragment$OrderFields {
  CopyWith$Fragment$OrderFields<Fragment$OrderFields> get copyWith =>
      CopyWith$Fragment$OrderFields(this, (i) => i);
}

abstract class CopyWith$Fragment$OrderFields<TRes> {
  factory CopyWith$Fragment$OrderFields(
    Fragment$OrderFields instance,
    TRes Function(Fragment$OrderFields) then,
  ) = _CopyWithImpl$Fragment$OrderFields;

  factory CopyWith$Fragment$OrderFields.stub(TRes res) =
      _CopyWithStubImpl$Fragment$OrderFields;

  TRes call({
    String? id,
    Enum$OrderStatus? status,
    String? store,
    List<Fragment$OrderFields$bags>? bags,
    int? totalCents,
    Fragment$OrderFields$window? window,
    Fragment$OrderFields$card? card,
    String? createdAt,
    String? holdConfirmsAt,
    String? $__typename,
  });
  TRes bags(
    Iterable<Fragment$OrderFields$bags> Function(
      Iterable<CopyWith$Fragment$OrderFields$bags<Fragment$OrderFields$bags>>,
    )
    _fn,
  );
  CopyWith$Fragment$OrderFields$window<TRes> get window;
  CopyWith$Fragment$OrderFields$card<TRes> get card;
}

class _CopyWithImpl$Fragment$OrderFields<TRes>
    implements CopyWith$Fragment$OrderFields<TRes> {
  _CopyWithImpl$Fragment$OrderFields(this._instance, this._then);

  final Fragment$OrderFields _instance;

  final TRes Function(Fragment$OrderFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? store = _undefined,
    Object? bags = _undefined,
    Object? totalCents = _undefined,
    Object? window = _undefined,
    Object? card = _undefined,
    Object? createdAt = _undefined,
    Object? holdConfirmsAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$OrderFields(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum$OrderStatus),
      store: store == _undefined || store == null
          ? _instance.store
          : (store as String),
      bags: bags == _undefined || bags == null
          ? _instance.bags
          : (bags as List<Fragment$OrderFields$bags>),
      totalCents: totalCents == _undefined || totalCents == null
          ? _instance.totalCents
          : (totalCents as int),
      window: window == _undefined || window == null
          ? _instance.window
          : (window as Fragment$OrderFields$window),
      card: card == _undefined || card == null
          ? _instance.card
          : (card as Fragment$OrderFields$card),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      holdConfirmsAt: holdConfirmsAt == _undefined || holdConfirmsAt == null
          ? _instance.holdConfirmsAt
          : (holdConfirmsAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes bags(
    Iterable<Fragment$OrderFields$bags> Function(
      Iterable<CopyWith$Fragment$OrderFields$bags<Fragment$OrderFields$bags>>,
    )
    _fn,
  ) => call(
    bags: _fn(
      _instance.bags.map(
        (e) => CopyWith$Fragment$OrderFields$bags(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Fragment$OrderFields$window<TRes> get window {
    final local$window = _instance.window;
    return CopyWith$Fragment$OrderFields$window(
      local$window,
      (e) => call(window: e),
    );
  }

  CopyWith$Fragment$OrderFields$card<TRes> get card {
    final local$card = _instance.card;
    return CopyWith$Fragment$OrderFields$card(local$card, (e) => call(card: e));
  }
}

class _CopyWithStubImpl$Fragment$OrderFields<TRes>
    implements CopyWith$Fragment$OrderFields<TRes> {
  _CopyWithStubImpl$Fragment$OrderFields(this._res);

  TRes _res;

  call({
    String? id,
    Enum$OrderStatus? status,
    String? store,
    List<Fragment$OrderFields$bags>? bags,
    int? totalCents,
    Fragment$OrderFields$window? window,
    Fragment$OrderFields$card? card,
    String? createdAt,
    String? holdConfirmsAt,
    String? $__typename,
  }) => _res;

  bags(_fn) => _res;

  CopyWith$Fragment$OrderFields$window<TRes> get window =>
      CopyWith$Fragment$OrderFields$window.stub(_res);

  CopyWith$Fragment$OrderFields$card<TRes> get card =>
      CopyWith$Fragment$OrderFields$card.stub(_res);
}

const fragmentDefinitionOrderFields = FragmentDefinitionNode(
  name: NameNode(value: 'OrderFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Order'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'id'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'status'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'store'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'bags'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'priceCents'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'totalCents'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'window'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'startsAt'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'endsAt'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'card'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'brand'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'last4'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: '__typename'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
          ],
        ),
      ),
      FieldNode(
        name: NameNode(value: 'createdAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'holdConfirmsAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentOrderFields = DocumentNode(
  definitions: [fragmentDefinitionOrderFields],
);

extension ClientExtension$Fragment$OrderFields on graphql.GraphQLClient {
  void writeFragment$OrderFields({
    required Fragment$OrderFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'OrderFields',
        document: documentNodeFragmentOrderFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$OrderFields? readFragment$OrderFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'OrderFields',
          document: documentNodeFragmentOrderFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$OrderFields.fromJson(result);
  }
}

class Fragment$OrderFields$bags {
  Fragment$OrderFields$bags({
    required this.id,
    required this.name,
    required this.priceCents,
    this.$__typename = 'OrderBag',
  });

  factory Fragment$OrderFields$bags.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$priceCents = json['priceCents'];
    final l$$__typename = json['__typename'];
    return Fragment$OrderFields$bags(
      id: (l$id as String),
      name: (l$name as String),
      priceCents: (l$priceCents as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final int priceCents;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$priceCents = priceCents;
    _resultData['priceCents'] = l$priceCents;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$priceCents = priceCents;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$priceCents, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$OrderFields$bags ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$priceCents = priceCents;
    final lOther$priceCents = other.priceCents;
    if (l$priceCents != lOther$priceCents) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$OrderFields$bags
    on Fragment$OrderFields$bags {
  CopyWith$Fragment$OrderFields$bags<Fragment$OrderFields$bags> get copyWith =>
      CopyWith$Fragment$OrderFields$bags(this, (i) => i);
}

abstract class CopyWith$Fragment$OrderFields$bags<TRes> {
  factory CopyWith$Fragment$OrderFields$bags(
    Fragment$OrderFields$bags instance,
    TRes Function(Fragment$OrderFields$bags) then,
  ) = _CopyWithImpl$Fragment$OrderFields$bags;

  factory CopyWith$Fragment$OrderFields$bags.stub(TRes res) =
      _CopyWithStubImpl$Fragment$OrderFields$bags;

  TRes call({String? id, String? name, int? priceCents, String? $__typename});
}

class _CopyWithImpl$Fragment$OrderFields$bags<TRes>
    implements CopyWith$Fragment$OrderFields$bags<TRes> {
  _CopyWithImpl$Fragment$OrderFields$bags(this._instance, this._then);

  final Fragment$OrderFields$bags _instance;

  final TRes Function(Fragment$OrderFields$bags) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? priceCents = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$OrderFields$bags(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      priceCents: priceCents == _undefined || priceCents == null
          ? _instance.priceCents
          : (priceCents as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$OrderFields$bags<TRes>
    implements CopyWith$Fragment$OrderFields$bags<TRes> {
  _CopyWithStubImpl$Fragment$OrderFields$bags(this._res);

  TRes _res;

  call({String? id, String? name, int? priceCents, String? $__typename}) =>
      _res;
}

class Fragment$OrderFields$window {
  Fragment$OrderFields$window({
    required this.startsAt,
    required this.endsAt,
    this.$__typename = 'CollectionWindow',
  });

  factory Fragment$OrderFields$window.fromJson(Map<String, dynamic> json) {
    final l$startsAt = json['startsAt'];
    final l$endsAt = json['endsAt'];
    final l$$__typename = json['__typename'];
    return Fragment$OrderFields$window(
      startsAt: (l$startsAt as String),
      endsAt: (l$endsAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String startsAt;

  final String endsAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$startsAt = startsAt;
    _resultData['startsAt'] = l$startsAt;
    final l$endsAt = endsAt;
    _resultData['endsAt'] = l$endsAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$startsAt = startsAt;
    final l$endsAt = endsAt;
    final l$$__typename = $__typename;
    return Object.hashAll([l$startsAt, l$endsAt, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$OrderFields$window ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$startsAt = startsAt;
    final lOther$startsAt = other.startsAt;
    if (l$startsAt != lOther$startsAt) {
      return false;
    }
    final l$endsAt = endsAt;
    final lOther$endsAt = other.endsAt;
    if (l$endsAt != lOther$endsAt) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$OrderFields$window
    on Fragment$OrderFields$window {
  CopyWith$Fragment$OrderFields$window<Fragment$OrderFields$window>
  get copyWith => CopyWith$Fragment$OrderFields$window(this, (i) => i);
}

abstract class CopyWith$Fragment$OrderFields$window<TRes> {
  factory CopyWith$Fragment$OrderFields$window(
    Fragment$OrderFields$window instance,
    TRes Function(Fragment$OrderFields$window) then,
  ) = _CopyWithImpl$Fragment$OrderFields$window;

  factory CopyWith$Fragment$OrderFields$window.stub(TRes res) =
      _CopyWithStubImpl$Fragment$OrderFields$window;

  TRes call({String? startsAt, String? endsAt, String? $__typename});
}

class _CopyWithImpl$Fragment$OrderFields$window<TRes>
    implements CopyWith$Fragment$OrderFields$window<TRes> {
  _CopyWithImpl$Fragment$OrderFields$window(this._instance, this._then);

  final Fragment$OrderFields$window _instance;

  final TRes Function(Fragment$OrderFields$window) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? startsAt = _undefined,
    Object? endsAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$OrderFields$window(
      startsAt: startsAt == _undefined || startsAt == null
          ? _instance.startsAt
          : (startsAt as String),
      endsAt: endsAt == _undefined || endsAt == null
          ? _instance.endsAt
          : (endsAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$OrderFields$window<TRes>
    implements CopyWith$Fragment$OrderFields$window<TRes> {
  _CopyWithStubImpl$Fragment$OrderFields$window(this._res);

  TRes _res;

  call({String? startsAt, String? endsAt, String? $__typename}) => _res;
}

class Fragment$OrderFields$card {
  Fragment$OrderFields$card({
    required this.brand,
    required this.last4,
    this.$__typename = 'OrderCard',
  });

  factory Fragment$OrderFields$card.fromJson(Map<String, dynamic> json) {
    final l$brand = json['brand'];
    final l$last4 = json['last4'];
    final l$$__typename = json['__typename'];
    return Fragment$OrderFields$card(
      brand: (l$brand as String),
      last4: (l$last4 as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String brand;

  final String last4;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$brand = brand;
    _resultData['brand'] = l$brand;
    final l$last4 = last4;
    _resultData['last4'] = l$last4;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$brand = brand;
    final l$last4 = last4;
    final l$$__typename = $__typename;
    return Object.hashAll([l$brand, l$last4, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$OrderFields$card ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$brand = brand;
    final lOther$brand = other.brand;
    if (l$brand != lOther$brand) {
      return false;
    }
    final l$last4 = last4;
    final lOther$last4 = other.last4;
    if (l$last4 != lOther$last4) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$OrderFields$card
    on Fragment$OrderFields$card {
  CopyWith$Fragment$OrderFields$card<Fragment$OrderFields$card> get copyWith =>
      CopyWith$Fragment$OrderFields$card(this, (i) => i);
}

abstract class CopyWith$Fragment$OrderFields$card<TRes> {
  factory CopyWith$Fragment$OrderFields$card(
    Fragment$OrderFields$card instance,
    TRes Function(Fragment$OrderFields$card) then,
  ) = _CopyWithImpl$Fragment$OrderFields$card;

  factory CopyWith$Fragment$OrderFields$card.stub(TRes res) =
      _CopyWithStubImpl$Fragment$OrderFields$card;

  TRes call({String? brand, String? last4, String? $__typename});
}

class _CopyWithImpl$Fragment$OrderFields$card<TRes>
    implements CopyWith$Fragment$OrderFields$card<TRes> {
  _CopyWithImpl$Fragment$OrderFields$card(this._instance, this._then);

  final Fragment$OrderFields$card _instance;

  final TRes Function(Fragment$OrderFields$card) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? brand = _undefined,
    Object? last4 = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$OrderFields$card(
      brand: brand == _undefined || brand == null
          ? _instance.brand
          : (brand as String),
      last4: last4 == _undefined || last4 == null
          ? _instance.last4
          : (last4 as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$OrderFields$card<TRes>
    implements CopyWith$Fragment$OrderFields$card<TRes> {
  _CopyWithStubImpl$Fragment$OrderFields$card(this._res);

  TRes _res;

  call({String? brand, String? last4, String? $__typename}) => _res;
}

class Variables$Query$Order {
  factory Variables$Query$Order({required String id}) =>
      Variables$Query$Order._({r'id': id});

  Variables$Query$Order._(this._$data);

  factory Variables$Query$Order.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$Order._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Query$Order<Variables$Query$Order> get copyWith =>
      CopyWith$Variables$Query$Order(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$Order || runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Variables$Query$Order<TRes> {
  factory CopyWith$Variables$Query$Order(
    Variables$Query$Order instance,
    TRes Function(Variables$Query$Order) then,
  ) = _CopyWithImpl$Variables$Query$Order;

  factory CopyWith$Variables$Query$Order.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Order;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$Order<TRes>
    implements CopyWith$Variables$Query$Order<TRes> {
  _CopyWithImpl$Variables$Query$Order(this._instance, this._then);

  final Variables$Query$Order _instance;

  final TRes Function(Variables$Query$Order) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$Order._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$Order<TRes>
    implements CopyWith$Variables$Query$Order<TRes> {
  _CopyWithStubImpl$Variables$Query$Order(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$Order {
  Query$Order({required this.order, this.$__typename = 'Query'});

  factory Query$Order.fromJson(Map<String, dynamic> json) {
    final l$order = json['order'];
    final l$$__typename = json['__typename'];
    return Query$Order(
      order: Query$Order$order.fromJson((l$order as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$Order$order order;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$order = order;
    _resultData['order'] = l$order.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$order = order;
    final l$$__typename = $__typename;
    return Object.hashAll([l$order, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Order || runtimeType != other.runtimeType) {
      return false;
    }
    final l$order = order;
    final lOther$order = other.order;
    if (l$order != lOther$order) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Order on Query$Order {
  CopyWith$Query$Order<Query$Order> get copyWith =>
      CopyWith$Query$Order(this, (i) => i);
}

abstract class CopyWith$Query$Order<TRes> {
  factory CopyWith$Query$Order(
    Query$Order instance,
    TRes Function(Query$Order) then,
  ) = _CopyWithImpl$Query$Order;

  factory CopyWith$Query$Order.stub(TRes res) = _CopyWithStubImpl$Query$Order;

  TRes call({Query$Order$order? order, String? $__typename});
  CopyWith$Query$Order$order<TRes> get order;
}

class _CopyWithImpl$Query$Order<TRes> implements CopyWith$Query$Order<TRes> {
  _CopyWithImpl$Query$Order(this._instance, this._then);

  final Query$Order _instance;

  final TRes Function(Query$Order) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? order = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$Order(
          order: order == _undefined || order == null
              ? _instance.order
              : (order as Query$Order$order),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Query$Order$order<TRes> get order {
    final local$order = _instance.order;
    return CopyWith$Query$Order$order(local$order, (e) => call(order: e));
  }
}

class _CopyWithStubImpl$Query$Order<TRes>
    implements CopyWith$Query$Order<TRes> {
  _CopyWithStubImpl$Query$Order(this._res);

  TRes _res;

  call({Query$Order$order? order, String? $__typename}) => _res;

  CopyWith$Query$Order$order<TRes> get order =>
      CopyWith$Query$Order$order.stub(_res);
}

const documentNodeQueryOrder = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Order'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'order'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'Order'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'OrderFields'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'OrderNotFound'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'orderId'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionOrderFields,
  ],
);
Query$Order _parserFn$Query$Order(Map<String, dynamic> data) =>
    Query$Order.fromJson(data);
typedef OnQueryComplete$Query$Order = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$Order?,
);

class Options$Query$Order extends graphql.QueryOptions<Query$Order> {
  Options$Query$Order({
    String? operationName,
    required Variables$Query$Order variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Order? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$Order? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         pollInterval: pollInterval,
         context: context,
         onComplete: onComplete == null
             ? null
             : (data) => onComplete(
                 data,
                 data == null ? null : _parserFn$Query$Order(data),
               ),
         onError: onError,
         document: documentNodeQueryOrder,
         parserFn: _parserFn$Query$Order,
       );

  final OnQueryComplete$Query$Order? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$Order extends graphql.WatchQueryOptions<Query$Order> {
  WatchOptions$Query$Order({
    String? operationName,
    required Variables$Query$Order variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Order? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeQueryOrder,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$Order,
       );
}

class FetchMoreOptions$Query$Order extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Order({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$Order variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryOrder,
       );
}

extension ClientExtension$Query$Order on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Order>> query$Order(
    Options$Query$Order options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$Order> watchQuery$Order(
    WatchOptions$Query$Order options,
  ) => this.watchQuery(options);

  void writeQuery$Order({
    required Query$Order data,
    required Variables$Query$Order variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryOrder),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$Order? readQuery$Order({
    required Variables$Query$Order variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryOrder),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$Order.fromJson(result);
  }
}

class Query$Order$order {
  Query$Order$order({required this.$__typename});

  factory Query$Order$order.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "Order":
        return Query$Order$order$$Order.fromJson(json);

      case "OrderNotFound":
        return Query$Order$order$$OrderNotFound.fromJson(json);

      default:
        final l$$__typename = json['__typename'];
        return Query$Order$order($__typename: (l$$__typename as String));
    }
  }

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    return Object.hashAll([l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Order$order || runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Order$order on Query$Order$order {
  CopyWith$Query$Order$order<Query$Order$order> get copyWith =>
      CopyWith$Query$Order$order(this, (i) => i);

  _T when<_T>({
    required _T Function(Query$Order$order$$Order) order,
    required _T Function(Query$Order$order$$OrderNotFound) orderNotFound,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Order":
        return order(this as Query$Order$order$$Order);

      case "OrderNotFound":
        return orderNotFound(this as Query$Order$order$$OrderNotFound);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query$Order$order$$Order)? order,
    _T Function(Query$Order$order$$OrderNotFound)? orderNotFound,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Order":
        if (order != null) {
          return order(this as Query$Order$order$$Order);
        } else {
          return orElse();
        }

      case "OrderNotFound":
        if (orderNotFound != null) {
          return orderNotFound(this as Query$Order$order$$OrderNotFound);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Query$Order$order<TRes> {
  factory CopyWith$Query$Order$order(
    Query$Order$order instance,
    TRes Function(Query$Order$order) then,
  ) = _CopyWithImpl$Query$Order$order;

  factory CopyWith$Query$Order$order.stub(TRes res) =
      _CopyWithStubImpl$Query$Order$order;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Query$Order$order<TRes>
    implements CopyWith$Query$Order$order<TRes> {
  _CopyWithImpl$Query$Order$order(this._instance, this._then);

  final Query$Order$order _instance;

  final TRes Function(Query$Order$order) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Query$Order$order(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Order$order<TRes>
    implements CopyWith$Query$Order$order<TRes> {
  _CopyWithStubImpl$Query$Order$order(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Query$Order$order$$Order
    implements Fragment$OrderFields, Query$Order$order {
  Query$Order$order$$Order({
    required this.id,
    required this.status,
    required this.store,
    required this.bags,
    required this.totalCents,
    required this.window,
    required this.card,
    required this.createdAt,
    required this.holdConfirmsAt,
    this.$__typename = 'Order',
  });

  factory Query$Order$order$$Order.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$store = json['store'];
    final l$bags = json['bags'];
    final l$totalCents = json['totalCents'];
    final l$window = json['window'];
    final l$card = json['card'];
    final l$createdAt = json['createdAt'];
    final l$holdConfirmsAt = json['holdConfirmsAt'];
    final l$$__typename = json['__typename'];
    return Query$Order$order$$Order(
      id: (l$id as String),
      status: fromJson$Enum$OrderStatus((l$status as String)),
      store: (l$store as String),
      bags: (l$bags as List<dynamic>)
          .map(
            (e) => Query$Order$order$$Order$bags.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      totalCents: (l$totalCents as int),
      window: Query$Order$order$$Order$window.fromJson(
        (l$window as Map<String, dynamic>),
      ),
      card: Query$Order$order$$Order$card.fromJson(
        (l$card as Map<String, dynamic>),
      ),
      createdAt: (l$createdAt as String),
      holdConfirmsAt: (l$holdConfirmsAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$OrderStatus status;

  final String store;

  final List<Query$Order$order$$Order$bags> bags;

  final int totalCents;

  final Query$Order$order$$Order$window window;

  final Query$Order$order$$Order$card card;

  final String createdAt;

  final String holdConfirmsAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson$Enum$OrderStatus(l$status);
    final l$store = store;
    _resultData['store'] = l$store;
    final l$bags = bags;
    _resultData['bags'] = l$bags.map((e) => e.toJson()).toList();
    final l$totalCents = totalCents;
    _resultData['totalCents'] = l$totalCents;
    final l$window = window;
    _resultData['window'] = l$window.toJson();
    final l$card = card;
    _resultData['card'] = l$card.toJson();
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$holdConfirmsAt = holdConfirmsAt;
    _resultData['holdConfirmsAt'] = l$holdConfirmsAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$store = store;
    final l$bags = bags;
    final l$totalCents = totalCents;
    final l$window = window;
    final l$card = card;
    final l$createdAt = createdAt;
    final l$holdConfirmsAt = holdConfirmsAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$store,
      Object.hashAll(l$bags.map((v) => v)),
      l$totalCents,
      l$window,
      l$card,
      l$createdAt,
      l$holdConfirmsAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Order$order$$Order ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$store = store;
    final lOther$store = other.store;
    if (l$store != lOther$store) {
      return false;
    }
    final l$bags = bags;
    final lOther$bags = other.bags;
    if (l$bags.length != lOther$bags.length) {
      return false;
    }
    for (int i = 0; i < l$bags.length; i++) {
      final l$bags$entry = l$bags[i];
      final lOther$bags$entry = lOther$bags[i];
      if (l$bags$entry != lOther$bags$entry) {
        return false;
      }
    }
    final l$totalCents = totalCents;
    final lOther$totalCents = other.totalCents;
    if (l$totalCents != lOther$totalCents) {
      return false;
    }
    final l$window = window;
    final lOther$window = other.window;
    if (l$window != lOther$window) {
      return false;
    }
    final l$card = card;
    final lOther$card = other.card;
    if (l$card != lOther$card) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$holdConfirmsAt = holdConfirmsAt;
    final lOther$holdConfirmsAt = other.holdConfirmsAt;
    if (l$holdConfirmsAt != lOther$holdConfirmsAt) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Order$order$$Order
    on Query$Order$order$$Order {
  CopyWith$Query$Order$order$$Order<Query$Order$order$$Order> get copyWith =>
      CopyWith$Query$Order$order$$Order(this, (i) => i);
}

abstract class CopyWith$Query$Order$order$$Order<TRes> {
  factory CopyWith$Query$Order$order$$Order(
    Query$Order$order$$Order instance,
    TRes Function(Query$Order$order$$Order) then,
  ) = _CopyWithImpl$Query$Order$order$$Order;

  factory CopyWith$Query$Order$order$$Order.stub(TRes res) =
      _CopyWithStubImpl$Query$Order$order$$Order;

  TRes call({
    String? id,
    Enum$OrderStatus? status,
    String? store,
    List<Query$Order$order$$Order$bags>? bags,
    int? totalCents,
    Query$Order$order$$Order$window? window,
    Query$Order$order$$Order$card? card,
    String? createdAt,
    String? holdConfirmsAt,
    String? $__typename,
  });
  TRes bags(
    Iterable<Query$Order$order$$Order$bags> Function(
      Iterable<
        CopyWith$Query$Order$order$$Order$bags<Query$Order$order$$Order$bags>
      >,
    )
    _fn,
  );
  CopyWith$Query$Order$order$$Order$window<TRes> get window;
  CopyWith$Query$Order$order$$Order$card<TRes> get card;
}

class _CopyWithImpl$Query$Order$order$$Order<TRes>
    implements CopyWith$Query$Order$order$$Order<TRes> {
  _CopyWithImpl$Query$Order$order$$Order(this._instance, this._then);

  final Query$Order$order$$Order _instance;

  final TRes Function(Query$Order$order$$Order) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? store = _undefined,
    Object? bags = _undefined,
    Object? totalCents = _undefined,
    Object? window = _undefined,
    Object? card = _undefined,
    Object? createdAt = _undefined,
    Object? holdConfirmsAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Order$order$$Order(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum$OrderStatus),
      store: store == _undefined || store == null
          ? _instance.store
          : (store as String),
      bags: bags == _undefined || bags == null
          ? _instance.bags
          : (bags as List<Query$Order$order$$Order$bags>),
      totalCents: totalCents == _undefined || totalCents == null
          ? _instance.totalCents
          : (totalCents as int),
      window: window == _undefined || window == null
          ? _instance.window
          : (window as Query$Order$order$$Order$window),
      card: card == _undefined || card == null
          ? _instance.card
          : (card as Query$Order$order$$Order$card),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      holdConfirmsAt: holdConfirmsAt == _undefined || holdConfirmsAt == null
          ? _instance.holdConfirmsAt
          : (holdConfirmsAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes bags(
    Iterable<Query$Order$order$$Order$bags> Function(
      Iterable<
        CopyWith$Query$Order$order$$Order$bags<Query$Order$order$$Order$bags>
      >,
    )
    _fn,
  ) => call(
    bags: _fn(
      _instance.bags.map(
        (e) => CopyWith$Query$Order$order$$Order$bags(e, (i) => i),
      ),
    ).toList(),
  );

  CopyWith$Query$Order$order$$Order$window<TRes> get window {
    final local$window = _instance.window;
    return CopyWith$Query$Order$order$$Order$window(
      local$window,
      (e) => call(window: e),
    );
  }

  CopyWith$Query$Order$order$$Order$card<TRes> get card {
    final local$card = _instance.card;
    return CopyWith$Query$Order$order$$Order$card(
      local$card,
      (e) => call(card: e),
    );
  }
}

class _CopyWithStubImpl$Query$Order$order$$Order<TRes>
    implements CopyWith$Query$Order$order$$Order<TRes> {
  _CopyWithStubImpl$Query$Order$order$$Order(this._res);

  TRes _res;

  call({
    String? id,
    Enum$OrderStatus? status,
    String? store,
    List<Query$Order$order$$Order$bags>? bags,
    int? totalCents,
    Query$Order$order$$Order$window? window,
    Query$Order$order$$Order$card? card,
    String? createdAt,
    String? holdConfirmsAt,
    String? $__typename,
  }) => _res;

  bags(_fn) => _res;

  CopyWith$Query$Order$order$$Order$window<TRes> get window =>
      CopyWith$Query$Order$order$$Order$window.stub(_res);

  CopyWith$Query$Order$order$$Order$card<TRes> get card =>
      CopyWith$Query$Order$order$$Order$card.stub(_res);
}

class Query$Order$order$$Order$bags implements Fragment$OrderFields$bags {
  Query$Order$order$$Order$bags({
    required this.id,
    required this.name,
    required this.priceCents,
    this.$__typename = 'OrderBag',
  });

  factory Query$Order$order$$Order$bags.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$priceCents = json['priceCents'];
    final l$$__typename = json['__typename'];
    return Query$Order$order$$Order$bags(
      id: (l$id as String),
      name: (l$name as String),
      priceCents: (l$priceCents as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final int priceCents;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$priceCents = priceCents;
    _resultData['priceCents'] = l$priceCents;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$priceCents = priceCents;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$priceCents, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Order$order$$Order$bags ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$priceCents = priceCents;
    final lOther$priceCents = other.priceCents;
    if (l$priceCents != lOther$priceCents) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Order$order$$Order$bags
    on Query$Order$order$$Order$bags {
  CopyWith$Query$Order$order$$Order$bags<Query$Order$order$$Order$bags>
  get copyWith => CopyWith$Query$Order$order$$Order$bags(this, (i) => i);
}

abstract class CopyWith$Query$Order$order$$Order$bags<TRes> {
  factory CopyWith$Query$Order$order$$Order$bags(
    Query$Order$order$$Order$bags instance,
    TRes Function(Query$Order$order$$Order$bags) then,
  ) = _CopyWithImpl$Query$Order$order$$Order$bags;

  factory CopyWith$Query$Order$order$$Order$bags.stub(TRes res) =
      _CopyWithStubImpl$Query$Order$order$$Order$bags;

  TRes call({String? id, String? name, int? priceCents, String? $__typename});
}

class _CopyWithImpl$Query$Order$order$$Order$bags<TRes>
    implements CopyWith$Query$Order$order$$Order$bags<TRes> {
  _CopyWithImpl$Query$Order$order$$Order$bags(this._instance, this._then);

  final Query$Order$order$$Order$bags _instance;

  final TRes Function(Query$Order$order$$Order$bags) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? priceCents = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Order$order$$Order$bags(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      priceCents: priceCents == _undefined || priceCents == null
          ? _instance.priceCents
          : (priceCents as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Order$order$$Order$bags<TRes>
    implements CopyWith$Query$Order$order$$Order$bags<TRes> {
  _CopyWithStubImpl$Query$Order$order$$Order$bags(this._res);

  TRes _res;

  call({String? id, String? name, int? priceCents, String? $__typename}) =>
      _res;
}

class Query$Order$order$$Order$window implements Fragment$OrderFields$window {
  Query$Order$order$$Order$window({
    required this.startsAt,
    required this.endsAt,
    this.$__typename = 'CollectionWindow',
  });

  factory Query$Order$order$$Order$window.fromJson(Map<String, dynamic> json) {
    final l$startsAt = json['startsAt'];
    final l$endsAt = json['endsAt'];
    final l$$__typename = json['__typename'];
    return Query$Order$order$$Order$window(
      startsAt: (l$startsAt as String),
      endsAt: (l$endsAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String startsAt;

  final String endsAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$startsAt = startsAt;
    _resultData['startsAt'] = l$startsAt;
    final l$endsAt = endsAt;
    _resultData['endsAt'] = l$endsAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$startsAt = startsAt;
    final l$endsAt = endsAt;
    final l$$__typename = $__typename;
    return Object.hashAll([l$startsAt, l$endsAt, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Order$order$$Order$window ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$startsAt = startsAt;
    final lOther$startsAt = other.startsAt;
    if (l$startsAt != lOther$startsAt) {
      return false;
    }
    final l$endsAt = endsAt;
    final lOther$endsAt = other.endsAt;
    if (l$endsAt != lOther$endsAt) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Order$order$$Order$window
    on Query$Order$order$$Order$window {
  CopyWith$Query$Order$order$$Order$window<Query$Order$order$$Order$window>
  get copyWith => CopyWith$Query$Order$order$$Order$window(this, (i) => i);
}

abstract class CopyWith$Query$Order$order$$Order$window<TRes> {
  factory CopyWith$Query$Order$order$$Order$window(
    Query$Order$order$$Order$window instance,
    TRes Function(Query$Order$order$$Order$window) then,
  ) = _CopyWithImpl$Query$Order$order$$Order$window;

  factory CopyWith$Query$Order$order$$Order$window.stub(TRes res) =
      _CopyWithStubImpl$Query$Order$order$$Order$window;

  TRes call({String? startsAt, String? endsAt, String? $__typename});
}

class _CopyWithImpl$Query$Order$order$$Order$window<TRes>
    implements CopyWith$Query$Order$order$$Order$window<TRes> {
  _CopyWithImpl$Query$Order$order$$Order$window(this._instance, this._then);

  final Query$Order$order$$Order$window _instance;

  final TRes Function(Query$Order$order$$Order$window) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? startsAt = _undefined,
    Object? endsAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Order$order$$Order$window(
      startsAt: startsAt == _undefined || startsAt == null
          ? _instance.startsAt
          : (startsAt as String),
      endsAt: endsAt == _undefined || endsAt == null
          ? _instance.endsAt
          : (endsAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Order$order$$Order$window<TRes>
    implements CopyWith$Query$Order$order$$Order$window<TRes> {
  _CopyWithStubImpl$Query$Order$order$$Order$window(this._res);

  TRes _res;

  call({String? startsAt, String? endsAt, String? $__typename}) => _res;
}

class Query$Order$order$$Order$card implements Fragment$OrderFields$card {
  Query$Order$order$$Order$card({
    required this.brand,
    required this.last4,
    this.$__typename = 'OrderCard',
  });

  factory Query$Order$order$$Order$card.fromJson(Map<String, dynamic> json) {
    final l$brand = json['brand'];
    final l$last4 = json['last4'];
    final l$$__typename = json['__typename'];
    return Query$Order$order$$Order$card(
      brand: (l$brand as String),
      last4: (l$last4 as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String brand;

  final String last4;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$brand = brand;
    _resultData['brand'] = l$brand;
    final l$last4 = last4;
    _resultData['last4'] = l$last4;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$brand = brand;
    final l$last4 = last4;
    final l$$__typename = $__typename;
    return Object.hashAll([l$brand, l$last4, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Order$order$$Order$card ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$brand = brand;
    final lOther$brand = other.brand;
    if (l$brand != lOther$brand) {
      return false;
    }
    final l$last4 = last4;
    final lOther$last4 = other.last4;
    if (l$last4 != lOther$last4) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Order$order$$Order$card
    on Query$Order$order$$Order$card {
  CopyWith$Query$Order$order$$Order$card<Query$Order$order$$Order$card>
  get copyWith => CopyWith$Query$Order$order$$Order$card(this, (i) => i);
}

abstract class CopyWith$Query$Order$order$$Order$card<TRes> {
  factory CopyWith$Query$Order$order$$Order$card(
    Query$Order$order$$Order$card instance,
    TRes Function(Query$Order$order$$Order$card) then,
  ) = _CopyWithImpl$Query$Order$order$$Order$card;

  factory CopyWith$Query$Order$order$$Order$card.stub(TRes res) =
      _CopyWithStubImpl$Query$Order$order$$Order$card;

  TRes call({String? brand, String? last4, String? $__typename});
}

class _CopyWithImpl$Query$Order$order$$Order$card<TRes>
    implements CopyWith$Query$Order$order$$Order$card<TRes> {
  _CopyWithImpl$Query$Order$order$$Order$card(this._instance, this._then);

  final Query$Order$order$$Order$card _instance;

  final TRes Function(Query$Order$order$$Order$card) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? brand = _undefined,
    Object? last4 = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$Order$order$$Order$card(
      brand: brand == _undefined || brand == null
          ? _instance.brand
          : (brand as String),
      last4: last4 == _undefined || last4 == null
          ? _instance.last4
          : (last4 as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$Order$order$$Order$card<TRes>
    implements CopyWith$Query$Order$order$$Order$card<TRes> {
  _CopyWithStubImpl$Query$Order$order$$Order$card(this._res);

  TRes _res;

  call({String? brand, String? last4, String? $__typename}) => _res;
}

class Query$Order$order$$OrderNotFound implements Query$Order$order {
  Query$Order$order$$OrderNotFound({
    required this.orderId,
    this.$__typename = 'OrderNotFound',
  });

  factory Query$Order$order$$OrderNotFound.fromJson(Map<String, dynamic> json) {
    final l$orderId = json['orderId'];
    final l$$__typename = json['__typename'];
    return Query$Order$order$$OrderNotFound(
      orderId: (l$orderId as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String orderId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$orderId = orderId;
    _resultData['orderId'] = l$orderId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$orderId = orderId;
    final l$$__typename = $__typename;
    return Object.hashAll([l$orderId, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Order$order$$OrderNotFound ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$orderId = orderId;
    final lOther$orderId = other.orderId;
    if (l$orderId != lOther$orderId) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Order$order$$OrderNotFound
    on Query$Order$order$$OrderNotFound {
  CopyWith$Query$Order$order$$OrderNotFound<Query$Order$order$$OrderNotFound>
  get copyWith => CopyWith$Query$Order$order$$OrderNotFound(this, (i) => i);
}

abstract class CopyWith$Query$Order$order$$OrderNotFound<TRes> {
  factory CopyWith$Query$Order$order$$OrderNotFound(
    Query$Order$order$$OrderNotFound instance,
    TRes Function(Query$Order$order$$OrderNotFound) then,
  ) = _CopyWithImpl$Query$Order$order$$OrderNotFound;

  factory CopyWith$Query$Order$order$$OrderNotFound.stub(TRes res) =
      _CopyWithStubImpl$Query$Order$order$$OrderNotFound;

  TRes call({String? orderId, String? $__typename});
}

class _CopyWithImpl$Query$Order$order$$OrderNotFound<TRes>
    implements CopyWith$Query$Order$order$$OrderNotFound<TRes> {
  _CopyWithImpl$Query$Order$order$$OrderNotFound(this._instance, this._then);

  final Query$Order$order$$OrderNotFound _instance;

  final TRes Function(Query$Order$order$$OrderNotFound) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? orderId = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$Order$order$$OrderNotFound(
          orderId: orderId == _undefined || orderId == null
              ? _instance.orderId
              : (orderId as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$Order$order$$OrderNotFound<TRes>
    implements CopyWith$Query$Order$order$$OrderNotFound<TRes> {
  _CopyWithStubImpl$Query$Order$order$$OrderNotFound(this._res);

  TRes _res;

  call({String? orderId, String? $__typename}) => _res;
}

class Variables$Subscription$OrderStatusChanged {
  factory Variables$Subscription$OrderStatusChanged({
    required String orderId,
  }) => Variables$Subscription$OrderStatusChanged._({r'orderId': orderId});

  Variables$Subscription$OrderStatusChanged._(this._$data);

  factory Variables$Subscription$OrderStatusChanged.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$orderId = data['orderId'];
    result$data['orderId'] = (l$orderId as String);
    return Variables$Subscription$OrderStatusChanged._(result$data);
  }

  Map<String, dynamic> _$data;

  String get orderId => (_$data['orderId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$orderId = orderId;
    result$data['orderId'] = l$orderId;
    return result$data;
  }

  CopyWith$Variables$Subscription$OrderStatusChanged<
    Variables$Subscription$OrderStatusChanged
  >
  get copyWith =>
      CopyWith$Variables$Subscription$OrderStatusChanged(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Subscription$OrderStatusChanged ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$orderId = orderId;
    final lOther$orderId = other.orderId;
    if (l$orderId != lOther$orderId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$orderId = orderId;
    return Object.hashAll([l$orderId]);
  }
}

abstract class CopyWith$Variables$Subscription$OrderStatusChanged<TRes> {
  factory CopyWith$Variables$Subscription$OrderStatusChanged(
    Variables$Subscription$OrderStatusChanged instance,
    TRes Function(Variables$Subscription$OrderStatusChanged) then,
  ) = _CopyWithImpl$Variables$Subscription$OrderStatusChanged;

  factory CopyWith$Variables$Subscription$OrderStatusChanged.stub(TRes res) =
      _CopyWithStubImpl$Variables$Subscription$OrderStatusChanged;

  TRes call({String? orderId});
}

class _CopyWithImpl$Variables$Subscription$OrderStatusChanged<TRes>
    implements CopyWith$Variables$Subscription$OrderStatusChanged<TRes> {
  _CopyWithImpl$Variables$Subscription$OrderStatusChanged(
    this._instance,
    this._then,
  );

  final Variables$Subscription$OrderStatusChanged _instance;

  final TRes Function(Variables$Subscription$OrderStatusChanged) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? orderId = _undefined}) => _then(
    Variables$Subscription$OrderStatusChanged._({
      ..._instance._$data,
      if (orderId != _undefined && orderId != null)
        'orderId': (orderId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Subscription$OrderStatusChanged<TRes>
    implements CopyWith$Variables$Subscription$OrderStatusChanged<TRes> {
  _CopyWithStubImpl$Variables$Subscription$OrderStatusChanged(this._res);

  TRes _res;

  call({String? orderId}) => _res;
}

class Subscription$OrderStatusChanged {
  Subscription$OrderStatusChanged({
    required this.orderStatusChanged,
    this.$__typename = 'Subscription',
  });

  factory Subscription$OrderStatusChanged.fromJson(Map<String, dynamic> json) {
    final l$orderStatusChanged = json['orderStatusChanged'];
    final l$$__typename = json['__typename'];
    return Subscription$OrderStatusChanged(
      orderStatusChanged:
          Subscription$OrderStatusChanged$orderStatusChanged.fromJson(
            (l$orderStatusChanged as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Subscription$OrderStatusChanged$orderStatusChanged orderStatusChanged;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$orderStatusChanged = orderStatusChanged;
    _resultData['orderStatusChanged'] = l$orderStatusChanged.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$orderStatusChanged = orderStatusChanged;
    final l$$__typename = $__typename;
    return Object.hashAll([l$orderStatusChanged, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$OrderStatusChanged ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$orderStatusChanged = orderStatusChanged;
    final lOther$orderStatusChanged = other.orderStatusChanged;
    if (l$orderStatusChanged != lOther$orderStatusChanged) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$OrderStatusChanged
    on Subscription$OrderStatusChanged {
  CopyWith$Subscription$OrderStatusChanged<Subscription$OrderStatusChanged>
  get copyWith => CopyWith$Subscription$OrderStatusChanged(this, (i) => i);
}

abstract class CopyWith$Subscription$OrderStatusChanged<TRes> {
  factory CopyWith$Subscription$OrderStatusChanged(
    Subscription$OrderStatusChanged instance,
    TRes Function(Subscription$OrderStatusChanged) then,
  ) = _CopyWithImpl$Subscription$OrderStatusChanged;

  factory CopyWith$Subscription$OrderStatusChanged.stub(TRes res) =
      _CopyWithStubImpl$Subscription$OrderStatusChanged;

  TRes call({
    Subscription$OrderStatusChanged$orderStatusChanged? orderStatusChanged,
    String? $__typename,
  });
  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged<TRes>
  get orderStatusChanged;
}

class _CopyWithImpl$Subscription$OrderStatusChanged<TRes>
    implements CopyWith$Subscription$OrderStatusChanged<TRes> {
  _CopyWithImpl$Subscription$OrderStatusChanged(this._instance, this._then);

  final Subscription$OrderStatusChanged _instance;

  final TRes Function(Subscription$OrderStatusChanged) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? orderStatusChanged = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Subscription$OrderStatusChanged(
      orderStatusChanged:
          orderStatusChanged == _undefined || orderStatusChanged == null
          ? _instance.orderStatusChanged
          : (orderStatusChanged
                as Subscription$OrderStatusChanged$orderStatusChanged),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged<TRes>
  get orderStatusChanged {
    final local$orderStatusChanged = _instance.orderStatusChanged;
    return CopyWith$Subscription$OrderStatusChanged$orderStatusChanged(
      local$orderStatusChanged,
      (e) => call(orderStatusChanged: e),
    );
  }
}

class _CopyWithStubImpl$Subscription$OrderStatusChanged<TRes>
    implements CopyWith$Subscription$OrderStatusChanged<TRes> {
  _CopyWithStubImpl$Subscription$OrderStatusChanged(this._res);

  TRes _res;

  call({
    Subscription$OrderStatusChanged$orderStatusChanged? orderStatusChanged,
    String? $__typename,
  }) => _res;

  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged<TRes>
  get orderStatusChanged =>
      CopyWith$Subscription$OrderStatusChanged$orderStatusChanged.stub(_res);
}

const documentNodeSubscriptionOrderStatusChanged = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.subscription,
      name: NameNode(value: 'OrderStatusChanged'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'orderId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'orderStatusChanged'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'orderId'),
                value: VariableNode(name: NameNode(value: 'orderId')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: '__typename'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'Order'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'OrderFields'),
                        directives: [],
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'OrderNotFound'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'orderId'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: '__typename'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ],
      ),
    ),
    fragmentDefinitionOrderFields,
  ],
);
Subscription$OrderStatusChanged _parserFn$Subscription$OrderStatusChanged(
  Map<String, dynamic> data,
) => Subscription$OrderStatusChanged.fromJson(data);

class Options$Subscription$OrderStatusChanged
    extends graphql.SubscriptionOptions<Subscription$OrderStatusChanged> {
  Options$Subscription$OrderStatusChanged({
    String? operationName,
    required Variables$Subscription$OrderStatusChanged variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Subscription$OrderStatusChanged? typedOptimisticResult,
    graphql.Context? context,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeSubscriptionOrderStatusChanged,
         parserFn: _parserFn$Subscription$OrderStatusChanged,
       );
}

class WatchOptions$Subscription$OrderStatusChanged
    extends graphql.WatchQueryOptions<Subscription$OrderStatusChanged> {
  WatchOptions$Subscription$OrderStatusChanged({
    String? operationName,
    required Variables$Subscription$OrderStatusChanged variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Subscription$OrderStatusChanged? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeSubscriptionOrderStatusChanged,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Subscription$OrderStatusChanged,
       );
}

class FetchMoreOptions$Subscription$OrderStatusChanged
    extends graphql.FetchMoreOptions {
  FetchMoreOptions$Subscription$OrderStatusChanged({
    required graphql.UpdateQuery updateQuery,
    required Variables$Subscription$OrderStatusChanged variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeSubscriptionOrderStatusChanged,
       );
}

extension ClientExtension$Subscription$OrderStatusChanged
    on graphql.GraphQLClient {
  Stream<graphql.QueryResult<Subscription$OrderStatusChanged>>
  subscribe$OrderStatusChanged(
    Options$Subscription$OrderStatusChanged options,
  ) => this.subscribe(options);

  graphql.ObservableQuery<Subscription$OrderStatusChanged>
  watchSubscription$OrderStatusChanged(
    WatchOptions$Subscription$OrderStatusChanged options,
  ) => this.watchQuery(options);
}

class Subscription$OrderStatusChanged$orderStatusChanged {
  Subscription$OrderStatusChanged$orderStatusChanged({
    required this.$__typename,
  });

  factory Subscription$OrderStatusChanged$orderStatusChanged.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Order":
        return Subscription$OrderStatusChanged$orderStatusChanged$$Order.fromJson(
          json,
        );

      case "OrderNotFound":
        return Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Subscription$OrderStatusChanged$orderStatusChanged(
          $__typename: (l$$__typename as String),
        );
    }
  }

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$$__typename = $__typename;
    return Object.hashAll([l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$OrderStatusChanged$orderStatusChanged ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$OrderStatusChanged$orderStatusChanged
    on Subscription$OrderStatusChanged$orderStatusChanged {
  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged<
    Subscription$OrderStatusChanged$orderStatusChanged
  >
  get copyWith => CopyWith$Subscription$OrderStatusChanged$orderStatusChanged(
    this,
    (i) => i,
  );

  _T when<_T>({
    required _T Function(
      Subscription$OrderStatusChanged$orderStatusChanged$$Order,
    )
    order,
    required _T Function(
      Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound,
    )
    orderNotFound,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Order":
        return order(
          this as Subscription$OrderStatusChanged$orderStatusChanged$$Order,
        );

      case "OrderNotFound":
        return orderNotFound(
          this
              as Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Subscription$OrderStatusChanged$orderStatusChanged$$Order)?
    order,
    _T Function(
      Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound,
    )?
    orderNotFound,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Order":
        if (order != null) {
          return order(
            this as Subscription$OrderStatusChanged$orderStatusChanged$$Order,
          );
        } else {
          return orElse();
        }

      case "OrderNotFound":
        if (orderNotFound != null) {
          return orderNotFound(
            this
                as Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Subscription$OrderStatusChanged$orderStatusChanged<
  TRes
> {
  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged(
    Subscription$OrderStatusChanged$orderStatusChanged instance,
    TRes Function(Subscription$OrderStatusChanged$orderStatusChanged) then,
  ) = _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged;

  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged.stub(
    TRes res,
  ) = _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged<TRes>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged<TRes> {
  _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged(
    this._instance,
    this._then,
  );

  final Subscription$OrderStatusChanged$orderStatusChanged _instance;

  final TRes Function(Subscription$OrderStatusChanged$orderStatusChanged) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Subscription$OrderStatusChanged$orderStatusChanged(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged<TRes>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged<TRes> {
  _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged(
    this._res,
  );

  TRes _res;

  call({String? $__typename}) => _res;
}

class Subscription$OrderStatusChanged$orderStatusChanged$$Order
    implements
        Fragment$OrderFields,
        Subscription$OrderStatusChanged$orderStatusChanged {
  Subscription$OrderStatusChanged$orderStatusChanged$$Order({
    required this.id,
    required this.status,
    required this.store,
    required this.bags,
    required this.totalCents,
    required this.window,
    required this.card,
    required this.createdAt,
    required this.holdConfirmsAt,
    this.$__typename = 'Order',
  });

  factory Subscription$OrderStatusChanged$orderStatusChanged$$Order.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$store = json['store'];
    final l$bags = json['bags'];
    final l$totalCents = json['totalCents'];
    final l$window = json['window'];
    final l$card = json['card'];
    final l$createdAt = json['createdAt'];
    final l$holdConfirmsAt = json['holdConfirmsAt'];
    final l$$__typename = json['__typename'];
    return Subscription$OrderStatusChanged$orderStatusChanged$$Order(
      id: (l$id as String),
      status: fromJson$Enum$OrderStatus((l$status as String)),
      store: (l$store as String),
      bags: (l$bags as List<dynamic>)
          .map(
            (e) =>
                Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      totalCents: (l$totalCents as int),
      window:
          Subscription$OrderStatusChanged$orderStatusChanged$$Order$window.fromJson(
            (l$window as Map<String, dynamic>),
          ),
      card:
          Subscription$OrderStatusChanged$orderStatusChanged$$Order$card.fromJson(
            (l$card as Map<String, dynamic>),
          ),
      createdAt: (l$createdAt as String),
      holdConfirmsAt: (l$holdConfirmsAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$OrderStatus status;

  final String store;

  final List<Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags>
  bags;

  final int totalCents;

  final Subscription$OrderStatusChanged$orderStatusChanged$$Order$window window;

  final Subscription$OrderStatusChanged$orderStatusChanged$$Order$card card;

  final String createdAt;

  final String holdConfirmsAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson$Enum$OrderStatus(l$status);
    final l$store = store;
    _resultData['store'] = l$store;
    final l$bags = bags;
    _resultData['bags'] = l$bags.map((e) => e.toJson()).toList();
    final l$totalCents = totalCents;
    _resultData['totalCents'] = l$totalCents;
    final l$window = window;
    _resultData['window'] = l$window.toJson();
    final l$card = card;
    _resultData['card'] = l$card.toJson();
    final l$createdAt = createdAt;
    _resultData['createdAt'] = l$createdAt;
    final l$holdConfirmsAt = holdConfirmsAt;
    _resultData['holdConfirmsAt'] = l$holdConfirmsAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$store = store;
    final l$bags = bags;
    final l$totalCents = totalCents;
    final l$window = window;
    final l$card = card;
    final l$createdAt = createdAt;
    final l$holdConfirmsAt = holdConfirmsAt;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$store,
      Object.hashAll(l$bags.map((v) => v)),
      l$totalCents,
      l$window,
      l$card,
      l$createdAt,
      l$holdConfirmsAt,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$OrderStatusChanged$orderStatusChanged$$Order ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$status = status;
    final lOther$status = other.status;
    if (l$status != lOther$status) {
      return false;
    }
    final l$store = store;
    final lOther$store = other.store;
    if (l$store != lOther$store) {
      return false;
    }
    final l$bags = bags;
    final lOther$bags = other.bags;
    if (l$bags.length != lOther$bags.length) {
      return false;
    }
    for (int i = 0; i < l$bags.length; i++) {
      final l$bags$entry = l$bags[i];
      final lOther$bags$entry = lOther$bags[i];
      if (l$bags$entry != lOther$bags$entry) {
        return false;
      }
    }
    final l$totalCents = totalCents;
    final lOther$totalCents = other.totalCents;
    if (l$totalCents != lOther$totalCents) {
      return false;
    }
    final l$window = window;
    final lOther$window = other.window;
    if (l$window != lOther$window) {
      return false;
    }
    final l$card = card;
    final lOther$card = other.card;
    if (l$card != lOther$card) {
      return false;
    }
    final l$createdAt = createdAt;
    final lOther$createdAt = other.createdAt;
    if (l$createdAt != lOther$createdAt) {
      return false;
    }
    final l$holdConfirmsAt = holdConfirmsAt;
    final lOther$holdConfirmsAt = other.holdConfirmsAt;
    if (l$holdConfirmsAt != lOther$holdConfirmsAt) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$OrderStatusChanged$orderStatusChanged$$Order
    on Subscription$OrderStatusChanged$orderStatusChanged$$Order {
  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order<
    Subscription$OrderStatusChanged$orderStatusChanged$$Order
  >
  get copyWith =>
      CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order<
  TRes
> {
  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order instance,
    TRes Function(Subscription$OrderStatusChanged$orderStatusChanged$$Order)
    then,
  ) = _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order;

  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order.stub(
    TRes res,
  ) = _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order;

  TRes call({
    String? id,
    Enum$OrderStatus? status,
    String? store,
    List<Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags>? bags,
    int? totalCents,
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$window? window,
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$card? card,
    String? createdAt,
    String? holdConfirmsAt,
    String? $__typename,
  });
  TRes bags(
    Iterable<Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags>
    Function(
      Iterable<
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags<
          Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags
        >
      >,
    )
    _fn,
  );
  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window<
    TRes
  >
  get window;
  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card<TRes>
  get card;
}

class _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order<
  TRes
>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order<
          TRes
        > {
  _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order(
    this._instance,
    this._then,
  );

  final Subscription$OrderStatusChanged$orderStatusChanged$$Order _instance;

  final TRes Function(Subscription$OrderStatusChanged$orderStatusChanged$$Order)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? store = _undefined,
    Object? bags = _undefined,
    Object? totalCents = _undefined,
    Object? window = _undefined,
    Object? card = _undefined,
    Object? createdAt = _undefined,
    Object? holdConfirmsAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum$OrderStatus),
      store: store == _undefined || store == null
          ? _instance.store
          : (store as String),
      bags: bags == _undefined || bags == null
          ? _instance.bags
          : (bags
                as List<
                  Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags
                >),
      totalCents: totalCents == _undefined || totalCents == null
          ? _instance.totalCents
          : (totalCents as int),
      window: window == _undefined || window == null
          ? _instance.window
          : (window
                as Subscription$OrderStatusChanged$orderStatusChanged$$Order$window),
      card: card == _undefined || card == null
          ? _instance.card
          : (card
                as Subscription$OrderStatusChanged$orderStatusChanged$$Order$card),
      createdAt: createdAt == _undefined || createdAt == null
          ? _instance.createdAt
          : (createdAt as String),
      holdConfirmsAt: holdConfirmsAt == _undefined || holdConfirmsAt == null
          ? _instance.holdConfirmsAt
          : (holdConfirmsAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes bags(
    Iterable<Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags>
    Function(
      Iterable<
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags<
          Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags
        >
      >,
    )
    _fn,
  ) => call(
    bags: _fn(
      _instance.bags.map(
        (e) =>
            CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );

  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window<
    TRes
  >
  get window {
    final local$window = _instance.window;
    return CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window(
      local$window,
      (e) => call(window: e),
    );
  }

  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card<TRes>
  get card {
    final local$card = _instance.card;
    return CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card(
      local$card,
      (e) => call(card: e),
    );
  }
}

class _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order<
  TRes
>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order<
          TRes
        > {
  _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Enum$OrderStatus? status,
    String? store,
    List<Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags>? bags,
    int? totalCents,
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$window? window,
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$card? card,
    String? createdAt,
    String? holdConfirmsAt,
    String? $__typename,
  }) => _res;

  bags(_fn) => _res;

  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window<
    TRes
  >
  get window =>
      CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window.stub(
        _res,
      );

  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card<TRes>
  get card =>
      CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card.stub(
        _res,
      );
}

class Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags
    implements Fragment$OrderFields$bags {
  Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags({
    required this.id,
    required this.name,
    required this.priceCents,
    this.$__typename = 'OrderBag',
  });

  factory Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$priceCents = json['priceCents'];
    final l$$__typename = json['__typename'];
    return Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags(
      id: (l$id as String),
      name: (l$name as String),
      priceCents: (l$priceCents as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final int priceCents;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$priceCents = priceCents;
    _resultData['priceCents'] = l$priceCents;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$priceCents = priceCents;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$priceCents, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$priceCents = priceCents;
    final lOther$priceCents = other.priceCents;
    if (l$priceCents != lOther$priceCents) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags
    on Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags {
  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags<
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags
  >
  get copyWith =>
      CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags<
  TRes
> {
  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags instance,
    TRes Function(
      Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags,
    )
    then,
  ) = _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags;

  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags.stub(
    TRes res,
  ) = _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags;

  TRes call({String? id, String? name, int? priceCents, String? $__typename});
}

class _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags<
  TRes
>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags<
          TRes
        > {
  _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags(
    this._instance,
    this._then,
  );

  final Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags
  _instance;

  final TRes Function(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? priceCents = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      priceCents: priceCents == _undefined || priceCents == null
          ? _instance.priceCents
          : (priceCents as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags<
  TRes
>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags<
          TRes
        > {
  _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$bags(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, int? priceCents, String? $__typename}) =>
      _res;
}

class Subscription$OrderStatusChanged$orderStatusChanged$$Order$window
    implements Fragment$OrderFields$window {
  Subscription$OrderStatusChanged$orderStatusChanged$$Order$window({
    required this.startsAt,
    required this.endsAt,
    this.$__typename = 'CollectionWindow',
  });

  factory Subscription$OrderStatusChanged$orderStatusChanged$$Order$window.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$startsAt = json['startsAt'];
    final l$endsAt = json['endsAt'];
    final l$$__typename = json['__typename'];
    return Subscription$OrderStatusChanged$orderStatusChanged$$Order$window(
      startsAt: (l$startsAt as String),
      endsAt: (l$endsAt as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String startsAt;

  final String endsAt;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$startsAt = startsAt;
    _resultData['startsAt'] = l$startsAt;
    final l$endsAt = endsAt;
    _resultData['endsAt'] = l$endsAt;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$startsAt = startsAt;
    final l$endsAt = endsAt;
    final l$$__typename = $__typename;
    return Object.hashAll([l$startsAt, l$endsAt, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Subscription$OrderStatusChanged$orderStatusChanged$$Order$window ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$startsAt = startsAt;
    final lOther$startsAt = other.startsAt;
    if (l$startsAt != lOther$startsAt) {
      return false;
    }
    final l$endsAt = endsAt;
    final lOther$endsAt = other.endsAt;
    if (l$endsAt != lOther$endsAt) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window
    on Subscription$OrderStatusChanged$orderStatusChanged$$Order$window {
  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window<
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$window
  >
  get copyWith =>
      CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window<
  TRes
> {
  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$window instance,
    TRes Function(
      Subscription$OrderStatusChanged$orderStatusChanged$$Order$window,
    )
    then,
  ) = _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window;

  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window.stub(
    TRes res,
  ) = _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window;

  TRes call({String? startsAt, String? endsAt, String? $__typename});
}

class _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window<
  TRes
>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window<
          TRes
        > {
  _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window(
    this._instance,
    this._then,
  );

  final Subscription$OrderStatusChanged$orderStatusChanged$$Order$window
  _instance;

  final TRes Function(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$window,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? startsAt = _undefined,
    Object? endsAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$window(
      startsAt: startsAt == _undefined || startsAt == null
          ? _instance.startsAt
          : (startsAt as String),
      endsAt: endsAt == _undefined || endsAt == null
          ? _instance.endsAt
          : (endsAt as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window<
  TRes
>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window<
          TRes
        > {
  _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$window(
    this._res,
  );

  TRes _res;

  call({String? startsAt, String? endsAt, String? $__typename}) => _res;
}

class Subscription$OrderStatusChanged$orderStatusChanged$$Order$card
    implements Fragment$OrderFields$card {
  Subscription$OrderStatusChanged$orderStatusChanged$$Order$card({
    required this.brand,
    required this.last4,
    this.$__typename = 'OrderCard',
  });

  factory Subscription$OrderStatusChanged$orderStatusChanged$$Order$card.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$brand = json['brand'];
    final l$last4 = json['last4'];
    final l$$__typename = json['__typename'];
    return Subscription$OrderStatusChanged$orderStatusChanged$$Order$card(
      brand: (l$brand as String),
      last4: (l$last4 as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String brand;

  final String last4;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$brand = brand;
    _resultData['brand'] = l$brand;
    final l$last4 = last4;
    _resultData['last4'] = l$last4;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$brand = brand;
    final l$last4 = last4;
    final l$$__typename = $__typename;
    return Object.hashAll([l$brand, l$last4, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Subscription$OrderStatusChanged$orderStatusChanged$$Order$card ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$brand = brand;
    final lOther$brand = other.brand;
    if (l$brand != lOther$brand) {
      return false;
    }
    final l$last4 = last4;
    final lOther$last4 = other.last4;
    if (l$last4 != lOther$last4) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card
    on Subscription$OrderStatusChanged$orderStatusChanged$$Order$card {
  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card<
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$card
  >
  get copyWith =>
      CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card<
  TRes
> {
  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$card instance,
    TRes Function(
      Subscription$OrderStatusChanged$orderStatusChanged$$Order$card,
    )
    then,
  ) = _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card;

  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card.stub(
    TRes res,
  ) = _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card;

  TRes call({String? brand, String? last4, String? $__typename});
}

class _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card<
  TRes
>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card<
          TRes
        > {
  _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card(
    this._instance,
    this._then,
  );

  final Subscription$OrderStatusChanged$orderStatusChanged$$Order$card
  _instance;

  final TRes Function(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$card,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? brand = _undefined,
    Object? last4 = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Subscription$OrderStatusChanged$orderStatusChanged$$Order$card(
      brand: brand == _undefined || brand == null
          ? _instance.brand
          : (brand as String),
      last4: last4 == _undefined || last4 == null
          ? _instance.last4
          : (last4 as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card<
  TRes
>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card<
          TRes
        > {
  _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$Order$card(
    this._res,
  );

  TRes _res;

  call({String? brand, String? last4, String? $__typename}) => _res;
}

class Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound
    implements Subscription$OrderStatusChanged$orderStatusChanged {
  Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound({
    required this.orderId,
    this.$__typename = 'OrderNotFound',
  });

  factory Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$orderId = json['orderId'];
    final l$$__typename = json['__typename'];
    return Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound(
      orderId: (l$orderId as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String orderId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$orderId = orderId;
    _resultData['orderId'] = l$orderId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$orderId = orderId;
    final l$$__typename = $__typename;
    return Object.hashAll([l$orderId, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$orderId = orderId;
    final lOther$orderId = other.orderId;
    if (l$orderId != lOther$orderId) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound
    on Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound {
  CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound<
    Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound
  >
  get copyWith =>
      CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound<
  TRes
> {
  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound(
    Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound instance,
    TRes Function(
      Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound,
    )
    then,
  ) = _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound;

  factory CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound.stub(
    TRes res,
  ) = _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound;

  TRes call({String? orderId, String? $__typename});
}

class _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound<
  TRes
>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound<
          TRes
        > {
  _CopyWithImpl$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound(
    this._instance,
    this._then,
  );

  final Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound
  _instance;

  final TRes Function(
    Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? orderId = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound(
          orderId: orderId == _undefined || orderId == null
              ? _instance.orderId
              : (orderId as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound<
  TRes
>
    implements
        CopyWith$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound<
          TRes
        > {
  _CopyWithStubImpl$Subscription$OrderStatusChanged$orderStatusChanged$$OrderNotFound(
    this._res,
  );

  TRes _res;

  call({String? orderId, String? $__typename}) => _res;
}
