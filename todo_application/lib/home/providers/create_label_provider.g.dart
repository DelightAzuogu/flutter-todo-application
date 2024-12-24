// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_label_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createLabelHash() => r'977c9b6ef744303471a712e0c8b27d3752a831d0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [createLabel].
@ProviderFor(createLabel)
const createLabelProvider = CreateLabelFamily();

/// See also [createLabel].
class CreateLabelFamily extends Family<AsyncValue<void>> {
  /// See also [createLabel].
  const CreateLabelFamily();

  /// See also [createLabel].
  CreateLabelProvider call({
    required String labelName,
  }) {
    return CreateLabelProvider(
      labelName: labelName,
    );
  }

  @override
  CreateLabelProvider getProviderOverride(
    covariant CreateLabelProvider provider,
  ) {
    return call(
      labelName: provider.labelName,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'createLabelProvider';
}

/// See also [createLabel].
class CreateLabelProvider extends AutoDisposeFutureProvider<void> {
  /// See also [createLabel].
  CreateLabelProvider({
    required String labelName,
  }) : this._internal(
          (ref) => createLabel(
            ref as CreateLabelRef,
            labelName: labelName,
          ),
          from: createLabelProvider,
          name: r'createLabelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$createLabelHash,
          dependencies: CreateLabelFamily._dependencies,
          allTransitiveDependencies:
              CreateLabelFamily._allTransitiveDependencies,
          labelName: labelName,
        );

  CreateLabelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.labelName,
  }) : super.internal();

  final String labelName;

  @override
  Override overrideWith(
    FutureOr<void> Function(CreateLabelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CreateLabelProvider._internal(
        (ref) => create(ref as CreateLabelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        labelName: labelName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _CreateLabelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CreateLabelProvider && other.labelName == labelName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, labelName.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CreateLabelRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `labelName` of this provider.
  String get labelName;
}

class _CreateLabelProviderElement extends AutoDisposeFutureProviderElement<void>
    with CreateLabelRef {
  _CreateLabelProviderElement(super.provider);

  @override
  String get labelName => (origin as CreateLabelProvider).labelName;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
