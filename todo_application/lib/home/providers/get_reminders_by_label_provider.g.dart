// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_reminders_by_label_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getRemindersByLabelHash() =>
    r'd8e1be9b4795d3428448a9a757074902e2cdaef7';

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

/// See also [getRemindersByLabel].
@ProviderFor(getRemindersByLabel)
const getRemindersByLabelProvider = GetRemindersByLabelFamily();

/// See also [getRemindersByLabel].
class GetRemindersByLabelFamily
    extends Family<AsyncValue<List<ReminderModel>>> {
  /// See also [getRemindersByLabel].
  const GetRemindersByLabelFamily();

  /// See also [getRemindersByLabel].
  GetRemindersByLabelProvider call({
    required String? labelId,
  }) {
    return GetRemindersByLabelProvider(
      labelId: labelId,
    );
  }

  @override
  GetRemindersByLabelProvider getProviderOverride(
    covariant GetRemindersByLabelProvider provider,
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
  String? get name => r'getRemindersByLabelProvider';
}

/// See also [getRemindersByLabel].
class GetRemindersByLabelProvider
    extends AutoDisposeFutureProvider<List<ReminderModel>> {
  /// See also [getRemindersByLabel].
  GetRemindersByLabelProvider({
    required String? labelId,
  }) : this._internal(
          (ref) => getRemindersByLabel(
            ref as GetRemindersByLabelRef,
            labelId: labelId,
          ),
          from: getRemindersByLabelProvider,
          name: r'getRemindersByLabelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getRemindersByLabelHash,
          dependencies: GetRemindersByLabelFamily._dependencies,
          allTransitiveDependencies:
              GetRemindersByLabelFamily._allTransitiveDependencies,
          labelId: labelId,
        );

  GetRemindersByLabelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.labelId,
  }) : super.internal();

  final String? labelId;

  @override
  Override overrideWith(
    FutureOr<List<ReminderModel>> Function(GetRemindersByLabelRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetRemindersByLabelProvider._internal(
        (ref) => create(ref as GetRemindersByLabelRef),
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
  AutoDisposeFutureProviderElement<List<ReminderModel>> createElement() {
    return _GetRemindersByLabelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetRemindersByLabelProvider && other.labelId == labelId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, labelId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetRemindersByLabelRef
    on AutoDisposeFutureProviderRef<List<ReminderModel>> {
  /// The parameter `labelId` of this provider.
  String? get labelId;
}

class _GetRemindersByLabelProviderElement
    extends AutoDisposeFutureProviderElement<List<ReminderModel>>
    with GetRemindersByLabelRef {
  _GetRemindersByLabelProviderElement(super.provider);

  @override
  String? get labelId => (origin as GetRemindersByLabelProvider).labelId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
