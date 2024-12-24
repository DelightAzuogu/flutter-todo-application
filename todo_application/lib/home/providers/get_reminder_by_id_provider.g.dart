// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_reminder_by_id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getReminderByIdHash() => r'663a67248970706585ae483772ffa0dd78e2c2d0';

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

/// See also [getReminderById].
@ProviderFor(getReminderById)
const getReminderByIdProvider = GetReminderByIdFamily();

/// See also [getReminderById].
class GetReminderByIdFamily extends Family<AsyncValue<ReminderModel>> {
  /// See also [getReminderById].
  const GetReminderByIdFamily();

  /// See also [getReminderById].
  GetReminderByIdProvider call(
    String reminderId,
  ) {
    return GetReminderByIdProvider(
      reminderId,
    );
  }

  @override
  GetReminderByIdProvider getProviderOverride(
    covariant GetReminderByIdProvider provider,
  ) {
    return call(
      provider.reminderId,
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
  String? get name => r'getReminderByIdProvider';
}

/// See also [getReminderById].
class GetReminderByIdProvider extends AutoDisposeFutureProvider<ReminderModel> {
  /// See also [getReminderById].
  GetReminderByIdProvider(
    String reminderId,
  ) : this._internal(
          (ref) => getReminderById(
            ref as GetReminderByIdRef,
            reminderId,
          ),
          from: getReminderByIdProvider,
          name: r'getReminderByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getReminderByIdHash,
          dependencies: GetReminderByIdFamily._dependencies,
          allTransitiveDependencies:
              GetReminderByIdFamily._allTransitiveDependencies,
          reminderId: reminderId,
        );

  GetReminderByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.reminderId,
  }) : super.internal();

  final String reminderId;

  @override
  Override overrideWith(
    FutureOr<ReminderModel> Function(GetReminderByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetReminderByIdProvider._internal(
        (ref) => create(ref as GetReminderByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        reminderId: reminderId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<ReminderModel> createElement() {
    return _GetReminderByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetReminderByIdProvider && other.reminderId == reminderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, reminderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetReminderByIdRef on AutoDisposeFutureProviderRef<ReminderModel> {
  /// The parameter `reminderId` of this provider.
  String get reminderId;
}

class _GetReminderByIdProviderElement
    extends AutoDisposeFutureProviderElement<ReminderModel>
    with GetReminderByIdRef {
  _GetReminderByIdProviderElement(super.provider);

  @override
  String get reminderId => (origin as GetReminderByIdProvider).reminderId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
