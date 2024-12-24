// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_label_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deleteLabelHash() => r'a59e1c0087fb2521f29693e7ef1f6de6d8b26b6e';

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

/// See also [deleteLabel].
@ProviderFor(deleteLabel)
const deleteLabelProvider = DeleteLabelFamily();

/// See also [deleteLabel].
class DeleteLabelFamily extends Family<AsyncValue<void>> {
  /// See also [deleteLabel].
  const DeleteLabelFamily();

  /// See also [deleteLabel].
  DeleteLabelProvider call({
    required String labelId,
  }) {
    return DeleteLabelProvider(
      labelId: labelId,
    );
  }

  @override
  DeleteLabelProvider getProviderOverride(
    covariant DeleteLabelProvider provider,
  ) {
    return call(
      labelId: provider.labelId,
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
  String? get name => r'deleteLabelProvider';
}

/// See also [deleteLabel].
class DeleteLabelProvider extends AutoDisposeFutureProvider<void> {
  /// See also [deleteLabel].
  DeleteLabelProvider({
    required String labelId,
  }) : this._internal(
          (ref) => deleteLabel(
            ref as DeleteLabelRef,
            labelId: labelId,
          ),
          from: deleteLabelProvider,
          name: r'deleteLabelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteLabelHash,
          dependencies: DeleteLabelFamily._dependencies,
          allTransitiveDependencies:
              DeleteLabelFamily._allTransitiveDependencies,
          labelId: labelId,
        );

  DeleteLabelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.labelId,
  }) : super.internal();

  final String labelId;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteLabelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteLabelProvider._internal(
        (ref) => create(ref as DeleteLabelRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        labelId: labelId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteLabelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteLabelProvider && other.labelId == labelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, labelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteLabelRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `labelId` of this provider.
  String get labelId;
}

class _DeleteLabelProviderElement extends AutoDisposeFutureProviderElement<void>
    with DeleteLabelRef {
  _DeleteLabelProviderElement(super.provider);

  @override
  String get labelId => (origin as DeleteLabelProvider).labelId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
