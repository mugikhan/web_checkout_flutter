import 'dart:async';

import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Fragment$ViewerFields {
  Fragment$ViewerFields({
    required this.id,
    required this.name,
    this.$__typename = 'Viewer',
  });

  factory Fragment$ViewerFields.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$ViewerFields(
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
    if (other is! Fragment$ViewerFields || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Fragment$ViewerFields on Fragment$ViewerFields {
  CopyWith$Fragment$ViewerFields<Fragment$ViewerFields> get copyWith =>
      CopyWith$Fragment$ViewerFields(this, (i) => i);
}

abstract class CopyWith$Fragment$ViewerFields<TRes> {
  factory CopyWith$Fragment$ViewerFields(
    Fragment$ViewerFields instance,
    TRes Function(Fragment$ViewerFields) then,
  ) = _CopyWithImpl$Fragment$ViewerFields;

  factory CopyWith$Fragment$ViewerFields.stub(TRes res) =
      _CopyWithStubImpl$Fragment$ViewerFields;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Fragment$ViewerFields<TRes>
    implements CopyWith$Fragment$ViewerFields<TRes> {
  _CopyWithImpl$Fragment$ViewerFields(this._instance, this._then);

  final Fragment$ViewerFields _instance;

  final TRes Function(Fragment$ViewerFields) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$ViewerFields(
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

class _CopyWithStubImpl$Fragment$ViewerFields<TRes>
    implements CopyWith$Fragment$ViewerFields<TRes> {
  _CopyWithStubImpl$Fragment$ViewerFields(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

const fragmentDefinitionViewerFields = FragmentDefinitionNode(
  name: NameNode(value: 'ViewerFields'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Viewer'), isNonNull: false),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentViewerFields = DocumentNode(
  definitions: [fragmentDefinitionViewerFields],
);

extension ClientExtension$Fragment$ViewerFields on graphql.GraphQLClient {
  void writeFragment$ViewerFields({
    required Fragment$ViewerFields data,
    required Map<String, dynamic> idFields,
    bool broadcast = true,
  }) => this.writeFragment(
    graphql.FragmentRequest(
      idFields: idFields,
      fragment: const graphql.Fragment(
        fragmentName: 'ViewerFields',
        document: documentNodeFragmentViewerFields,
      ),
    ),
    data: data.toJson(),
    broadcast: broadcast,
  );

  Fragment$ViewerFields? readFragment$ViewerFields({
    required Map<String, dynamic> idFields,
    bool optimistic = true,
  }) {
    final result = this.readFragment(
      graphql.FragmentRequest(
        idFields: idFields,
        fragment: const graphql.Fragment(
          fragmentName: 'ViewerFields',
          document: documentNodeFragmentViewerFields,
        ),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Fragment$ViewerFields.fromJson(result);
  }
}

class Variables$Mutation$SignIn {
  factory Variables$Mutation$SignIn({required String name}) =>
      Variables$Mutation$SignIn._({r'name': name});

  Variables$Mutation$SignIn._(this._$data);

  factory Variables$Mutation$SignIn.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    return Variables$Mutation$SignIn._(result$data);
  }

  Map<String, dynamic> _$data;

  String get name => (_$data['name'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$name = name;
    result$data['name'] = l$name;
    return result$data;
  }

  CopyWith$Variables$Mutation$SignIn<Variables$Mutation$SignIn> get copyWith =>
      CopyWith$Variables$Mutation$SignIn(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$SignIn ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$name = name;
    return Object.hashAll([l$name]);
  }
}

abstract class CopyWith$Variables$Mutation$SignIn<TRes> {
  factory CopyWith$Variables$Mutation$SignIn(
    Variables$Mutation$SignIn instance,
    TRes Function(Variables$Mutation$SignIn) then,
  ) = _CopyWithImpl$Variables$Mutation$SignIn;

  factory CopyWith$Variables$Mutation$SignIn.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$SignIn;

  TRes call({String? name});
}

class _CopyWithImpl$Variables$Mutation$SignIn<TRes>
    implements CopyWith$Variables$Mutation$SignIn<TRes> {
  _CopyWithImpl$Variables$Mutation$SignIn(this._instance, this._then);

  final Variables$Mutation$SignIn _instance;

  final TRes Function(Variables$Mutation$SignIn) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? name = _undefined}) => _then(
    Variables$Mutation$SignIn._({
      ..._instance._$data,
      if (name != _undefined && name != null) 'name': (name as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$SignIn<TRes>
    implements CopyWith$Variables$Mutation$SignIn<TRes> {
  _CopyWithStubImpl$Variables$Mutation$SignIn(this._res);

  TRes _res;

  call({String? name}) => _res;
}

class Mutation$SignIn {
  Mutation$SignIn({required this.signIn, this.$__typename = 'Mutation'});

  factory Mutation$SignIn.fromJson(Map<String, dynamic> json) {
    final l$signIn = json['signIn'];
    final l$$__typename = json['__typename'];
    return Mutation$SignIn(
      signIn: Mutation$SignIn$signIn.fromJson(
        (l$signIn as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Mutation$SignIn$signIn signIn;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$signIn = signIn;
    _resultData['signIn'] = l$signIn.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$signIn = signIn;
    final l$$__typename = $__typename;
    return Object.hashAll([l$signIn, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SignIn || runtimeType != other.runtimeType) {
      return false;
    }
    final l$signIn = signIn;
    final lOther$signIn = other.signIn;
    if (l$signIn != lOther$signIn) {
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

extension UtilityExtension$Mutation$SignIn on Mutation$SignIn {
  CopyWith$Mutation$SignIn<Mutation$SignIn> get copyWith =>
      CopyWith$Mutation$SignIn(this, (i) => i);
}

abstract class CopyWith$Mutation$SignIn<TRes> {
  factory CopyWith$Mutation$SignIn(
    Mutation$SignIn instance,
    TRes Function(Mutation$SignIn) then,
  ) = _CopyWithImpl$Mutation$SignIn;

  factory CopyWith$Mutation$SignIn.stub(TRes res) =
      _CopyWithStubImpl$Mutation$SignIn;

  TRes call({Mutation$SignIn$signIn? signIn, String? $__typename});
  CopyWith$Mutation$SignIn$signIn<TRes> get signIn;
}

class _CopyWithImpl$Mutation$SignIn<TRes>
    implements CopyWith$Mutation$SignIn<TRes> {
  _CopyWithImpl$Mutation$SignIn(this._instance, this._then);

  final Mutation$SignIn _instance;

  final TRes Function(Mutation$SignIn) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? signIn = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Mutation$SignIn(
          signIn: signIn == _undefined || signIn == null
              ? _instance.signIn
              : (signIn as Mutation$SignIn$signIn),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Mutation$SignIn$signIn<TRes> get signIn {
    final local$signIn = _instance.signIn;
    return CopyWith$Mutation$SignIn$signIn(
      local$signIn,
      (e) => call(signIn: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$SignIn<TRes>
    implements CopyWith$Mutation$SignIn<TRes> {
  _CopyWithStubImpl$Mutation$SignIn(this._res);

  TRes _res;

  call({Mutation$SignIn$signIn? signIn, String? $__typename}) => _res;

  CopyWith$Mutation$SignIn$signIn<TRes> get signIn =>
      CopyWith$Mutation$SignIn$signIn.stub(_res);
}

const documentNodeMutationSignIn = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'SignIn'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'name')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'signIn'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'name'),
                value: VariableNode(name: NameNode(value: 'name')),
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
                      name: NameNode(value: 'SignInSuccess'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'token'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'viewer'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'ViewerFields'),
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
                InlineFragmentNode(
                  typeCondition: TypeConditionNode(
                    on: NamedTypeNode(
                      name: NameNode(value: 'InvalidName'),
                      isNonNull: false,
                    ),
                  ),
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'minLength'),
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
    fragmentDefinitionViewerFields,
  ],
);
Mutation$SignIn _parserFn$Mutation$SignIn(Map<String, dynamic> data) =>
    Mutation$SignIn.fromJson(data);
typedef OnMutationCompleted$Mutation$SignIn = FutureOr<void> Function(
  Map<String, dynamic>?,
  Mutation$SignIn?,
);

class Options$Mutation$SignIn extends graphql.MutationOptions<Mutation$SignIn> {
  Options$Mutation$SignIn({
    String? operationName,
    required Variables$Mutation$SignIn variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SignIn? typedOptimisticResult,
    graphql.Context? context,
    OnMutationCompleted$Mutation$SignIn? onCompleted,
    graphql.OnMutationUpdate<Mutation$SignIn>? update,
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
                 data == null ? null : _parserFn$Mutation$SignIn(data),
               ),
         update: update,
         onError: onError,
         document: documentNodeMutationSignIn,
         parserFn: _parserFn$Mutation$SignIn,
       );

  final OnMutationCompleted$Mutation$SignIn? onCompletedWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onCompleted == null
        ? super.properties
        : super.properties.where((property) => property != onCompleted),
    onCompletedWithParsed,
  ];
}

class WatchOptions$Mutation$SignIn
    extends graphql.WatchQueryOptions<Mutation$SignIn> {
  WatchOptions$Mutation$SignIn({
    String? operationName,
    required Variables$Mutation$SignIn variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Mutation$SignIn? typedOptimisticResult,
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
         document: documentNodeMutationSignIn,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Mutation$SignIn,
       );
}

extension ClientExtension$Mutation$SignIn on graphql.GraphQLClient {
  Future<graphql.QueryResult<Mutation$SignIn>> mutate$SignIn(
    Options$Mutation$SignIn options,
  ) async => await this.mutate(options);

  graphql.ObservableQuery<Mutation$SignIn> watchMutation$SignIn(
    WatchOptions$Mutation$SignIn options,
  ) => this.watchMutation(options);
}

class Mutation$SignIn$signIn {
  Mutation$SignIn$signIn({required this.$__typename});

  factory Mutation$SignIn$signIn.fromJson(Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "SignInSuccess":
        return Mutation$SignIn$signIn$$SignInSuccess.fromJson(json);

      case "InvalidName":
        return Mutation$SignIn$signIn$$InvalidName.fromJson(json);

      default:
        final l$$__typename = json['__typename'];
        return Mutation$SignIn$signIn($__typename: (l$$__typename as String));
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
    if (other is! Mutation$SignIn$signIn || runtimeType != other.runtimeType) {
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

extension UtilityExtension$Mutation$SignIn$signIn on Mutation$SignIn$signIn {
  CopyWith$Mutation$SignIn$signIn<Mutation$SignIn$signIn> get copyWith =>
      CopyWith$Mutation$SignIn$signIn(this, (i) => i);

  _T when<_T>({
    required _T Function(Mutation$SignIn$signIn$$SignInSuccess) signInSuccess,
    required _T Function(Mutation$SignIn$signIn$$InvalidName) invalidName,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "SignInSuccess":
        return signInSuccess(this as Mutation$SignIn$signIn$$SignInSuccess);

      case "InvalidName":
        return invalidName(this as Mutation$SignIn$signIn$$InvalidName);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Mutation$SignIn$signIn$$SignInSuccess)? signInSuccess,
    _T Function(Mutation$SignIn$signIn$$InvalidName)? invalidName,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "SignInSuccess":
        if (signInSuccess != null) {
          return signInSuccess(this as Mutation$SignIn$signIn$$SignInSuccess);
        } else {
          return orElse();
        }

      case "InvalidName":
        if (invalidName != null) {
          return invalidName(this as Mutation$SignIn$signIn$$InvalidName);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Mutation$SignIn$signIn<TRes> {
  factory CopyWith$Mutation$SignIn$signIn(
    Mutation$SignIn$signIn instance,
    TRes Function(Mutation$SignIn$signIn) then,
  ) = _CopyWithImpl$Mutation$SignIn$signIn;

  factory CopyWith$Mutation$SignIn$signIn.stub(TRes res) =
      _CopyWithStubImpl$Mutation$SignIn$signIn;

  TRes call({String? $__typename});
}

class _CopyWithImpl$Mutation$SignIn$signIn<TRes>
    implements CopyWith$Mutation$SignIn$signIn<TRes> {
  _CopyWithImpl$Mutation$SignIn$signIn(this._instance, this._then);

  final Mutation$SignIn$signIn _instance;

  final TRes Function(Mutation$SignIn$signIn) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? $__typename = _undefined}) => _then(
    Mutation$SignIn$signIn(
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$SignIn$signIn<TRes>
    implements CopyWith$Mutation$SignIn$signIn<TRes> {
  _CopyWithStubImpl$Mutation$SignIn$signIn(this._res);

  TRes _res;

  call({String? $__typename}) => _res;
}

class Mutation$SignIn$signIn$$SignInSuccess implements Mutation$SignIn$signIn {
  Mutation$SignIn$signIn$$SignInSuccess({
    required this.token,
    required this.viewer,
    this.$__typename = 'SignInSuccess',
  });

  factory Mutation$SignIn$signIn$$SignInSuccess.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$token = json['token'];
    final l$viewer = json['viewer'];
    final l$$__typename = json['__typename'];
    return Mutation$SignIn$signIn$$SignInSuccess(
      token: (l$token as String),
      viewer: Fragment$ViewerFields.fromJson(
        (l$viewer as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String token;

  final Fragment$ViewerFields viewer;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$token = token;
    _resultData['token'] = l$token;
    final l$viewer = viewer;
    _resultData['viewer'] = l$viewer.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$token = token;
    final l$viewer = viewer;
    final l$$__typename = $__typename;
    return Object.hashAll([l$token, l$viewer, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SignIn$signIn$$SignInSuccess ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$token = token;
    final lOther$token = other.token;
    if (l$token != lOther$token) {
      return false;
    }
    final l$viewer = viewer;
    final lOther$viewer = other.viewer;
    if (l$viewer != lOther$viewer) {
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

extension UtilityExtension$Mutation$SignIn$signIn$$SignInSuccess
    on Mutation$SignIn$signIn$$SignInSuccess {
  CopyWith$Mutation$SignIn$signIn$$SignInSuccess<
    Mutation$SignIn$signIn$$SignInSuccess
  >
  get copyWith =>
      CopyWith$Mutation$SignIn$signIn$$SignInSuccess(this, (i) => i);
}

abstract class CopyWith$Mutation$SignIn$signIn$$SignInSuccess<TRes> {
  factory CopyWith$Mutation$SignIn$signIn$$SignInSuccess(
    Mutation$SignIn$signIn$$SignInSuccess instance,
    TRes Function(Mutation$SignIn$signIn$$SignInSuccess) then,
  ) = _CopyWithImpl$Mutation$SignIn$signIn$$SignInSuccess;

  factory CopyWith$Mutation$SignIn$signIn$$SignInSuccess.stub(TRes res) =
      _CopyWithStubImpl$Mutation$SignIn$signIn$$SignInSuccess;

  TRes call({
    String? token,
    Fragment$ViewerFields? viewer,
    String? $__typename,
  });
  CopyWith$Fragment$ViewerFields<TRes> get viewer;
}

class _CopyWithImpl$Mutation$SignIn$signIn$$SignInSuccess<TRes>
    implements CopyWith$Mutation$SignIn$signIn$$SignInSuccess<TRes> {
  _CopyWithImpl$Mutation$SignIn$signIn$$SignInSuccess(
    this._instance,
    this._then,
  );

  final Mutation$SignIn$signIn$$SignInSuccess _instance;

  final TRes Function(Mutation$SignIn$signIn$$SignInSuccess) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? token = _undefined,
    Object? viewer = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$SignIn$signIn$$SignInSuccess(
      token: token == _undefined || token == null
          ? _instance.token
          : (token as String),
      viewer: viewer == _undefined || viewer == null
          ? _instance.viewer
          : (viewer as Fragment$ViewerFields),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$ViewerFields<TRes> get viewer {
    final local$viewer = _instance.viewer;
    return CopyWith$Fragment$ViewerFields(local$viewer, (e) => call(viewer: e));
  }
}

class _CopyWithStubImpl$Mutation$SignIn$signIn$$SignInSuccess<TRes>
    implements CopyWith$Mutation$SignIn$signIn$$SignInSuccess<TRes> {
  _CopyWithStubImpl$Mutation$SignIn$signIn$$SignInSuccess(this._res);

  TRes _res;

  call({String? token, Fragment$ViewerFields? viewer, String? $__typename}) =>
      _res;

  CopyWith$Fragment$ViewerFields<TRes> get viewer =>
      CopyWith$Fragment$ViewerFields.stub(_res);
}

class Mutation$SignIn$signIn$$InvalidName implements Mutation$SignIn$signIn {
  Mutation$SignIn$signIn$$InvalidName({
    required this.minLength,
    this.$__typename = 'InvalidName',
  });

  factory Mutation$SignIn$signIn$$InvalidName.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$minLength = json['minLength'];
    final l$$__typename = json['__typename'];
    return Mutation$SignIn$signIn$$InvalidName(
      minLength: (l$minLength as int),
      $__typename: (l$$__typename as String),
    );
  }

  final int minLength;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$minLength = minLength;
    _resultData['minLength'] = l$minLength;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$minLength = minLength;
    final l$$__typename = $__typename;
    return Object.hashAll([l$minLength, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$SignIn$signIn$$InvalidName ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$minLength = minLength;
    final lOther$minLength = other.minLength;
    if (l$minLength != lOther$minLength) {
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

extension UtilityExtension$Mutation$SignIn$signIn$$InvalidName
    on Mutation$SignIn$signIn$$InvalidName {
  CopyWith$Mutation$SignIn$signIn$$InvalidName<
    Mutation$SignIn$signIn$$InvalidName
  >
  get copyWith => CopyWith$Mutation$SignIn$signIn$$InvalidName(this, (i) => i);
}

abstract class CopyWith$Mutation$SignIn$signIn$$InvalidName<TRes> {
  factory CopyWith$Mutation$SignIn$signIn$$InvalidName(
    Mutation$SignIn$signIn$$InvalidName instance,
    TRes Function(Mutation$SignIn$signIn$$InvalidName) then,
  ) = _CopyWithImpl$Mutation$SignIn$signIn$$InvalidName;

  factory CopyWith$Mutation$SignIn$signIn$$InvalidName.stub(TRes res) =
      _CopyWithStubImpl$Mutation$SignIn$signIn$$InvalidName;

  TRes call({int? minLength, String? $__typename});
}

class _CopyWithImpl$Mutation$SignIn$signIn$$InvalidName<TRes>
    implements CopyWith$Mutation$SignIn$signIn$$InvalidName<TRes> {
  _CopyWithImpl$Mutation$SignIn$signIn$$InvalidName(this._instance, this._then);

  final Mutation$SignIn$signIn$$InvalidName _instance;

  final TRes Function(Mutation$SignIn$signIn$$InvalidName) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? minLength = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$SignIn$signIn$$InvalidName(
      minLength: minLength == _undefined || minLength == null
          ? _instance.minLength
          : (minLength as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$SignIn$signIn$$InvalidName<TRes>
    implements CopyWith$Mutation$SignIn$signIn$$InvalidName<TRes> {
  _CopyWithStubImpl$Mutation$SignIn$signIn$$InvalidName(this._res);

  TRes _res;

  call({int? minLength, String? $__typename}) => _res;
}

class Query$Viewer {
  Query$Viewer({this.viewer, this.$__typename = 'Query'});

  factory Query$Viewer.fromJson(Map<String, dynamic> json) {
    final l$viewer = json['viewer'];
    final l$$__typename = json['__typename'];
    return Query$Viewer(
      viewer: l$viewer == null
          ? null
          : Fragment$ViewerFields.fromJson((l$viewer as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$ViewerFields? viewer;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$viewer = viewer;
    _resultData['viewer'] = l$viewer?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$viewer = viewer;
    final l$$__typename = $__typename;
    return Object.hashAll([l$viewer, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$Viewer || runtimeType != other.runtimeType) {
      return false;
    }
    final l$viewer = viewer;
    final lOther$viewer = other.viewer;
    if (l$viewer != lOther$viewer) {
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

extension UtilityExtension$Query$Viewer on Query$Viewer {
  CopyWith$Query$Viewer<Query$Viewer> get copyWith =>
      CopyWith$Query$Viewer(this, (i) => i);
}

abstract class CopyWith$Query$Viewer<TRes> {
  factory CopyWith$Query$Viewer(
    Query$Viewer instance,
    TRes Function(Query$Viewer) then,
  ) = _CopyWithImpl$Query$Viewer;

  factory CopyWith$Query$Viewer.stub(TRes res) = _CopyWithStubImpl$Query$Viewer;

  TRes call({Fragment$ViewerFields? viewer, String? $__typename});
  CopyWith$Fragment$ViewerFields<TRes> get viewer;
}

class _CopyWithImpl$Query$Viewer<TRes> implements CopyWith$Query$Viewer<TRes> {
  _CopyWithImpl$Query$Viewer(this._instance, this._then);

  final Query$Viewer _instance;

  final TRes Function(Query$Viewer) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? viewer = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$Viewer(
          viewer: viewer == _undefined
              ? _instance.viewer
              : (viewer as Fragment$ViewerFields?),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Fragment$ViewerFields<TRes> get viewer {
    final local$viewer = _instance.viewer;
    return local$viewer == null
        ? CopyWith$Fragment$ViewerFields.stub(_then(_instance))
        : CopyWith$Fragment$ViewerFields(local$viewer, (e) => call(viewer: e));
  }
}

class _CopyWithStubImpl$Query$Viewer<TRes>
    implements CopyWith$Query$Viewer<TRes> {
  _CopyWithStubImpl$Query$Viewer(this._res);

  TRes _res;

  call({Fragment$ViewerFields? viewer, String? $__typename}) => _res;

  CopyWith$Fragment$ViewerFields<TRes> get viewer =>
      CopyWith$Fragment$ViewerFields.stub(_res);
}

const documentNodeQueryViewer = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'Viewer'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'viewer'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'ViewerFields'),
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
    fragmentDefinitionViewerFields,
  ],
);
Query$Viewer _parserFn$Query$Viewer(Map<String, dynamic> data) =>
    Query$Viewer.fromJson(data);
typedef OnQueryComplete$Query$Viewer = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$Viewer?,
);

class Options$Query$Viewer extends graphql.QueryOptions<Query$Viewer> {
  Options$Query$Viewer({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Viewer? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$Viewer? onComplete,
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
                 data == null ? null : _parserFn$Query$Viewer(data),
               ),
         onError: onError,
         document: documentNodeQueryViewer,
         parserFn: _parserFn$Query$Viewer,
       );

  final OnQueryComplete$Query$Viewer? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
    ...super.onComplete == null
        ? super.properties
        : super.properties.where((property) => property != onComplete),
    onCompleteWithParsed,
  ];
}

class WatchOptions$Query$Viewer
    extends graphql.WatchQueryOptions<Query$Viewer> {
  WatchOptions$Query$Viewer({
    String? operationName,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Viewer? typedOptimisticResult,
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
         document: documentNodeQueryViewer,
         pollInterval: pollInterval,
         eagerlyFetchResults: eagerlyFetchResults,
         carryForwardDataOnException: carryForwardDataOnException,
         fetchResults: fetchResults,
         parserFn: _parserFn$Query$Viewer,
       );
}

class FetchMoreOptions$Query$Viewer extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Viewer({required graphql.UpdateQuery updateQuery})
    : super(updateQuery: updateQuery, document: documentNodeQueryViewer);
}

extension ClientExtension$Query$Viewer on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Viewer>> query$Viewer([
    Options$Query$Viewer? options,
  ]) async => await this.query(options ?? Options$Query$Viewer());

  graphql.ObservableQuery<Query$Viewer> watchQuery$Viewer([
    WatchOptions$Query$Viewer? options,
  ]) => this.watchQuery(options ?? WatchOptions$Query$Viewer());

  void writeQuery$Viewer({required Query$Viewer data, bool broadcast = true}) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryViewer),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );

  Query$Viewer? readQuery$Viewer({bool optimistic = true}) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryViewer),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$Viewer.fromJson(result);
  }
}
