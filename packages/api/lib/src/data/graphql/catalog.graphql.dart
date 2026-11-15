import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Fragment$BagFields {
  Fragment$BagFields({
    required this.id,
    required this.name,
    required this.description,
    required this.priceCents,
    required this.worthCents,
    required this.store,
    this.$__typename = 'Bag',
  });

  factory Fragment$BagFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$description = json['description'];
    final l$priceCents = json['priceCents'];
    final l$worthCents = json['worthCents'];
    final l$store = json['store'];
    final l$$__typename = json['__typename'];
    return Fragment$BagFields(
      id: (l$id as String),
      name: (l$name as String),
      description: (l$description as String),
      priceCents: (l$priceCents as int),
      worthCents: (l$worthCents as int),
      store: Fragment$BagFields$store.fromJson(
        (l$store as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String description;

  final int priceCents;

  final int worthCents;

  final Fragment$BagFields$store store;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$description = description;
    _resultData['description'] = l$description;
    final l$priceCents = priceCents;
    _resultData['priceCents'] = l$priceCents;
    final l$worthCents = worthCents;
    _resultData['worthCents'] = l$worthCents;
    final l$store = store;
    _resultData['store'] = l$store.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$description = description;
    final l$priceCents = priceCents;
    final l$worthCents = worthCents;
    final l$store = store;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$description,
      l$priceCents,
      l$worthCents,
      l$store,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$BagFields || runtimeType != other.runtimeType) {
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
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
      return false;
    }
    final l$priceCents = priceCents;
    final lOther$priceCents = other.priceCents;
    if (l$priceCents != lOther$priceCents) {
      return false;
    }
    final l$worthCents = worthCents;
    final lOther$worthCents = other.worthCents;
    if (l$worthCents != lOther$worthCents) {
      return false;
    }
    final l$store = store;
    final lOther$store = other.store;
    if (l$store != lOther$store) {
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

extension UtilityExtension$Fragment$BagFields on Fragment$BagFields {
  CopyWith$Fragment$BagFields<Fragment$BagFields> get copyWith =>
      CopyWith$Fragment$BagFields(this, (i) => i);
}

abstract class CopyWith$Fragment$BagFields<TRes> {
  factory CopyWith$Fragment$BagFields(
    Fragment$BagFields instance,
    TRes Function(Fragment$BagFields) then,
  ) = _CopyWithImpl$Fragment$BagFields;

  factory CopyWith$Fragment$BagFields.stub(TRes res) =
      _CopyWithStubImpl$Fragment$BagFields;

  TRes call({
    String? id,
    String? name,
    String? description,
    int? priceCents,
    int? worthCents,
    Fragment$BagFields$store? store,
    String? $__typename,
  });
  CopyWith$Fragment$BagFields$store<TRes> get store;
}

class _CopyWithImpl$Fragment$BagFields<TRes>
    implements CopyWith$Fragment$BagFields<TRes> {
  _CopyWithImpl$Fragment$BagFields(this._instance, this._then);

  final Fragment$BagFields _instance;

  final TRes Function(Fragment$BagFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? description = _undefined,
    Object? priceCents = _undefined,
    Object? worthCents = _undefined,
    Object? store = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$BagFields(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      description: description == _undefined || description == null
          ? _instance.description
          : (description as String),
      priceCents: priceCents == _undefined || priceCents == null
          ? _instance.priceCents
          : (priceCents as int),
      worthCents: worthCents == _undefined || worthCents == null
          ? _instance.worthCents
          : (worthCents as int),
      store: store == _undefined || store == null
          ? _instance.store
          : (store as Fragment$BagFields$store),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$BagFields$store<TRes> get store {
    final local$store = _instance.store;
    return CopyWith$Fragment$BagFields$store(
      local$store,
      (e) => call(store: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$BagFields<TRes>
    implements CopyWith$Fragment$BagFields<TRes> {
  _CopyWithStubImpl$Fragment$BagFields(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? description,
    int? priceCents,
    int? worthCents,
    Fragment$BagFields$store? store,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$BagFields$store<TRes> get store =>
      CopyWith$Fragment$BagFields$store.stub(_res);
}

const fragmentDefinitionBagFields = FragmentDefinitionNode(
  name: NameNode(value: 'BagFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Bag'), isNonNull: false),
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
        name: NameNode(value: 'name'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'description'),
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
        name: NameNode(value: 'worthCents'),
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
const documentNodeFragmentBagFields = DocumentNode(
  definitions: [fragmentDefinitionBagFields],
);

extension ClientExtension$Fragment$BagFields on graphql.GraphQLClient {
  void writeFragment$BagFields({
    required Fragment$BagFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'BagFields',
        document: documentNodeFragmentBagFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$BagFields? readFragment$BagFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'BagFields',
          document: documentNodeFragmentBagFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$BagFields.fromJson(result);
  }
}

class Fragment$BagFields$store {
  Fragment$BagFields$store({
    required this.id,
    required this.name,
    this.$__typename = 'Store',
  });

  factory Fragment$BagFields$store.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$BagFields$store(
      id: (l$id as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$BagFields$store ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$BagFields$store
    on Fragment$BagFields$store {
  CopyWith$Fragment$BagFields$store<Fragment$BagFields$store> get copyWith =>
      CopyWith$Fragment$BagFields$store(this, (i) => i);
}

abstract class CopyWith$Fragment$BagFields$store<TRes> {
  factory CopyWith$Fragment$BagFields$store(
    Fragment$BagFields$store instance,
    TRes Function(Fragment$BagFields$store) then,
  ) = _CopyWithImpl$Fragment$BagFields$store;

  factory CopyWith$Fragment$BagFields$store.stub(TRes res) =
      _CopyWithStubImpl$Fragment$BagFields$store;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Fragment$BagFields$store<TRes>
    implements CopyWith$Fragment$BagFields$store<TRes> {
  _CopyWithImpl$Fragment$BagFields$store(this._instance, this._then);

  final Fragment$BagFields$store _instance;

  final TRes Function(Fragment$BagFields$store) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$BagFields$store(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$BagFields$store<TRes>
    implements CopyWith$Fragment$BagFields$store<TRes> {
  _CopyWithStubImpl$Fragment$BagFields$store(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$Bags {
  Query$Bags({required this.bags, this.$__typename = 'Query'});

  factory Query$Bags.fromJson(Map<String, dynamic> json) {
    final l$bags = json['bags'];
    final l$$__typename = json['__typename'];
    return Query$Bags(
      bags: (l$bags as List<dynamic>)
          .map((e) => Fragment$BagFields.fromJson((e as Map<String, dynamic>)))
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$BagFields> bags;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$bags = bags;
    _resultData['bags'] = l$bags.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$bags = bags;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$bags.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Bags || runtimeType != other.runtimeType) {
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Bags on Query$Bags {
  CopyWith$Query$Bags<Query$Bags> get copyWith =>
      CopyWith$Query$Bags(this, (i) => i);
}

abstract class CopyWith$Query$Bags<TRes> {
  factory CopyWith$Query$Bags(
    Query$Bags instance,
    TRes Function(Query$Bags) then,
  ) = _CopyWithImpl$Query$Bags;

  factory CopyWith$Query$Bags.stub(TRes res) = _CopyWithStubImpl$Query$Bags;

  TRes call({List<Fragment$BagFields>? bags, String? $__typename});
  TRes bags(
    Iterable<Fragment$BagFields> Function(
      Iterable<CopyWith$Fragment$BagFields<Fragment$BagFields>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$Bags<TRes> implements CopyWith$Query$Bags<TRes> {
  _CopyWithImpl$Query$Bags(this._instance, this._then);

  final Query$Bags _instance;

  final TRes Function(Query$Bags) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? bags = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$Bags(
          bags: bags == _undefined || bags == null
              ? _instance.bags
              : (bags as List<Fragment$BagFields>),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  TRes bags(
    Iterable<Fragment$BagFields> Function(
      Iterable<CopyWith$Fragment$BagFields<Fragment$BagFields>>,
    )
    _fn,
  ) => call(
    bags: _fn(
      _instance.bags.map((e) => CopyWith$Fragment$BagFields(e, (i) => i)),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$Bags<TRes> implements CopyWith$Query$Bags<TRes> {
  _CopyWithStubImpl$Query$Bags(this._res);

  TRes _res;

  call({List<Fragment$BagFields>? bags, String? $__typename}) => _res;

  bags(_fn) => _res;
}

const documentNodeQueryBags = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Bags'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'bags'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'BagFields'),
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
    fragmentDefinitionBagFields,
  ],
);
Query$Bags _parserFn$Query$Bags(Map<String, dynamic> data) =>
    Query$Bags.fromJson(data);
typedef OnQueryComplete$Query$Bags = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$Bags?,
);

class Options$Query$Bags extends graphql.QueryOptions<Query$Bags> {
  Options$Query$Bags({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Bags? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$Bags? onComplete,
    graphql.OnQueryError? onError,
  }) : onCompleteWithParsed = onComplete,
       super(
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
                 data == null ? null : _parserFn$Query$Bags(data),
               ),
         onError: onError,
         document: documentNodeQueryBags,
         parserFn: _parserFn$Query$Bags,
       );

  final OnQueryComplete$Query$Bags? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$Bags extends graphql.WatchQueryOptions<Query$Bags> {
  WatchOptions$Query$Bags({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Bags? typedOptimisticResult,
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
         document: documentNodeQueryBags,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$Bags,
       );
}

class FetchMoreOptions$Query$Bags extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Bags({required graphql.UpdateQuery updateQuery})
    : super(updateQuery: updateQuery, document: documentNodeQueryBags);
}

extension ClientExtension$Query$Bags on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Bags>> query$Bags([
    Options$Query$Bags? options,
  ]) async => await this.query(options ?? Options$Query$Bags());

  graphql.ObservableQuery<Query$Bags> watchQuery$Bags([
    WatchOptions$Query$Bags? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$Bags());

  void writeQuery$Bags({required Query$Bags data, bool broadcast = true}) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryBags),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$Bags? readQuery$Bags({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryBags),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$Bags.fromJson(result);
  }
}
