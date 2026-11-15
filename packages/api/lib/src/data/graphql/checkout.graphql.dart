import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

import 'schema.graphql.dart';

class Fragment$SavedCardFields {
  Fragment$SavedCardFields({
    required this.id,
    required this.brand,
    required this.last4,
    this.$__typename = 'SavedCard',
  });

  factory Fragment$SavedCardFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$brand = json['brand'];
    final l$last4 = json['last4'];
    final l$$__typename = json['__typename'];
    return Fragment$SavedCardFields(
      id: (l$id as String),
      brand: (l$brand as String),
      last4: (l$last4 as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String brand;

  final String last4;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
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
    final l$id = id;
    final l$brand = brand;
    final l$last4 = last4;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$brand, l$last4, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$SavedCardFields ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Fragment$SavedCardFields
    on Fragment$SavedCardFields {
  CopyWith$Fragment$SavedCardFields<Fragment$SavedCardFields> get copyWith =>
      CopyWith$Fragment$SavedCardFields(this, (i) => i);
}

abstract class CopyWith$Fragment$SavedCardFields<TRes> {
  factory CopyWith$Fragment$SavedCardFields(
    Fragment$SavedCardFields instance,
    TRes Function(Fragment$SavedCardFields) then,
  ) = _CopyWithImpl$Fragment$SavedCardFields;

  factory CopyWith$Fragment$SavedCardFields.stub(TRes res) =
      _CopyWithStubImpl$Fragment$SavedCardFields;

  TRes call({String? id, String? brand, String? last4, String? $__typename});
}

class _CopyWithImpl$Fragment$SavedCardFields<TRes>
    implements CopyWith$Fragment$SavedCardFields<TRes> {
  _CopyWithImpl$Fragment$SavedCardFields(this._instance, this._then);

  final Fragment$SavedCardFields _instance;

  final TRes Function(Fragment$SavedCardFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? brand = _undefined,
    Object? last4 = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$SavedCardFields(
      id: id == _undefined || id == null ? _instance.id : (id as String),
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

class _CopyWithStubImpl$Fragment$SavedCardFields<TRes>
    implements CopyWith$Fragment$SavedCardFields<TRes> {
  _CopyWithStubImpl$Fragment$SavedCardFields(this._res);

  TRes _res;

  call({String? id, String? brand, String? last4, String? $__typename}) => _res;
}

const fragmentDefinitionSavedCardFields = FragmentDefinitionNode(
  name: NameNode(value: 'SavedCardFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'SavedCard'), isNonNull: false),
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
);
const documentNodeFragmentSavedCardFields = DocumentNode(
  definitions: [fragmentDefinitionSavedCardFields],
);

extension ClientExtension$Fragment$SavedCardFields on graphql.GraphQLClient {
  void writeFragment$SavedCardFields({
    required Fragment$SavedCardFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'SavedCardFields',
        document: documentNodeFragmentSavedCardFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$SavedCardFields? readFragment$SavedCardFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'SavedCardFields',
          document: documentNodeFragmentSavedCardFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$SavedCardFields.fromJson(result);
  }
}

class Fragment$CheckoutSessionFields {
  Fragment$CheckoutSessionFields({
    required this.id,
    required this.status,
    required this.expiresAt,
    this.orderId,
    this.paymentMethod,
    required this.collectionWindows,
    this.$__typename = 'CheckoutSession',
  });

  factory Fragment$CheckoutSessionFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$expiresAt = json['expiresAt'];
    final l$orderId = json['orderId'];
    final l$paymentMethod = json['paymentMethod'];
    final l$collectionWindows = json['collectionWindows'];
    final l$$__typename = json['__typename'];
    return Fragment$CheckoutSessionFields(
      id: (l$id as String),
      status: fromJson$Enum$CheckoutSessionStatus((l$status as String)),
      expiresAt: (l$expiresAt as String),
      orderId: (l$orderId as String?),
      paymentMethod: l$paymentMethod == null
          ? null
          : Fragment$SavedCardFields.fromJson(
              (l$paymentMethod as Map<String, dynamic>),
            ),
      collectionWindows: (l$collectionWindows as List<dynamic>)
          .map(
            (e) => Fragment$CheckoutSessionFields$collectionWindows.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$CheckoutSessionStatus status;

  final String expiresAt;

  final String? orderId;

  final Fragment$SavedCardFields? paymentMethod;

  final List<Fragment$CheckoutSessionFields$collectionWindows>
  collectionWindows;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson$Enum$CheckoutSessionStatus(l$status);
    final l$expiresAt = expiresAt;
    _resultData['expiresAt'] = l$expiresAt;
    final l$orderId = orderId;
    _resultData['orderId'] = l$orderId;
    final l$paymentMethod = paymentMethod;
    _resultData['paymentMethod'] = l$paymentMethod?.toJson();
    final l$collectionWindows = collectionWindows;
    _resultData['collectionWindows'] = l$collectionWindows
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$expiresAt = expiresAt;
    final l$orderId = orderId;
    final l$paymentMethod = paymentMethod;
    final l$collectionWindows = collectionWindows;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$expiresAt,
      l$orderId,
      l$paymentMethod,
      Object.hashAll(l$collectionWindows.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$CheckoutSessionFields ||
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
    final l$expiresAt = expiresAt;
    final lOther$expiresAt = other.expiresAt;
    if (l$expiresAt != lOther$expiresAt) {
      return false;
    }
    final l$orderId = orderId;
    final lOther$orderId = other.orderId;
    if (l$orderId != lOther$orderId) {
      return false;
    }
    final l$paymentMethod = paymentMethod;
    final lOther$paymentMethod = other.paymentMethod;
    if (l$paymentMethod != lOther$paymentMethod) {
      return false;
    }
    final l$collectionWindows = collectionWindows;
    final lOther$collectionWindows = other.collectionWindows;
    if (l$collectionWindows.length != lOther$collectionWindows.length) {
      return false;
    }
    for (int i = 0; i < l$collectionWindows.length; i++) {
      final l$collectionWindows$entry = l$collectionWindows[i];
      final lOther$collectionWindows$entry = lOther$collectionWindows[i];
      if (l$collectionWindows$entry != lOther$collectionWindows$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$CheckoutSessionFields
    on Fragment$CheckoutSessionFields {
  CopyWith$Fragment$CheckoutSessionFields<Fragment$CheckoutSessionFields>
  get copyWith => CopyWith$Fragment$CheckoutSessionFields(this, (i) => i);
}

abstract class CopyWith$Fragment$CheckoutSessionFields<TRes> {
  factory CopyWith$Fragment$CheckoutSessionFields(
    Fragment$CheckoutSessionFields instance,
    TRes Function(Fragment$CheckoutSessionFields) then,
  ) = _CopyWithImpl$Fragment$CheckoutSessionFields;

  factory CopyWith$Fragment$CheckoutSessionFields.stub(TRes res) =
      _CopyWithStubImpl$Fragment$CheckoutSessionFields;

  TRes call({
    String? id,
    Enum$CheckoutSessionStatus? status,
    String? expiresAt,
    String? orderId,
    Fragment$SavedCardFields? paymentMethod,
    List<Fragment$CheckoutSessionFields$collectionWindows>? collectionWindows,
    String? $__typename,
  });
  CopyWith$Fragment$SavedCardFields<TRes> get paymentMethod;
  TRes collectionWindows(
    Iterable<Fragment$CheckoutSessionFields$collectionWindows> Function(
      Iterable<
        CopyWith$Fragment$CheckoutSessionFields$collectionWindows<
          Fragment$CheckoutSessionFields$collectionWindows
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$CheckoutSessionFields<TRes>
    implements CopyWith$Fragment$CheckoutSessionFields<TRes> {
  _CopyWithImpl$Fragment$CheckoutSessionFields(this._instance, this._then);

  final Fragment$CheckoutSessionFields _instance;

  final TRes Function(Fragment$CheckoutSessionFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? expiresAt = _undefined,
    Object? orderId = _undefined,
    Object? paymentMethod = _undefined,
    Object? collectionWindows = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$CheckoutSessionFields(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum$CheckoutSessionStatus),
      expiresAt: expiresAt == _undefined || expiresAt == null
          ? _instance.expiresAt
          : (expiresAt as String),
      orderId: orderId == _undefined ? _instance.orderId : (orderId as String?),
      paymentMethod: paymentMethod == _undefined
          ? _instance.paymentMethod
          : (paymentMethod as Fragment$SavedCardFields?),
      collectionWindows:
          collectionWindows == _undefined || collectionWindows == null
          ? _instance.collectionWindows
          : (collectionWindows
                as List<Fragment$CheckoutSessionFields$collectionWindows>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$SavedCardFields<TRes> get paymentMethod {
    final local$paymentMethod = _instance.paymentMethod;
    return local$paymentMethod == null
        ? CopyWith$Fragment$SavedCardFields.stub(_then(_instance))
        : CopyWith$Fragment$SavedCardFields(
            local$paymentMethod,
            (e) => call(paymentMethod: e),
          );
  }

  TRes collectionWindows(
    Iterable<Fragment$CheckoutSessionFields$collectionWindows> Function(
      Iterable<
        CopyWith$Fragment$CheckoutSessionFields$collectionWindows<
          Fragment$CheckoutSessionFields$collectionWindows
        >
      >,
    )
    _fn,
  ) => call(
    collectionWindows: _fn(
      _instance.collectionWindows.map(
        (e) => CopyWith$Fragment$CheckoutSessionFields$collectionWindows(
          e,
          (i) => i,
        ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Fragment$CheckoutSessionFields<TRes>
    implements CopyWith$Fragment$CheckoutSessionFields<TRes> {
  _CopyWithStubImpl$Fragment$CheckoutSessionFields(this._res);

  TRes _res;

  call({
    String? id,
    Enum$CheckoutSessionStatus? status,
    String? expiresAt,
    String? orderId,
    Fragment$SavedCardFields? paymentMethod,
    List<Fragment$CheckoutSessionFields$collectionWindows>? collectionWindows,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$SavedCardFields<TRes> get paymentMethod =>
      CopyWith$Fragment$SavedCardFields.stub(_res);

  collectionWindows(_fn) => _res;
}

const fragmentDefinitionCheckoutSessionFields = FragmentDefinitionNode(
  name: NameNode(value: 'CheckoutSessionFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(
      name: NameNode(value: 'CheckoutSession'),
      isNonNull: false,
    ),
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
        name: NameNode(value: 'expiresAt'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'orderId'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'paymentMethod'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FragmentSpreadNode(
              name: NameNode(value: 'SavedCardFields'),
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
      FieldNode(
        name: NameNode(value: 'collectionWindows'),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentCheckoutSessionFields = DocumentNode(
  definitions: [
    fragmentDefinitionCheckoutSessionFields,
    fragmentDefinitionSavedCardFields,
  ],
);

extension ClientExtension$Fragment$CheckoutSessionFields
    on graphql.GraphQLClient {
  void writeFragment$CheckoutSessionFields({
    required Fragment$CheckoutSessionFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'CheckoutSessionFields',
        document: documentNodeFragmentCheckoutSessionFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$CheckoutSessionFields? readFragment$CheckoutSessionFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'CheckoutSessionFields',
          document: documentNodeFragmentCheckoutSessionFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null
        ? null
        : Fragment$CheckoutSessionFields.fromJson(result);
  }
}

class Fragment$CheckoutSessionFields$collectionWindows {
  Fragment$CheckoutSessionFields$collectionWindows({
    required this.startsAt,
    required this.endsAt,
    this.$__typename = 'CollectionWindow',
  });

  factory Fragment$CheckoutSessionFields$collectionWindows.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$startsAt = json['startsAt'];
    final l$endsAt = json['endsAt'];
    final l$$__typename = json['__typename'];
    return Fragment$CheckoutSessionFields$collectionWindows(
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
    if (other is! Fragment$CheckoutSessionFields$collectionWindows ||
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

extension UtilityExtension$Fragment$CheckoutSessionFields$collectionWindows
    on Fragment$CheckoutSessionFields$collectionWindows {
  CopyWith$Fragment$CheckoutSessionFields$collectionWindows<
    Fragment$CheckoutSessionFields$collectionWindows
  >
  get copyWith =>
      CopyWith$Fragment$CheckoutSessionFields$collectionWindows(this, (i) => i);
}

abstract class CopyWith$Fragment$CheckoutSessionFields$collectionWindows<TRes> {
  factory CopyWith$Fragment$CheckoutSessionFields$collectionWindows(
    Fragment$CheckoutSessionFields$collectionWindows instance,
    TRes Function(Fragment$CheckoutSessionFields$collectionWindows) then,
  ) = _CopyWithImpl$Fragment$CheckoutSessionFields$collectionWindows;

  factory CopyWith$Fragment$CheckoutSessionFields$collectionWindows.stub(
    TRes res,
  ) = _CopyWithStubImpl$Fragment$CheckoutSessionFields$collectionWindows;

  TRes call({String? startsAt, String? endsAt, String? $__typename});
}

class _CopyWithImpl$Fragment$CheckoutSessionFields$collectionWindows<TRes>
    implements CopyWith$Fragment$CheckoutSessionFields$collectionWindows<TRes> {
  _CopyWithImpl$Fragment$CheckoutSessionFields$collectionWindows(
    this._instance,
    this._then,
  );

  final Fragment$CheckoutSessionFields$collectionWindows _instance;

  final TRes Function(Fragment$CheckoutSessionFields$collectionWindows) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? startsAt = _undefined,
    Object? endsAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$CheckoutSessionFields$collectionWindows(
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

class _CopyWithStubImpl$Fragment$CheckoutSessionFields$collectionWindows<TRes>
    implements CopyWith$Fragment$CheckoutSessionFields$collectionWindows<TRes> {
  _CopyWithStubImpl$Fragment$CheckoutSessionFields$collectionWindows(this._res);

  TRes _res;

  call({String? startsAt, String? endsAt, String? $__typename}) => _res;
}

class Variables$Query$CheckoutSession {
  factory Variables$Query$CheckoutSession({required String id}) =>
      Variables$Query$CheckoutSession._({r'id': id});

  Variables$Query$CheckoutSession._(this._$data);

  factory Variables$Query$CheckoutSession.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Query$CheckoutSession._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Query$CheckoutSession<Variables$Query$CheckoutSession>
  get copyWith => CopyWith$Variables$Query$CheckoutSession(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$CheckoutSession ||
        runtimeType != other.runtimeType) {
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

abstract class CopyWith$Variables$Query$CheckoutSession<TRes> {
  factory CopyWith$Variables$Query$CheckoutSession(
    Variables$Query$CheckoutSession instance,
    TRes Function(Variables$Query$CheckoutSession) then,
  ) = _CopyWithImpl$Variables$Query$CheckoutSession;

  factory CopyWith$Variables$Query$CheckoutSession.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$CheckoutSession;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$CheckoutSession<TRes>
    implements CopyWith$Variables$Query$CheckoutSession<TRes> {
  _CopyWithImpl$Variables$Query$CheckoutSession(this._instance, this._then);

  final Variables$Query$CheckoutSession _instance;

  final TRes Function(Variables$Query$CheckoutSession) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$CheckoutSession._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$CheckoutSession<TRes>
    implements CopyWith$Variables$Query$CheckoutSession<TRes> {
  _CopyWithStubImpl$Variables$Query$CheckoutSession(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$CheckoutSession {
  Query$CheckoutSession({
    required this.checkoutSession,
    required this.savedCards,
    this.$__typename = 'Query',
  });

  factory Query$CheckoutSession.fromJson(Map<String, dynamic> json) {
    final l$checkoutSession = json['checkoutSession'];
    final l$savedCards = json['savedCards'];
    final l$$__typename = json['__typename'];
    return Query$CheckoutSession(
      checkoutSession: Query$CheckoutSession$checkoutSession.fromJson(
        (l$checkoutSession as Map<String, dynamic>),
      ),
      savedCards: (l$savedCards as List<dynamic>)
          .map(
            (e) =>
                Fragment$SavedCardFields.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$CheckoutSession$checkoutSession checkoutSession;

  final List<Fragment$SavedCardFields> savedCards;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$checkoutSession = checkoutSession;
    _resultData['checkoutSession'] = l$checkoutSession.toJson();
    final l$savedCards = savedCards;
    _resultData['savedCards'] = l$savedCards.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$checkoutSession = checkoutSession;
    final l$savedCards = savedCards;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$checkoutSession,
      Object.hashAll(l$savedCards.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$CheckoutSession || runtimeType != other.runtimeType) {
      return false;
    }
    final l$checkoutSession = checkoutSession;
    final lOther$checkoutSession = other.checkoutSession;
    if (l$checkoutSession != lOther$checkoutSession) {
      return false;
    }
    final l$savedCards = savedCards;
    final lOther$savedCards = other.savedCards;
    if (l$savedCards.length != lOther$savedCards.length) {
      return false;
    }
    for (int i = 0; i < l$savedCards.length; i++) {
      final l$savedCards$entry = l$savedCards[i];
      final lOther$savedCards$entry = lOther$savedCards[i];
      if (l$savedCards$entry != lOther$savedCards$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$CheckoutSession on Query$CheckoutSession {
  CopyWith$Query$CheckoutSession<Query$CheckoutSession> get copyWith =>
      CopyWith$Query$CheckoutSession(this, (i) => i);
}

abstract class CopyWith$Query$CheckoutSession<TRes> {
  factory CopyWith$Query$CheckoutSession(
    Query$CheckoutSession instance,
    TRes Function(Query$CheckoutSession) then,
  ) = _CopyWithImpl$Query$CheckoutSession;

  factory CopyWith$Query$CheckoutSession.stub(TRes res) =
      _CopyWithStubImpl$Query$CheckoutSession;

  TRes call({
    Query$CheckoutSession$checkoutSession? checkoutSession,
    List<Fragment$SavedCardFields>? savedCards,
    String? $__typename,
  });
  CopyWith$Query$CheckoutSession$checkoutSession<TRes> get checkoutSession;
  TRes savedCards(
    Iterable<Fragment$SavedCardFields> Function(
      Iterable<CopyWith$Fragment$SavedCardFields<Fragment$SavedCardFields>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$CheckoutSession<TRes>
    implements CopyWith$Query$CheckoutSession<TRes> {
  _CopyWithImpl$Query$CheckoutSession(this._instance, this._then);

  final Query$CheckoutSession _instance;

  final TRes Function(Query$CheckoutSession) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? checkoutSession = _undefined,
    Object? savedCards = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$CheckoutSession(
      checkoutSession: checkoutSession == _undefined || checkoutSession == null
          ? _instance.checkoutSession
          : (checkoutSession as Query$CheckoutSession$checkoutSession),
      savedCards: savedCards == _undefined || savedCards == null
          ? _instance.savedCards
          : (savedCards as List<Fragment$SavedCardFields>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$CheckoutSession$checkoutSession<TRes> get checkoutSession {
    final local$checkoutSession = _instance.checkoutSession;
    return CopyWith$Query$CheckoutSession$checkoutSession(
      local$checkoutSession,
      (e) => call(checkoutSession: e),
    );
  }

  TRes savedCards(
    Iterable<Fragment$SavedCardFields> Function(
      Iterable<CopyWith$Fragment$SavedCardFields<Fragment$SavedCardFields>>,
    )
    _fn,
  ) => call(
    savedCards: _fn(
      _instance.savedCards.map(
        (e) => CopyWith$Fragment$SavedCardFields(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$CheckoutSession<TRes>
    implements CopyWith$Query$CheckoutSession<TRes> {
  _CopyWithStubImpl$Query$CheckoutSession(this._res);

  TRes _res;

  call({
    Query$CheckoutSession$checkoutSession? checkoutSession,
    List<Fragment$SavedCardFields>? savedCards,
    String? $__typename,
  }) => _res;

  CopyWith$Query$CheckoutSession$checkoutSession<TRes> get checkoutSession =>
      CopyWith$Query$CheckoutSession$checkoutSession.stub(_res);

  savedCards(_fn) => _res;
}

const documentNodeQueryCheckoutSession = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'CheckoutSession'),
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
            name: NameNode(value: 'checkoutSession'),
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
                      name: NameNode(value: 'CheckoutSession'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'CheckoutSessionFields'),
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
                      name: NameNode(value: 'SessionNotFound'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'sessionId'),
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
            name: NameNode(value: 'savedCards'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'SavedCardFields'),
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
    fragmentDefinitionCheckoutSessionFields,
    fragmentDefinitionSavedCardFields,
  ],
);
Query$CheckoutSession _parserFn$Query$CheckoutSession(
  Map<String, dynamic> data,
) => Query$CheckoutSession.fromJson(data);
typedef OnQueryComplete$Query$CheckoutSession = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$CheckoutSession?,
);

class Options$Query$CheckoutSession
    extends graphql.QueryOptions<Query$CheckoutSession> {
  Options$Query$CheckoutSession({
    String? operationName,
    required Variables$Query$CheckoutSession variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$CheckoutSession? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$CheckoutSession? onComplete,
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
                 data == null ? null : _parserFn$Query$CheckoutSession(data),
               ),
         onError: onError,
         document: documentNodeQueryCheckoutSession,
         parserFn: _parserFn$Query$CheckoutSession,
       );

  final OnQueryComplete$Query$CheckoutSession? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$CheckoutSession
    extends graphql.WatchQueryOptions<Query$CheckoutSession> {
  WatchOptions$Query$CheckoutSession({
    String? operationName,
    required Variables$Query$CheckoutSession variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$CheckoutSession? typedOptimisticResult,
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
         document: documentNodeQueryCheckoutSession,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$CheckoutSession,
       );
}

class FetchMoreOptions$Query$CheckoutSession extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$CheckoutSession({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$CheckoutSession variables,
  }) : super(
         updateQuery: updateQuery,
         variables: variables.toJson(),
         document: documentNodeQueryCheckoutSession,
       );
}

extension ClientExtension$Query$CheckoutSession on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$CheckoutSession>> query$CheckoutSession(
    Options$Query$CheckoutSession options,
  ) async => await this.query(options);

  graphql.ObservableQuery<Query$CheckoutSession> watchQuery$CheckoutSession(
    WatchOptions$Query$CheckoutSession options,
  ) => this.watchQuery(options);

  void writeQuery$CheckoutSession({
    required Query$CheckoutSession data,
    required Variables$Query$CheckoutSession variables,
    bool broadcast = true,
  }) => this.writeQuery(
    graphql.Request(
      operation: graphql.Operation(document: documentNodeQueryCheckoutSession),
      variables: variables.toJson(),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Query$CheckoutSession? readQuery$CheckoutSession({
    required Variables$Query$CheckoutSession variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(
          document: documentNodeQueryCheckoutSession,
        ),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$CheckoutSession.fromJson(result);
  }
}

class Query$CheckoutSession$checkoutSession {
  Query$CheckoutSession$checkoutSession({required this.$__typename});

  factory Query$CheckoutSession$checkoutSession.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "CheckoutSession":
        return Query$CheckoutSession$checkoutSession$$CheckoutSession.fromJson(
          json,
        );

      case "SessionNotFound":
        return Query$CheckoutSession$checkoutSession$$SessionNotFound.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Query$CheckoutSession$checkoutSession(
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
    if (other is! Query$CheckoutSession$checkoutSession ||
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

extension UtilityExtension$Query$CheckoutSession$checkoutSession
    on Query$CheckoutSession$checkoutSession {
  CopyWith$Query$CheckoutSession$checkoutSession<
    Query$CheckoutSession$checkoutSession
  >
  get copyWith =>
      CopyWith$Query$CheckoutSession$checkoutSession(this, (i) => i);

  _T when<_T>({
    required _T Function(Query$CheckoutSession$checkoutSession$$CheckoutSession)
    checkoutSession,
    required _T Function(Query$CheckoutSession$checkoutSession$$SessionNotFound)
    sessionNotFound,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CheckoutSession":
        return checkoutSession(
          this as Query$CheckoutSession$checkoutSession$$CheckoutSession,
        );

      case "SessionNotFound":
        return sessionNotFound(
          this as Query$CheckoutSession$checkoutSession$$SessionNotFound,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query$CheckoutSession$checkoutSession$$CheckoutSession)?
    checkoutSession,
    _T Function(Query$CheckoutSession$checkoutSession$$SessionNotFound)?
    sessionNotFound,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CheckoutSession":
        if (checkoutSession != null) {
          return checkoutSession(
            this as Query$CheckoutSession$checkoutSession$$CheckoutSession,
          );
        } else {
          return orElse();
        }

      case "SessionNotFound":
        if (sessionNotFound != null) {
          return sessionNotFound(
            this as Query$CheckoutSession$checkoutSession$$SessionNotFound,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Query$CheckoutSession$checkoutSession<TRes> {
  factory CopyWith$Query$CheckoutSession$checkoutSession(
    Query$CheckoutSession$checkoutSession instance,
    TRes Function(Query$CheckoutSession$checkoutSession) then,
  ) = _CopyWithImpl$Query$CheckoutSession$checkoutSession;

  factory CopyWith$Query$CheckoutSession$checkoutSession.stub(TRes res) =
      _CopyWithStubImpl$Query$CheckoutSession$checkoutSession;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Query$CheckoutSession$checkoutSession<TRes>
    implements CopyWith$Query$CheckoutSession$checkoutSession<TRes> {
  _CopyWithImpl$Query$CheckoutSession$checkoutSession(
    this._instance,
    this._then,
  );

  final Query$CheckoutSession$checkoutSession _instance;

  final TRes Function(Query$CheckoutSession$checkoutSession) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Query$CheckoutSession$checkoutSession(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$CheckoutSession$checkoutSession<TRes>
    implements CopyWith$Query$CheckoutSession$checkoutSession<TRes> {
  _CopyWithStubImpl$Query$CheckoutSession$checkoutSession(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Query$CheckoutSession$checkoutSession$$CheckoutSession
    implements
        Fragment$CheckoutSessionFields,
        Query$CheckoutSession$checkoutSession {
  Query$CheckoutSession$checkoutSession$$CheckoutSession({
    required this.id,
    required this.status,
    required this.expiresAt,
    this.orderId,
    this.paymentMethod,
    required this.collectionWindows,
    this.$__typename = 'CheckoutSession',
  });

  factory Query$CheckoutSession$checkoutSession$$CheckoutSession.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$expiresAt = json['expiresAt'];
    final l$orderId = json['orderId'];
    final l$paymentMethod = json['paymentMethod'];
    final l$collectionWindows = json['collectionWindows'];
    final l$$__typename = json['__typename'];
    return Query$CheckoutSession$checkoutSession$$CheckoutSession(
      id: (l$id as String),
      status: fromJson$Enum$CheckoutSessionStatus((l$status as String)),
      expiresAt: (l$expiresAt as String),
      orderId: (l$orderId as String?),
      paymentMethod: l$paymentMethod == null
          ? null
          : Fragment$SavedCardFields.fromJson(
              (l$paymentMethod as Map<String, dynamic>),
            ),
      collectionWindows: (l$collectionWindows as List<dynamic>)
          .map(
            (e) =>
                Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$CheckoutSessionStatus status;

  final String expiresAt;

  final String? orderId;

  final Fragment$SavedCardFields? paymentMethod;

  final List<
    Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
  >
  collectionWindows;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson$Enum$CheckoutSessionStatus(l$status);
    final l$expiresAt = expiresAt;
    _resultData['expiresAt'] = l$expiresAt;
    final l$orderId = orderId;
    _resultData['orderId'] = l$orderId;
    final l$paymentMethod = paymentMethod;
    _resultData['paymentMethod'] = l$paymentMethod?.toJson();
    final l$collectionWindows = collectionWindows;
    _resultData['collectionWindows'] = l$collectionWindows
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$expiresAt = expiresAt;
    final l$orderId = orderId;
    final l$paymentMethod = paymentMethod;
    final l$collectionWindows = collectionWindows;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$expiresAt,
      l$orderId,
      l$paymentMethod,
      Object.hashAll(l$collectionWindows.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$CheckoutSession$checkoutSession$$CheckoutSession ||
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
    final l$expiresAt = expiresAt;
    final lOther$expiresAt = other.expiresAt;
    if (l$expiresAt != lOther$expiresAt) {
      return false;
    }
    final l$orderId = orderId;
    final lOther$orderId = other.orderId;
    if (l$orderId != lOther$orderId) {
      return false;
    }
    final l$paymentMethod = paymentMethod;
    final lOther$paymentMethod = other.paymentMethod;
    if (l$paymentMethod != lOther$paymentMethod) {
      return false;
    }
    final l$collectionWindows = collectionWindows;
    final lOther$collectionWindows = other.collectionWindows;
    if (l$collectionWindows.length != lOther$collectionWindows.length) {
      return false;
    }
    for (int i = 0; i < l$collectionWindows.length; i++) {
      final l$collectionWindows$entry = l$collectionWindows[i];
      final lOther$collectionWindows$entry = lOther$collectionWindows[i];
      if (l$collectionWindows$entry != lOther$collectionWindows$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$CheckoutSession$checkoutSession$$CheckoutSession
    on Query$CheckoutSession$checkoutSession$$CheckoutSession {
  CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession<
    Query$CheckoutSession$checkoutSession$$CheckoutSession
  >
  get copyWith =>
      CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession<
  TRes
> {
  factory CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession(
    Query$CheckoutSession$checkoutSession$$CheckoutSession instance,
    TRes Function(Query$CheckoutSession$checkoutSession$$CheckoutSession) then,
  ) = _CopyWithImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession;

  factory CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession;

  TRes call({
    String? id,
    Enum$CheckoutSessionStatus? status,
    String? expiresAt,
    String? orderId,
    Fragment$SavedCardFields? paymentMethod,
    List<
      Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
    >?
    collectionWindows,
    String? $__typename,
  });
  CopyWith$Fragment$SavedCardFields<TRes> get paymentMethod;
  TRes collectionWindows(
    Iterable<
      Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
    >
    Function(
      Iterable<
        CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows<
          Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession<TRes>
    implements
        CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession<TRes> {
  _CopyWithImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession(
    this._instance,
    this._then,
  );

  final Query$CheckoutSession$checkoutSession$$CheckoutSession _instance;

  final TRes Function(Query$CheckoutSession$checkoutSession$$CheckoutSession)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? expiresAt = _undefined,
    Object? orderId = _undefined,
    Object? paymentMethod = _undefined,
    Object? collectionWindows = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$CheckoutSession$checkoutSession$$CheckoutSession(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum$CheckoutSessionStatus),
      expiresAt: expiresAt == _undefined || expiresAt == null
          ? _instance.expiresAt
          : (expiresAt as String),
      orderId: orderId == _undefined ? _instance.orderId : (orderId as String?),
      paymentMethod: paymentMethod == _undefined
          ? _instance.paymentMethod
          : (paymentMethod as Fragment$SavedCardFields?),
      collectionWindows:
          collectionWindows == _undefined || collectionWindows == null
          ? _instance.collectionWindows
          : (collectionWindows
                as List<
                  Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$SavedCardFields<TRes> get paymentMethod {
    final local$paymentMethod = _instance.paymentMethod;
    return local$paymentMethod == null
        ? CopyWith$Fragment$SavedCardFields.stub(_then(_instance))
        : CopyWith$Fragment$SavedCardFields(
            local$paymentMethod,
            (e) => call(paymentMethod: e),
          );
  }

  TRes collectionWindows(
    Iterable<
      Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
    >
    Function(
      Iterable<
        CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows<
          Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
        >
      >,
    )
    _fn,
  ) => call(
    collectionWindows: _fn(
      _instance.collectionWindows.map(
        (e) =>
            CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession<
  TRes
>
    implements
        CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession<TRes> {
  _CopyWithStubImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Enum$CheckoutSessionStatus? status,
    String? expiresAt,
    String? orderId,
    Fragment$SavedCardFields? paymentMethod,
    List<
      Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
    >?
    collectionWindows,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$SavedCardFields<TRes> get paymentMethod =>
      CopyWith$Fragment$SavedCardFields.stub(_res);

  collectionWindows(_fn) => _res;
}

class Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
    implements Fragment$CheckoutSessionFields$collectionWindows {
  Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows({
    required this.startsAt,
    required this.endsAt,
    this.$__typename = 'CollectionWindow',
  });

  factory Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$startsAt = json['startsAt'];
    final l$endsAt = json['endsAt'];
    final l$$__typename = json['__typename'];
    return Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows(
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
            is! Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows ||
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

extension UtilityExtension$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
    on Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows {
  CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows<
    Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
  >
  get copyWith =>
      CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows<
  TRes
> {
  factory CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows(
    Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
    instance,
    TRes Function(
      Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows,
    )
    then,
  ) = _CopyWithImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows;

  factory CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows;

  TRes call({String? startsAt, String? endsAt, String? $__typename});
}

class _CopyWithImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows<
  TRes
>
    implements
        CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows<
          TRes
        > {
  _CopyWithImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows(
    this._instance,
    this._then,
  );

  final Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows
  _instance;

  final TRes Function(
    Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? startsAt = _undefined,
    Object? endsAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows(
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

class _CopyWithStubImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows<
  TRes
>
    implements
        CopyWith$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows<
          TRes
        > {
  _CopyWithStubImpl$Query$CheckoutSession$checkoutSession$$CheckoutSession$collectionWindows(
    this._res,
  );

  TRes _res;

  call({String? startsAt, String? endsAt, String? $__typename}) => _res;
}

class Query$CheckoutSession$checkoutSession$$SessionNotFound
    implements Query$CheckoutSession$checkoutSession {
  Query$CheckoutSession$checkoutSession$$SessionNotFound({
    required this.sessionId,
    this.$__typename = 'SessionNotFound',
  });

  factory Query$CheckoutSession$checkoutSession$$SessionNotFound.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$sessionId = json['sessionId'];
    final l$$__typename = json['__typename'];
    return Query$CheckoutSession$checkoutSession$$SessionNotFound(
      sessionId: (l$sessionId as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String sessionId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sessionId = sessionId;
    _resultData['sessionId'] = l$sessionId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sessionId = sessionId;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sessionId, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$CheckoutSession$checkoutSession$$SessionNotFound ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionId = sessionId;
    final lOther$sessionId = other.sessionId;
    if (l$sessionId != lOther$sessionId) {
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

extension UtilityExtension$Query$CheckoutSession$checkoutSession$$SessionNotFound
    on Query$CheckoutSession$checkoutSession$$SessionNotFound {
  CopyWith$Query$CheckoutSession$checkoutSession$$SessionNotFound<
    Query$CheckoutSession$checkoutSession$$SessionNotFound
  >
  get copyWith =>
      CopyWith$Query$CheckoutSession$checkoutSession$$SessionNotFound(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$CheckoutSession$checkoutSession$$SessionNotFound<
  TRes
> {
  factory CopyWith$Query$CheckoutSession$checkoutSession$$SessionNotFound(
    Query$CheckoutSession$checkoutSession$$SessionNotFound instance,
    TRes Function(Query$CheckoutSession$checkoutSession$$SessionNotFound) then,
  ) = _CopyWithImpl$Query$CheckoutSession$checkoutSession$$SessionNotFound;

  factory CopyWith$Query$CheckoutSession$checkoutSession$$SessionNotFound.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$CheckoutSession$checkoutSession$$SessionNotFound;

  TRes call({String? sessionId, String? $__typename});
}

class _CopyWithImpl$Query$CheckoutSession$checkoutSession$$SessionNotFound<TRes>
    implements
        CopyWith$Query$CheckoutSession$checkoutSession$$SessionNotFound<TRes> {
  _CopyWithImpl$Query$CheckoutSession$checkoutSession$$SessionNotFound(
    this._instance,
    this._then,
  );

  final Query$CheckoutSession$checkoutSession$$SessionNotFound _instance;

  final TRes Function(Query$CheckoutSession$checkoutSession$$SessionNotFound)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sessionId = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$CheckoutSession$checkoutSession$$SessionNotFound(
      sessionId: sessionId == _undefined || sessionId == null
          ? _instance.sessionId
          : (sessionId as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$CheckoutSession$checkoutSession$$SessionNotFound<
  TRes
>
    implements
        CopyWith$Query$CheckoutSession$checkoutSession$$SessionNotFound<TRes> {
  _CopyWithStubImpl$Query$CheckoutSession$checkoutSession$$SessionNotFound(
    this._res,
  );

  TRes _res;

  call({String? sessionId, String? $__typename}) => _res;
}

class Mutation$CreateCheckoutSession {
  Mutation$CreateCheckoutSession({
    required this.createCheckoutSession,
    this.$__typename = 'Mutation',
  });

  factory Mutation$CreateCheckoutSession.fromJson(Map<String, dynamic> json) {
    final l$createCheckoutSession = json['createCheckoutSession'];
    final l$$__typename = json['__typename'];
    return Mutation$CreateCheckoutSession(
      createCheckoutSession:
          Mutation$CreateCheckoutSession$createCheckoutSession.fromJson(
            (l$createCheckoutSession as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$CreateCheckoutSession$createCheckoutSession
  createCheckoutSession;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$createCheckoutSession = createCheckoutSession;
    _resultData['createCheckoutSession'] = l$createCheckoutSession.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$createCheckoutSession = createCheckoutSession;
    final l$$__typename = $__typename;
    return Object.hashAll([l$createCheckoutSession, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateCheckoutSession ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$createCheckoutSession = createCheckoutSession;
    final lOther$createCheckoutSession = other.createCheckoutSession;
    if (l$createCheckoutSession != lOther$createCheckoutSession) {
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

extension UtilityExtension$Mutation$CreateCheckoutSession
    on Mutation$CreateCheckoutSession {
  CopyWith$Mutation$CreateCheckoutSession<Mutation$CreateCheckoutSession>
  get copyWith => CopyWith$Mutation$CreateCheckoutSession(this, (i) => i);
}

abstract class CopyWith$Mutation$CreateCheckoutSession<TRes> {
  factory CopyWith$Mutation$CreateCheckoutSession(
    Mutation$CreateCheckoutSession instance,
    TRes Function(Mutation$CreateCheckoutSession) then,
  ) = _CopyWithImpl$Mutation$CreateCheckoutSession;

  factory CopyWith$Mutation$CreateCheckoutSession.stub(TRes res) =
      _CopyWithStubImpl$Mutation$CreateCheckoutSession;

  TRes call({
    Mutation$CreateCheckoutSession$createCheckoutSession? createCheckoutSession,
    String? $__typename,
  });
  CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession<TRes>
  get createCheckoutSession;
}

class _CopyWithImpl$Mutation$CreateCheckoutSession<TRes>
    implements CopyWith$Mutation$CreateCheckoutSession<TRes> {
  _CopyWithImpl$Mutation$CreateCheckoutSession(this._instance, this._then);

  final Mutation$CreateCheckoutSession _instance;

  final TRes Function(Mutation$CreateCheckoutSession) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? createCheckoutSession = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$CreateCheckoutSession(
      createCheckoutSession:
          createCheckoutSession == _undefined || createCheckoutSession == null
          ? _instance.createCheckoutSession
          : (createCheckoutSession
                as Mutation$CreateCheckoutSession$createCheckoutSession),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession<TRes>
  get createCheckoutSession {
    final local$createCheckoutSession = _instance.createCheckoutSession;
    return CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession(
      local$createCheckoutSession,
      (e) => call(createCheckoutSession: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$CreateCheckoutSession<TRes>
    implements CopyWith$Mutation$CreateCheckoutSession<TRes> {
  _CopyWithStubImpl$Mutation$CreateCheckoutSession(this._res);

  TRes _res;

  call({
    Mutation$CreateCheckoutSession$createCheckoutSession? createCheckoutSession,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession<TRes>
  get createCheckoutSession =>
      CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession.stub(_res);
}

const documentNodeMutationCreateCheckoutSession = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'CreateCheckoutSession'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'createCheckoutSession'),
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
);
Mutation$CreateCheckoutSession _parserFn$Mutation$CreateCheckoutSession(
  Map<String, dynamic> data,
) => Mutation$CreateCheckoutSession.fromJson(data);
typedef OnMutationCompleted$Mutation$CreateCheckoutSession =
    FutureOr<void> Function(
      Map<String, dynamic>?,
      Mutation$CreateCheckoutSession?,
    );

class Options$Mutation$CreateCheckoutSession
    extends graphql.MutationOptions<Mutation$CreateCheckoutSession> {
  Options$Mutation$CreateCheckoutSession({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$CreateCheckoutSession? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$CreateCheckoutSession? onCompleted,
    graphql.OnMutationUpdate<Mutation$CreateCheckoutSession>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null
                     ? null
                     : _parserFn$Mutation$CreateCheckoutSession(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationCreateCheckoutSession,
         parserFn: _parserFn$Mutation$CreateCheckoutSession,
       );

  final OnMutationCompleted$Mutation$CreateCheckoutSession?
  onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$CreateCheckoutSession
    extends graphql.WatchQueryOptions<Mutation$CreateCheckoutSession> {
  WatchOptions$Mutation$CreateCheckoutSession({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$CreateCheckoutSession? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         document: documentNodeMutationCreateCheckoutSession,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$CreateCheckoutSession,
       );
}

extension ClientExtension$Mutation$CreateCheckoutSession
    on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$CreateCheckoutSession>>
  mutate$CreateCheckoutSession([
    Options$Mutation$CreateCheckoutSession? options,
  ]) async =>
      await this.mutate(options ?? Options$Mutation$CreateCheckoutSession());

  graphql.ObservableQuery<Mutation$CreateCheckoutSession>
  watchMutation$CreateCheckoutSession([
    WatchOptions$Mutation$CreateCheckoutSession? options,
  ]) => this.watchMutation(
    options ?? WatchOptions$Mutation$CreateCheckoutSession(),
  );
}

class Mutation$CreateCheckoutSession$createCheckoutSession {
  Mutation$CreateCheckoutSession$createCheckoutSession({
    required this.id,
    this.$__typename = 'CheckoutSession',
  });

  factory Mutation$CreateCheckoutSession$createCheckoutSession.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$$__typename = json['__typename'];
    return Mutation$CreateCheckoutSession$createCheckoutSession(
      id: (l$id as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$CreateCheckoutSession$createCheckoutSession ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
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

extension UtilityExtension$Mutation$CreateCheckoutSession$createCheckoutSession
    on Mutation$CreateCheckoutSession$createCheckoutSession {
  CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession<
    Mutation$CreateCheckoutSession$createCheckoutSession
  >
  get copyWith => CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession<
  TRes
> {
  factory CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession(
    Mutation$CreateCheckoutSession$createCheckoutSession instance,
    TRes Function(Mutation$CreateCheckoutSession$createCheckoutSession) then,
  ) = _CopyWithImpl$Mutation$CreateCheckoutSession$createCheckoutSession;

  factory CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$CreateCheckoutSession$createCheckoutSession;

  TRes call({String? id, String? $__typename});
}

class _CopyWithImpl$Mutation$CreateCheckoutSession$createCheckoutSession<TRes>
    implements
        CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession<TRes> {
  _CopyWithImpl$Mutation$CreateCheckoutSession$createCheckoutSession(
    this._instance,
    this._then,
  );

  final Mutation$CreateCheckoutSession$createCheckoutSession _instance;

  final TRes Function(Mutation$CreateCheckoutSession$createCheckoutSession)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation$CreateCheckoutSession$createCheckoutSession(
          id: id == _undefined || id == null ? _instance.id : (id as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Mutation$CreateCheckoutSession$createCheckoutSession<
  TRes
>
    implements
        CopyWith$Mutation$CreateCheckoutSession$createCheckoutSession<TRes> {
  _CopyWithStubImpl$Mutation$CreateCheckoutSession$createCheckoutSession(
    this._res,
  );

  TRes _res;

  call({String? id, String? $__typename}) => _res;
}

class Variables$Mutation$SetPaymentMethod {
  factory Variables$Mutation$SetPaymentMethod({
    required String sessionId,
    required String cardId,
  }) => Variables$Mutation$SetPaymentMethod._({
    r'sessionId': sessionId,
    r'cardId': cardId,
  });

  Variables$Mutation$SetPaymentMethod._(this._$data);

  factory Variables$Mutation$SetPaymentMethod.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$sessionId = data['sessionId'];
    result$data['sessionId'] = (l$sessionId as String);
    final l$cardId = data['cardId'];
    result$data['cardId'] = (l$cardId as String);
    return Variables$Mutation$SetPaymentMethod._(result$data);
  }

  Map<String, dynamic> _$data;

  String get sessionId => (_$data['sessionId'] as String);

  String get cardId => (_$data['cardId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$sessionId = sessionId;
    result$data['sessionId'] = l$sessionId;
    final l$cardId = cardId;
    result$data['cardId'] = l$cardId;
    return result$data;
  }

  CopyWith$Variables$Mutation$SetPaymentMethod<
    Variables$Mutation$SetPaymentMethod
  >
  get copyWith => CopyWith$Variables$Mutation$SetPaymentMethod(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$SetPaymentMethod ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionId = sessionId;
    final lOther$sessionId = other.sessionId;
    if (l$sessionId != lOther$sessionId) {
      return false;
    }
    final l$cardId = cardId;
    final lOther$cardId = other.cardId;
    if (l$cardId != lOther$cardId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$sessionId = sessionId;
    final l$cardId = cardId;
    return Object.hashAll([l$sessionId, l$cardId]);
  }
}

abstract class CopyWith$Variables$Mutation$SetPaymentMethod<TRes> {
  factory CopyWith$Variables$Mutation$SetPaymentMethod(
    Variables$Mutation$SetPaymentMethod instance,
    TRes Function(Variables$Mutation$SetPaymentMethod) then,
  ) = _CopyWithImpl$Variables$Mutation$SetPaymentMethod;

  factory CopyWith$Variables$Mutation$SetPaymentMethod.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$SetPaymentMethod;

  TRes call({String? sessionId, String? cardId});
}

class _CopyWithImpl$Variables$Mutation$SetPaymentMethod<TRes>
    implements CopyWith$Variables$Mutation$SetPaymentMethod<TRes> {
  _CopyWithImpl$Variables$Mutation$SetPaymentMethod(this._instance, this._then);

  final Variables$Mutation$SetPaymentMethod _instance;

  final TRes Function(Variables$Mutation$SetPaymentMethod) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? sessionId = _undefined, Object? cardId = _undefined}) =>
      _then(
        Variables$Mutation$SetPaymentMethod._({
          ..._instance._$data,
          if (sessionId != _undefined && sessionId != null)
            'sessionId': (sessionId as String),
          if (cardId != _undefined && cardId != null)
            'cardId': (cardId as String),
        }),
      );
}

class _CopyWithStubImpl$Variables$Mutation$SetPaymentMethod<TRes>
    implements CopyWith$Variables$Mutation$SetPaymentMethod<TRes> {
  _CopyWithStubImpl$Variables$Mutation$SetPaymentMethod(this._res);

  TRes _res;

  call({String? sessionId, String? cardId}) => _res;
}

class Mutation$SetPaymentMethod {
  Mutation$SetPaymentMethod({
    required this.setPaymentMethod,
    this.$__typename = 'Mutation',
  });

  factory Mutation$SetPaymentMethod.fromJson(Map<String, dynamic> json) {
    final l$setPaymentMethod = json['setPaymentMethod'];
    final l$$__typename = json['__typename'];
    return Mutation$SetPaymentMethod(
      setPaymentMethod: Mutation$SetPaymentMethod$setPaymentMethod.fromJson(
        (l$setPaymentMethod as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SetPaymentMethod$setPaymentMethod setPaymentMethod;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$setPaymentMethod = setPaymentMethod;
    _resultData['setPaymentMethod'] = l$setPaymentMethod.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$setPaymentMethod = setPaymentMethod;
    final l$$__typename = $__typename;
    return Object.hashAll([l$setPaymentMethod, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SetPaymentMethod ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$setPaymentMethod = setPaymentMethod;
    final lOther$setPaymentMethod = other.setPaymentMethod;
    if (l$setPaymentMethod != lOther$setPaymentMethod) {
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

extension UtilityExtension$Mutation$SetPaymentMethod
    on Mutation$SetPaymentMethod {
  CopyWith$Mutation$SetPaymentMethod<Mutation$SetPaymentMethod> get copyWith =>
      CopyWith$Mutation$SetPaymentMethod(this, (i) => i);
}

abstract class CopyWith$Mutation$SetPaymentMethod<TRes> {
  factory CopyWith$Mutation$SetPaymentMethod(
    Mutation$SetPaymentMethod instance,
    TRes Function(Mutation$SetPaymentMethod) then,
  ) = _CopyWithImpl$Mutation$SetPaymentMethod;

  factory CopyWith$Mutation$SetPaymentMethod.stub(TRes res) =
      _CopyWithStubImpl$Mutation$SetPaymentMethod;

  TRes call({
    Mutation$SetPaymentMethod$setPaymentMethod? setPaymentMethod,
    String? $__typename,
  });
  CopyWith$Mutation$SetPaymentMethod$setPaymentMethod<TRes>
  get setPaymentMethod;
}

class _CopyWithImpl$Mutation$SetPaymentMethod<TRes>
    implements CopyWith$Mutation$SetPaymentMethod<TRes> {
  _CopyWithImpl$Mutation$SetPaymentMethod(this._instance, this._then);

  final Mutation$SetPaymentMethod _instance;

  final TRes Function(Mutation$SetPaymentMethod) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? setPaymentMethod = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$SetPaymentMethod(
      setPaymentMethod:
          setPaymentMethod == _undefined || setPaymentMethod == null
          ? _instance.setPaymentMethod
          : (setPaymentMethod as Mutation$SetPaymentMethod$setPaymentMethod),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$SetPaymentMethod$setPaymentMethod<TRes>
  get setPaymentMethod {
    final local$setPaymentMethod = _instance.setPaymentMethod;
    return CopyWith$Mutation$SetPaymentMethod$setPaymentMethod(
      local$setPaymentMethod,
      (e) => call(setPaymentMethod: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$SetPaymentMethod<TRes>
    implements CopyWith$Mutation$SetPaymentMethod<TRes> {
  _CopyWithStubImpl$Mutation$SetPaymentMethod(this._res);

  TRes _res;

  call({
    Mutation$SetPaymentMethod$setPaymentMethod? setPaymentMethod,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$SetPaymentMethod$setPaymentMethod<TRes>
  get setPaymentMethod =>
      CopyWith$Mutation$SetPaymentMethod$setPaymentMethod.stub(_res);
}

const documentNodeMutationSetPaymentMethod = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SetPaymentMethod'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sessionId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'cardId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'setPaymentMethod'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'sessionId'),
                value: VariableNode(name: NameNode(value: 'sessionId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'cardId'),
                value: VariableNode(name: NameNode(value: 'cardId')),
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
                      name: NameNode(value: 'CheckoutSession'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'CheckoutSessionFields'),
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
                      name: NameNode(value: 'SessionNotFound'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'sessionId'),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'SessionExpired'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'sessionId'),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'CardNotFound'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'cardId'),
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
    fragmentDefinitionCheckoutSessionFields,
    fragmentDefinitionSavedCardFields,
  ],
);
Mutation$SetPaymentMethod _parserFn$Mutation$SetPaymentMethod(
  Map<String, dynamic> data,
) => Mutation$SetPaymentMethod.fromJson(data);
typedef OnMutationCompleted$Mutation$SetPaymentMethod = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$SetPaymentMethod?,
);

class Options$Mutation$SetPaymentMethod
    extends graphql.MutationOptions<Mutation$SetPaymentMethod> {
  Options$Mutation$SetPaymentMethod({
    String? operationName,
    required Variables$Mutation$SetPaymentMethod variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SetPaymentMethod? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SetPaymentMethod? onCompleted,
    graphql.OnMutationUpdate<Mutation$SetPaymentMethod>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null
                     ? null
                     : _parserFn$Mutation$SetPaymentMethod(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSetPaymentMethod,
         parserFn: _parserFn$Mutation$SetPaymentMethod,
       );

  final OnMutationCompleted$Mutation$SetPaymentMethod? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SetPaymentMethod
    extends graphql.WatchQueryOptions<Mutation$SetPaymentMethod> {
  WatchOptions$Mutation$SetPaymentMethod({
    String? operationName,
    required Variables$Mutation$SetPaymentMethod variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SetPaymentMethod? typedOptimisticResult,
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
         document: documentNodeMutationSetPaymentMethod,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SetPaymentMethod,
       );
}

extension ClientExtension$Mutation$SetPaymentMethod on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SetPaymentMethod>>
  mutate$SetPaymentMethod(Options$Mutation$SetPaymentMethod options) async =>
      await this.mutate(options);

  graphql.ObservableQuery<Mutation$SetPaymentMethod>
  watchMutation$SetPaymentMethod(
    WatchOptions$Mutation$SetPaymentMethod options,
  ) => this.watchMutation(options);
}

class Mutation$SetPaymentMethod$setPaymentMethod {
  Mutation$SetPaymentMethod$setPaymentMethod({required this.$__typename});

  factory Mutation$SetPaymentMethod$setPaymentMethod.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "CheckoutSession":
        return Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession.fromJson(
          json,
        );

      case "SessionNotFound":
        return Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound.fromJson(
          json,
        );

      case "SessionExpired":
        return Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired.fromJson(
          json,
        );

      case "CardNotFound":
        return Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$SetPaymentMethod$setPaymentMethod(
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
    if (other is! Mutation$SetPaymentMethod$setPaymentMethod ||
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

extension UtilityExtension$Mutation$SetPaymentMethod$setPaymentMethod
    on Mutation$SetPaymentMethod$setPaymentMethod {
  CopyWith$Mutation$SetPaymentMethod$setPaymentMethod<
    Mutation$SetPaymentMethod$setPaymentMethod
  >
  get copyWith =>
      CopyWith$Mutation$SetPaymentMethod$setPaymentMethod(this, (i) => i);

  _T when<_T>({
    required _T Function(
      Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession,
    )
    checkoutSession,
    required _T Function(
      Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound,
    )
    sessionNotFound,
    required _T Function(
      Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired,
    )
    sessionExpired,
    required _T Function(
      Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound,
    )
    cardNotFound,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CheckoutSession":
        return checkoutSession(
          this as Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession,
        );

      case "SessionNotFound":
        return sessionNotFound(
          this as Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound,
        );

      case "SessionExpired":
        return sessionExpired(
          this as Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired,
        );

      case "CardNotFound":
        return cardNotFound(
          this as Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession)?
    checkoutSession,
    _T Function(Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound)?
    sessionNotFound,
    _T Function(Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired)?
    sessionExpired,
    _T Function(Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound)?
    cardNotFound,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "CheckoutSession":
        if (checkoutSession != null) {
          return checkoutSession(
            this as Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession,
          );
        } else {
          return orElse();
        }

      case "SessionNotFound":
        if (sessionNotFound != null) {
          return sessionNotFound(
            this as Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound,
          );
        } else {
          return orElse();
        }

      case "SessionExpired":
        if (sessionExpired != null) {
          return sessionExpired(
            this as Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired,
          );
        } else {
          return orElse();
        }

      case "CardNotFound":
        if (cardNotFound != null) {
          return cardNotFound(
            this as Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Mutation$SetPaymentMethod$setPaymentMethod<TRes> {
  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod(
    Mutation$SetPaymentMethod$setPaymentMethod instance,
    TRes Function(Mutation$SetPaymentMethod$setPaymentMethod) then,
  ) = _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod;

  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod.stub(TRes res) =
      _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod<TRes>
    implements CopyWith$Mutation$SetPaymentMethod$setPaymentMethod<TRes> {
  _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod(
    this._instance,
    this._then,
  );

  final Mutation$SetPaymentMethod$setPaymentMethod _instance;

  final TRes Function(Mutation$SetPaymentMethod$setPaymentMethod) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation$SetPaymentMethod$setPaymentMethod(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod<TRes>
    implements CopyWith$Mutation$SetPaymentMethod$setPaymentMethod<TRes> {
  _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession
    implements
        Fragment$CheckoutSessionFields,
        Mutation$SetPaymentMethod$setPaymentMethod {
  Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession({
    required this.id,
    required this.status,
    required this.expiresAt,
    this.orderId,
    this.paymentMethod,
    required this.collectionWindows,
    this.$__typename = 'CheckoutSession',
  });

  factory Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$expiresAt = json['expiresAt'];
    final l$orderId = json['orderId'];
    final l$paymentMethod = json['paymentMethod'];
    final l$collectionWindows = json['collectionWindows'];
    final l$$__typename = json['__typename'];
    return Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession(
      id: (l$id as String),
      status: fromJson$Enum$CheckoutSessionStatus((l$status as String)),
      expiresAt: (l$expiresAt as String),
      orderId: (l$orderId as String?),
      paymentMethod: l$paymentMethod == null
          ? null
          : Fragment$SavedCardFields.fromJson(
              (l$paymentMethod as Map<String, dynamic>),
            ),
      collectionWindows: (l$collectionWindows as List<dynamic>)
          .map(
            (e) =>
                Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$CheckoutSessionStatus status;

  final String expiresAt;

  final String? orderId;

  final Fragment$SavedCardFields? paymentMethod;

  final List<
    Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
  >
  collectionWindows;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson$Enum$CheckoutSessionStatus(l$status);
    final l$expiresAt = expiresAt;
    _resultData['expiresAt'] = l$expiresAt;
    final l$orderId = orderId;
    _resultData['orderId'] = l$orderId;
    final l$paymentMethod = paymentMethod;
    _resultData['paymentMethod'] = l$paymentMethod?.toJson();
    final l$collectionWindows = collectionWindows;
    _resultData['collectionWindows'] = l$collectionWindows
        .map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$expiresAt = expiresAt;
    final l$orderId = orderId;
    final l$paymentMethod = paymentMethod;
    final l$collectionWindows = collectionWindows;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$status,
      l$expiresAt,
      l$orderId,
      l$paymentMethod,
      Object.hashAll(l$collectionWindows.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession ||
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
    final l$expiresAt = expiresAt;
    final lOther$expiresAt = other.expiresAt;
    if (l$expiresAt != lOther$expiresAt) {
      return false;
    }
    final l$orderId = orderId;
    final lOther$orderId = other.orderId;
    if (l$orderId != lOther$orderId) {
      return false;
    }
    final l$paymentMethod = paymentMethod;
    final lOther$paymentMethod = other.paymentMethod;
    if (l$paymentMethod != lOther$paymentMethod) {
      return false;
    }
    final l$collectionWindows = collectionWindows;
    final lOther$collectionWindows = other.collectionWindows;
    if (l$collectionWindows.length != lOther$collectionWindows.length) {
      return false;
    }
    for (int i = 0; i < l$collectionWindows.length; i++) {
      final l$collectionWindows$entry = l$collectionWindows[i];
      final lOther$collectionWindows$entry = lOther$collectionWindows[i];
      if (l$collectionWindows$entry != lOther$collectionWindows$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession
    on Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession {
  CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession<
    Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession
  >
  get copyWith =>
      CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession<
  TRes
> {
  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession(
    Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession instance,
    TRes Function(Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession)
    then,
  ) = _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession;

  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession;

  TRes call({
    String? id,
    Enum$CheckoutSessionStatus? status,
    String? expiresAt,
    String? orderId,
    Fragment$SavedCardFields? paymentMethod,
    List<
      Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
    >?
    collectionWindows,
    String? $__typename,
  });
  CopyWith$Fragment$SavedCardFields<TRes> get paymentMethod;
  TRes collectionWindows(
    Iterable<
      Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
    >
    Function(
      Iterable<
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows<
          Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession<
  TRes
>
    implements
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession<
          TRes
        > {
  _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession(
    this._instance,
    this._then,
  );

  final Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession _instance;

  final TRes Function(
    Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? expiresAt = _undefined,
    Object? orderId = _undefined,
    Object? paymentMethod = _undefined,
    Object? collectionWindows = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum$CheckoutSessionStatus),
      expiresAt: expiresAt == _undefined || expiresAt == null
          ? _instance.expiresAt
          : (expiresAt as String),
      orderId: orderId == _undefined ? _instance.orderId : (orderId as String?),
      paymentMethod: paymentMethod == _undefined
          ? _instance.paymentMethod
          : (paymentMethod as Fragment$SavedCardFields?),
      collectionWindows:
          collectionWindows == _undefined || collectionWindows == null
          ? _instance.collectionWindows
          : (collectionWindows
                as List<
                  Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
                >),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$SavedCardFields<TRes> get paymentMethod {
    final local$paymentMethod = _instance.paymentMethod;
    return local$paymentMethod == null
        ? CopyWith$Fragment$SavedCardFields.stub(_then(_instance))
        : CopyWith$Fragment$SavedCardFields(
            local$paymentMethod,
            (e) => call(paymentMethod: e),
          );
  }

  TRes collectionWindows(
    Iterable<
      Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
    >
    Function(
      Iterable<
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows<
          Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
        >
      >,
    )
    _fn,
  ) => call(
    collectionWindows: _fn(
      _instance.collectionWindows.map(
        (e) =>
            CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows(
              e,
              (i) => i,
            ),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession<
  TRes
>
    implements
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession<
          TRes
        > {
  _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    Enum$CheckoutSessionStatus? status,
    String? expiresAt,
    String? orderId,
    Fragment$SavedCardFields? paymentMethod,
    List<
      Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
    >?
    collectionWindows,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$SavedCardFields<TRes> get paymentMethod =>
      CopyWith$Fragment$SavedCardFields.stub(_res);

  collectionWindows(_fn) => _res;
}

class Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
    implements Fragment$CheckoutSessionFields$collectionWindows {
  Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows({
    required this.startsAt,
    required this.endsAt,
    this.$__typename = 'CollectionWindow',
  });

  factory Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$startsAt = json['startsAt'];
    final l$endsAt = json['endsAt'];
    final l$$__typename = json['__typename'];
    return Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows(
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
            is! Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows ||
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

extension UtilityExtension$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
    on Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows {
  CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows<
    Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
  >
  get copyWith =>
      CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows<
  TRes
> {
  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows(
    Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
    instance,
    TRes Function(
      Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows,
    )
    then,
  ) = _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows;

  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows;

  TRes call({String? startsAt, String? endsAt, String? $__typename});
}

class _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows<
  TRes
>
    implements
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows<
          TRes
        > {
  _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows(
    this._instance,
    this._then,
  );

  final Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows
  _instance;

  final TRes Function(
    Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? startsAt = _undefined,
    Object? endsAt = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows(
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

class _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows<
  TRes
>
    implements
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows<
          TRes
        > {
  _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CheckoutSession$collectionWindows(
    this._res,
  );

  TRes _res;

  call({String? startsAt, String? endsAt, String? $__typename}) => _res;
}

class Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound
    implements Mutation$SetPaymentMethod$setPaymentMethod {
  Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound({
    required this.sessionId,
    this.$__typename = 'SessionNotFound',
  });

  factory Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$sessionId = json['sessionId'];
    final l$$__typename = json['__typename'];
    return Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound(
      sessionId: (l$sessionId as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String sessionId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sessionId = sessionId;
    _resultData['sessionId'] = l$sessionId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sessionId = sessionId;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sessionId, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionId = sessionId;
    final lOther$sessionId = other.sessionId;
    if (l$sessionId != lOther$sessionId) {
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

extension UtilityExtension$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound
    on Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound {
  CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound<
    Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound
  >
  get copyWith =>
      CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound<
  TRes
> {
  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound(
    Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound instance,
    TRes Function(Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound)
    then,
  ) = _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound;

  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound;

  TRes call({String? sessionId, String? $__typename});
}

class _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound<
  TRes
>
    implements
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound<
          TRes
        > {
  _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound(
    this._instance,
    this._then,
  );

  final Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound _instance;

  final TRes Function(
    Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sessionId = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound(
      sessionId: sessionId == _undefined || sessionId == null
          ? _instance.sessionId
          : (sessionId as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound<
  TRes
>
    implements
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound<
          TRes
        > {
  _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionNotFound(
    this._res,
  );

  TRes _res;

  call({String? sessionId, String? $__typename}) => _res;
}

class Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired
    implements Mutation$SetPaymentMethod$setPaymentMethod {
  Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired({
    required this.sessionId,
    this.$__typename = 'SessionExpired',
  });

  factory Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$sessionId = json['sessionId'];
    final l$$__typename = json['__typename'];
    return Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired(
      sessionId: (l$sessionId as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String sessionId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sessionId = sessionId;
    _resultData['sessionId'] = l$sessionId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sessionId = sessionId;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sessionId, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionId = sessionId;
    final lOther$sessionId = other.sessionId;
    if (l$sessionId != lOther$sessionId) {
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

extension UtilityExtension$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired
    on Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired {
  CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired<
    Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired
  >
  get copyWith =>
      CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired<
  TRes
> {
  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired(
    Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired instance,
    TRes Function(Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired)
    then,
  ) = _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired;

  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired;

  TRes call({String? sessionId, String? $__typename});
}

class _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired<
  TRes
>
    implements
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired<
          TRes
        > {
  _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired(
    this._instance,
    this._then,
  );

  final Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired _instance;

  final TRes Function(
    Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sessionId = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired(
      sessionId: sessionId == _undefined || sessionId == null
          ? _instance.sessionId
          : (sessionId as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired<
  TRes
>
    implements
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired<
          TRes
        > {
  _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$SessionExpired(
    this._res,
  );

  TRes _res;

  call({String? sessionId, String? $__typename}) => _res;
}

class Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound
    implements Mutation$SetPaymentMethod$setPaymentMethod {
  Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound({
    required this.cardId,
    this.$__typename = 'CardNotFound',
  });

  factory Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$cardId = json['cardId'];
    final l$$__typename = json['__typename'];
    return Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound(
      cardId: (l$cardId as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String cardId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$cardId = cardId;
    _resultData['cardId'] = l$cardId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$cardId = cardId;
    final l$$__typename = $__typename;
    return Object.hashAll([l$cardId, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$cardId = cardId;
    final lOther$cardId = other.cardId;
    if (l$cardId != lOther$cardId) {
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

extension UtilityExtension$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound
    on Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound {
  CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound<
    Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound
  >
  get copyWith =>
      CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound<
  TRes
> {
  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound(
    Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound instance,
    TRes Function(Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound)
    then,
  ) = _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound;

  factory CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound;

  TRes call({String? cardId, String? $__typename});
}

class _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound<
  TRes
>
    implements
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound<
          TRes
        > {
  _CopyWithImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound(
    this._instance,
    this._then,
  );

  final Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound _instance;

  final TRes Function(Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? cardId = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound(
          cardId: cardId == _undefined || cardId == null
              ? _instance.cardId
              : (cardId as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound<
  TRes
>
    implements
        CopyWith$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound<
          TRes
        > {
  _CopyWithStubImpl$Mutation$SetPaymentMethod$setPaymentMethod$$CardNotFound(
    this._res,
  );

  TRes _res;

  call({String? cardId, String? $__typename}) => _res;
}

class Variables$Mutation$ConfirmCheckout {
  factory Variables$Mutation$ConfirmCheckout({
    required String sessionId,
    required List<String> bagIds,
    required String slotStart,
  }) => Variables$Mutation$ConfirmCheckout._({
    r'sessionId': sessionId,
    r'bagIds': bagIds,
    r'slotStart': slotStart,
  });

  Variables$Mutation$ConfirmCheckout._(this._$data);

  factory Variables$Mutation$ConfirmCheckout.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$sessionId = data['sessionId'];
    result$data['sessionId'] = (l$sessionId as String);
    final l$bagIds = data['bagIds'];
    result$data['bagIds'] = (l$bagIds as List<dynamic>)
        .map((e) => (e as String))
        .toList();
    final l$slotStart = data['slotStart'];
    result$data['slotStart'] = (l$slotStart as String);
    return Variables$Mutation$ConfirmCheckout._(result$data);
  }

  Map<String, dynamic> _$data;

  String get sessionId => (_$data['sessionId'] as String);

  List<String> get bagIds => (_$data['bagIds'] as List<String>);

  String get slotStart => (_$data['slotStart'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$sessionId = sessionId;
    result$data['sessionId'] = l$sessionId;
    final l$bagIds = bagIds;
    result$data['bagIds'] = l$bagIds.map((e) => e).toList();
    final l$slotStart = slotStart;
    result$data['slotStart'] = l$slotStart;
    return result$data;
  }

  CopyWith$Variables$Mutation$ConfirmCheckout<
    Variables$Mutation$ConfirmCheckout
  >
  get copyWith => CopyWith$Variables$Mutation$ConfirmCheckout(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$ConfirmCheckout ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionId = sessionId;
    final lOther$sessionId = other.sessionId;
    if (l$sessionId != lOther$sessionId) {
      return false;
    }
    final l$bagIds = bagIds;
    final lOther$bagIds = other.bagIds;
    if (l$bagIds.length != lOther$bagIds.length) {
      return false;
    }
    for (int i = 0; i < l$bagIds.length; i++) {
      final l$bagIds$entry = l$bagIds[i];
      final lOther$bagIds$entry = lOther$bagIds[i];
      if (l$bagIds$entry != lOther$bagIds$entry) {
        return false;
      }
    }
    final l$slotStart = slotStart;
    final lOther$slotStart = other.slotStart;
    if (l$slotStart != lOther$slotStart) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$sessionId = sessionId;
    final l$bagIds = bagIds;
    final l$slotStart = slotStart;
    return Object.hashAll([
      l$sessionId,
      Object.hashAll(l$bagIds.map((v) => v)),
      l$slotStart,
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$ConfirmCheckout<TRes> {
  factory CopyWith$Variables$Mutation$ConfirmCheckout(
    Variables$Mutation$ConfirmCheckout instance,
    TRes Function(Variables$Mutation$ConfirmCheckout) then,
  ) = _CopyWithImpl$Variables$Mutation$ConfirmCheckout;

  factory CopyWith$Variables$Mutation$ConfirmCheckout.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$ConfirmCheckout;

  TRes call({String? sessionId, List<String>? bagIds, String? slotStart});
}

class _CopyWithImpl$Variables$Mutation$ConfirmCheckout<TRes>
    implements CopyWith$Variables$Mutation$ConfirmCheckout<TRes> {
  _CopyWithImpl$Variables$Mutation$ConfirmCheckout(this._instance, this._then);

  final Variables$Mutation$ConfirmCheckout _instance;

  final TRes Function(Variables$Mutation$ConfirmCheckout) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sessionId = _undefined,
    Object? bagIds = _undefined,
    Object? slotStart = _undefined,
  }) => _then(
    Variables$Mutation$ConfirmCheckout._({
      ..._instance._$data,
      if (sessionId != _undefined && sessionId != null)
        'sessionId': (sessionId as String),
      if (bagIds != _undefined && bagIds != null)
        'bagIds': (bagIds as List<String>),
      if (slotStart != _undefined && slotStart != null)
        'slotStart': (slotStart as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$ConfirmCheckout<TRes>
    implements CopyWith$Variables$Mutation$ConfirmCheckout<TRes> {
  _CopyWithStubImpl$Variables$Mutation$ConfirmCheckout(this._res);

  TRes _res;

  call({String? sessionId, List<String>? bagIds, String? slotStart}) => _res;
}

class Mutation$ConfirmCheckout {
  Mutation$ConfirmCheckout({
    required this.confirmCheckout,
    this.$__typename = 'Mutation',
  });

  factory Mutation$ConfirmCheckout.fromJson(Map<String, dynamic> json) {
    final l$confirmCheckout = json['confirmCheckout'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmCheckout(
      confirmCheckout: Mutation$ConfirmCheckout$confirmCheckout.fromJson(
        (l$confirmCheckout as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$ConfirmCheckout$confirmCheckout confirmCheckout;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$confirmCheckout = confirmCheckout;
    _resultData['confirmCheckout'] = l$confirmCheckout.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$confirmCheckout = confirmCheckout;
    final l$$__typename = $__typename;
    return Object.hashAll([l$confirmCheckout, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmCheckout ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$confirmCheckout = confirmCheckout;
    final lOther$confirmCheckout = other.confirmCheckout;
    if (l$confirmCheckout != lOther$confirmCheckout) {
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

extension UtilityExtension$Mutation$ConfirmCheckout
    on Mutation$ConfirmCheckout {
  CopyWith$Mutation$ConfirmCheckout<Mutation$ConfirmCheckout> get copyWith =>
      CopyWith$Mutation$ConfirmCheckout(this, (i) => i);
}

abstract class CopyWith$Mutation$ConfirmCheckout<TRes> {
  factory CopyWith$Mutation$ConfirmCheckout(
    Mutation$ConfirmCheckout instance,
    TRes Function(Mutation$ConfirmCheckout) then,
  ) = _CopyWithImpl$Mutation$ConfirmCheckout;

  factory CopyWith$Mutation$ConfirmCheckout.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ConfirmCheckout;

  TRes call({
    Mutation$ConfirmCheckout$confirmCheckout? confirmCheckout,
    String? $__typename,
  });
  CopyWith$Mutation$ConfirmCheckout$confirmCheckout<TRes> get confirmCheckout;
}

class _CopyWithImpl$Mutation$ConfirmCheckout<TRes>
    implements CopyWith$Mutation$ConfirmCheckout<TRes> {
  _CopyWithImpl$Mutation$ConfirmCheckout(this._instance, this._then);

  final Mutation$ConfirmCheckout _instance;

  final TRes Function(Mutation$ConfirmCheckout) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? confirmCheckout = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ConfirmCheckout(
      confirmCheckout: confirmCheckout == _undefined || confirmCheckout == null
          ? _instance.confirmCheckout
          : (confirmCheckout as Mutation$ConfirmCheckout$confirmCheckout),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Mutation$ConfirmCheckout$confirmCheckout<TRes> get confirmCheckout {
    final local$confirmCheckout = _instance.confirmCheckout;
    return CopyWith$Mutation$ConfirmCheckout$confirmCheckout(
      local$confirmCheckout,
      (e) => call(confirmCheckout: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$ConfirmCheckout<TRes>
    implements CopyWith$Mutation$ConfirmCheckout<TRes> {
  _CopyWithStubImpl$Mutation$ConfirmCheckout(this._res);

  TRes _res;

  call({
    Mutation$ConfirmCheckout$confirmCheckout? confirmCheckout,
    String? $__typename,
  }) => _res;

  CopyWith$Mutation$ConfirmCheckout$confirmCheckout<TRes> get confirmCheckout =>
      CopyWith$Mutation$ConfirmCheckout$confirmCheckout.stub(_res);
}

const documentNodeMutationConfirmCheckout = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'ConfirmCheckout'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'sessionId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'bagIds')),
          type: ListTypeNode(
            type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'slotStart')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'confirmCheckout'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'sessionId'),
                value: VariableNode(name: NameNode(value: 'sessionId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'bagIds'),
                value: VariableNode(name: NameNode(value: 'bagIds')),
              ),
              ArgumentNode(
                name: NameNode(value: 'slotStart'),
                value: VariableNode(name: NameNode(value: 'slotStart')),
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
                      name: NameNode(value: 'SessionExpired'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'sessionId'),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'SlotUnavailable'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'slotStart'),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'PaymentMethodMissing'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'sessionId'),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'InvalidBags'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'maxBags'),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'SessionNotFound'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'sessionId'),
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
  ],
);
Mutation$ConfirmCheckout _parserFn$Mutation$ConfirmCheckout(
  Map<String, dynamic> data,
) => Mutation$ConfirmCheckout.fromJson(data);
typedef OnMutationCompleted$Mutation$ConfirmCheckout = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$ConfirmCheckout?,
);

class Options$Mutation$ConfirmCheckout
    extends graphql.MutationOptions<Mutation$ConfirmCheckout> {
  Options$Mutation$ConfirmCheckout({
    String? operationName,
    required Variables$Mutation$ConfirmCheckout variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ConfirmCheckout? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$ConfirmCheckout? onCompleted,
    graphql.OnMutationUpdate<Mutation$ConfirmCheckout>? update,
    graphql.OnError? onError,
  }) : onCompletedWithParsed = onCompleted,
       super(
         variables: variables.toJson(),
         operationName: operationName,
         fetchPolicy: fetchPolicy,
         errorPolicy: errorPolicy,
         cacheRereadPolicy: cacheRereadPolicy,
         optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
         context: context,
         onCompleted: onCompleted == null
             ? null
             : (data) => onCompleted(
                 data,
                 data == null ? null : _parserFn$Mutation$ConfirmCheckout(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationConfirmCheckout,
         parserFn: _parserFn$Mutation$ConfirmCheckout,
       );

  final OnMutationCompleted$Mutation$ConfirmCheckout? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$ConfirmCheckout
    extends graphql.WatchQueryOptions<Mutation$ConfirmCheckout> {
  WatchOptions$Mutation$ConfirmCheckout({
    String? operationName,
    required Variables$Mutation$ConfirmCheckout variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$ConfirmCheckout? typedOptimisticResult,
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
         document: documentNodeMutationConfirmCheckout,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$ConfirmCheckout,
       );
}

extension ClientExtension$Mutation$ConfirmCheckout on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$ConfirmCheckout>> mutate$ConfirmCheckout(
    Options$Mutation$ConfirmCheckout options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$ConfirmCheckout>
  watchMutation$ConfirmCheckout(
    WatchOptions$Mutation$ConfirmCheckout options,
  ) => this.watchMutation(options);
}

class Mutation$ConfirmCheckout$confirmCheckout {
  Mutation$ConfirmCheckout$confirmCheckout({required this.$__typename});

  factory Mutation$ConfirmCheckout$confirmCheckout.fromJson(
    Map<String, dynamic> json,
  ) {
    switch (json["__typename"] as String) {
      case "Order":
        return Mutation$ConfirmCheckout$confirmCheckout$$Order.fromJson(json);

      case "SessionExpired":
        return Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired.fromJson(
          json,
        );

      case "SlotUnavailable":
        return Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable.fromJson(
          json,
        );

      case "PaymentMethodMissing":
        return Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing.fromJson(
          json,
        );

      case "InvalidBags":
        return Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags.fromJson(
          json,
        );

      case "SessionNotFound":
        return Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound.fromJson(
          json,
        );

      default:
        final l$$__typename = json['__typename'];
        return Mutation$ConfirmCheckout$confirmCheckout(
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
    if (other is! Mutation$ConfirmCheckout$confirmCheckout ||
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

extension UtilityExtension$Mutation$ConfirmCheckout$confirmCheckout
    on Mutation$ConfirmCheckout$confirmCheckout {
  CopyWith$Mutation$ConfirmCheckout$confirmCheckout<
    Mutation$ConfirmCheckout$confirmCheckout
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmCheckout$confirmCheckout(this, (i) => i);

  _T when<_T>({
    required _T Function(Mutation$ConfirmCheckout$confirmCheckout$$Order) order,
    required _T Function(
      Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired,
    )
    sessionExpired,
    required _T Function(
      Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable,
    )
    slotUnavailable,
    required _T Function(
      Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing,
    )
    paymentMethodMissing,
    required _T Function(Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags)
    invalidBags,
    required _T Function(
      Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound,
    )
    sessionNotFound,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Order":
        return order(this as Mutation$ConfirmCheckout$confirmCheckout$$Order);

      case "SessionExpired":
        return sessionExpired(
          this as Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired,
        );

      case "SlotUnavailable":
        return slotUnavailable(
          this as Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable,
        );

      case "PaymentMethodMissing":
        return paymentMethodMissing(
          this
              as Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing,
        );

      case "InvalidBags":
        return invalidBags(
          this as Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags,
        );

      case "SessionNotFound":
        return sessionNotFound(
          this as Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound,
        );

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$ConfirmCheckout$confirmCheckout$$Order)? order,
    _T Function(Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired)?
    sessionExpired,
    _T Function(Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable)?
    slotUnavailable,
    _T Function(Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing)?
    paymentMethodMissing,
    _T Function(Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags)?
    invalidBags,
    _T Function(Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound)?
    sessionNotFound,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Order":
        if (order != null) {
          return order(this as Mutation$ConfirmCheckout$confirmCheckout$$Order);
        } else {
          return orElse();
        }

      case "SessionExpired":
        if (sessionExpired != null) {
          return sessionExpired(
            this as Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired,
          );
        } else {
          return orElse();
        }

      case "SlotUnavailable":
        if (slotUnavailable != null) {
          return slotUnavailable(
            this as Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable,
          );
        } else {
          return orElse();
        }

      case "PaymentMethodMissing":
        if (paymentMethodMissing != null) {
          return paymentMethodMissing(
            this
                as Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing,
          );
        } else {
          return orElse();
        }

      case "InvalidBags":
        if (invalidBags != null) {
          return invalidBags(
            this as Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags,
          );
        } else {
          return orElse();
        }

      case "SessionNotFound":
        if (sessionNotFound != null) {
          return sessionNotFound(
            this as Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound,
          );
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Mutation$ConfirmCheckout$confirmCheckout<TRes> {
  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout(
    Mutation$ConfirmCheckout$confirmCheckout instance,
    TRes Function(Mutation$ConfirmCheckout$confirmCheckout) then,
  ) = _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout;

  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout.stub(TRes res) =
      _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout<TRes>
    implements CopyWith$Mutation$ConfirmCheckout$confirmCheckout<TRes> {
  _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmCheckout$confirmCheckout _instance;

  final TRes Function(Mutation$ConfirmCheckout$confirmCheckout) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation$ConfirmCheckout$confirmCheckout(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout<TRes>
    implements CopyWith$Mutation$ConfirmCheckout$confirmCheckout<TRes> {
  _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation$ConfirmCheckout$confirmCheckout$$Order
    implements Mutation$ConfirmCheckout$confirmCheckout {
  Mutation$ConfirmCheckout$confirmCheckout$$Order({
    required this.id,
    required this.status,
    this.$__typename = 'Order',
  });

  factory Mutation$ConfirmCheckout$confirmCheckout$$Order.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$status = json['status'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmCheckout$confirmCheckout$$Order(
      id: (l$id as String),
      status: fromJson$Enum$OrderStatus((l$status as String)),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$OrderStatus status;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$status = status;
    _resultData['status'] = toJson$Enum$OrderStatus(l$status);
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$status = status;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$status, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmCheckout$confirmCheckout$$Order ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Mutation$ConfirmCheckout$confirmCheckout$$Order
    on Mutation$ConfirmCheckout$confirmCheckout$$Order {
  CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$Order<
    Mutation$ConfirmCheckout$confirmCheckout$$Order
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$Order(this, (i) => i);
}

abstract class CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$Order<TRes> {
  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$Order(
    Mutation$ConfirmCheckout$confirmCheckout$$Order instance,
    TRes Function(Mutation$ConfirmCheckout$confirmCheckout$$Order) then,
  ) = _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$Order;

  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$Order.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$Order;

  TRes call({String? id, Enum$OrderStatus? status, String? $__typename});
}

class _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$Order<TRes>
    implements CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$Order<TRes> {
  _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$Order(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmCheckout$confirmCheckout$$Order _instance;

  final TRes Function(Mutation$ConfirmCheckout$confirmCheckout$$Order) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? status = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ConfirmCheckout$confirmCheckout$$Order(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      status: status == _undefined || status == null
          ? _instance.status
          : (status as Enum$OrderStatus),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$Order<TRes>
    implements CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$Order<TRes> {
  _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$Order(this._res);

  TRes _res;

  call({String? id, Enum$OrderStatus? status, String? $__typename}) => _res;
}

class Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired
    implements Mutation$ConfirmCheckout$confirmCheckout {
  Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired({
    required this.sessionId,
    this.$__typename = 'SessionExpired',
  });

  factory Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$sessionId = json['sessionId'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired(
      sessionId: (l$sessionId as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String sessionId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sessionId = sessionId;
    _resultData['sessionId'] = l$sessionId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sessionId = sessionId;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sessionId, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionId = sessionId;
    final lOther$sessionId = other.sessionId;
    if (l$sessionId != lOther$sessionId) {
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

extension UtilityExtension$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired
    on Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired {
  CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired<
    Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired<
  TRes
> {
  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired(
    Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired instance,
    TRes Function(Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired)
    then,
  ) = _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired;

  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired;

  TRes call({String? sessionId, String? $__typename});
}

class _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired<
          TRes
        > {
  _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired _instance;

  final TRes Function(Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sessionId = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired(
      sessionId: sessionId == _undefined || sessionId == null
          ? _instance.sessionId
          : (sessionId as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionExpired(
    this._res,
  );

  TRes _res;

  call({String? sessionId, String? $__typename}) => _res;
}

class Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable
    implements Mutation$ConfirmCheckout$confirmCheckout {
  Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable({
    required this.slotStart,
    this.$__typename = 'SlotUnavailable',
  });

  factory Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$slotStart = json['slotStart'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable(
      slotStart: (l$slotStart as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String slotStart;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$slotStart = slotStart;
    _resultData['slotStart'] = l$slotStart;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$slotStart = slotStart;
    final l$$__typename = $__typename;
    return Object.hashAll([l$slotStart, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$slotStart = slotStart;
    final lOther$slotStart = other.slotStart;
    if (l$slotStart != lOther$slotStart) {
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

extension UtilityExtension$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable
    on Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable {
  CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable<
    Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable<
  TRes
> {
  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable(
    Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable instance,
    TRes Function(Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable)
    then,
  ) = _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable;

  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable;

  TRes call({String? slotStart, String? $__typename});
}

class _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable<
          TRes
        > {
  _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable _instance;

  final TRes Function(Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? slotStart = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable(
      slotStart: slotStart == _undefined || slotStart == null
          ? _instance.slotStart
          : (slotStart as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$SlotUnavailable(
    this._res,
  );

  TRes _res;

  call({String? slotStart, String? $__typename}) => _res;
}

class Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing
    implements Mutation$ConfirmCheckout$confirmCheckout {
  Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing({
    required this.sessionId,
    this.$__typename = 'PaymentMethodMissing',
  });

  factory Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$sessionId = json['sessionId'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing(
      sessionId: (l$sessionId as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String sessionId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sessionId = sessionId;
    _resultData['sessionId'] = l$sessionId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sessionId = sessionId;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sessionId, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionId = sessionId;
    final lOther$sessionId = other.sessionId;
    if (l$sessionId != lOther$sessionId) {
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

extension UtilityExtension$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing
    on Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing {
  CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing<
    Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing<
  TRes
> {
  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing(
    Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing instance,
    TRes Function(
      Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing,
    )
    then,
  ) = _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing;

  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing;

  TRes call({String? sessionId, String? $__typename});
}

class _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing<
          TRes
        > {
  _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing
  _instance;

  final TRes Function(
    Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sessionId = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing(
      sessionId: sessionId == _undefined || sessionId == null
          ? _instance.sessionId
          : (sessionId as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$PaymentMethodMissing(
    this._res,
  );

  TRes _res;

  call({String? sessionId, String? $__typename}) => _res;
}

class Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags
    implements Mutation$ConfirmCheckout$confirmCheckout {
  Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags({
    required this.maxBags,
    this.$__typename = 'InvalidBags',
  });

  factory Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$maxBags = json['maxBags'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags(
      maxBags: (l$maxBags as int),
      $__typename: (l$$__typename as String),
    );
  }

  final int maxBags;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$maxBags = maxBags;
    _resultData['maxBags'] = l$maxBags;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$maxBags = maxBags;
    final l$$__typename = $__typename;
    return Object.hashAll([l$maxBags, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$maxBags = maxBags;
    final lOther$maxBags = other.maxBags;
    if (l$maxBags != lOther$maxBags) {
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

extension UtilityExtension$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags
    on Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags {
  CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags<
    Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags<
  TRes
> {
  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags(
    Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags instance,
    TRes Function(Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags) then,
  ) = _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags;

  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags;

  TRes call({int? maxBags, String? $__typename});
}

class _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags<TRes>
    implements
        CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags<TRes> {
  _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags _instance;

  final TRes Function(Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? maxBags = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags(
          maxBags: maxBags == _undefined || maxBags == null
              ? _instance.maxBags
              : (maxBags as int),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags<TRes> {
  _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$InvalidBags(
    this._res,
  );

  TRes _res;

  call({int? maxBags, String? $__typename}) => _res;
}

class Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound
    implements Mutation$ConfirmCheckout$confirmCheckout {
  Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound({
    required this.sessionId,
    this.$__typename = 'SessionNotFound',
  });

  factory Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$sessionId = json['sessionId'];
    final l$$__typename = json['__typename'];
    return Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound(
      sessionId: (l$sessionId as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String sessionId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$sessionId = sessionId;
    _resultData['sessionId'] = l$sessionId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$sessionId = sessionId;
    final l$$__typename = $__typename;
    return Object.hashAll([l$sessionId, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$sessionId = sessionId;
    final lOther$sessionId = other.sessionId;
    if (l$sessionId != lOther$sessionId) {
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

extension UtilityExtension$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound
    on Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound {
  CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound<
    Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound
  >
  get copyWith =>
      CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound<
  TRes
> {
  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound(
    Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound instance,
    TRes Function(Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound)
    then,
  ) = _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound;

  factory CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound.stub(
    TRes res,
  ) = _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound;

  TRes call({String? sessionId, String? $__typename});
}

class _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound<
          TRes
        > {
  _CopyWithImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound(
    this._instance,
    this._then,
  );

  final Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound _instance;

  final TRes Function(Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? sessionId = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound(
      sessionId: sessionId == _undefined || sessionId == null
          ? _instance.sessionId
          : (sessionId as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound<
  TRes
>
    implements
        CopyWith$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound<
          TRes
        > {
  _CopyWithStubImpl$Mutation$ConfirmCheckout$confirmCheckout$$SessionNotFound(
    this._res,
  );

  TRes _res;

  call({String? sessionId, String? $__typename}) => _res;
}
