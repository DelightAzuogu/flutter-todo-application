// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_label_to_reminder_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assignLabelToReminderHash() =>
    r'916106b1b57c30362f6b064d19138bf41ac17a12';

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

/// See also [assignLabelToReminder].
@ProviderFor(assignLabelToReminder)
const assignLabelToReminderProvider = AssignLabelToReminderFamily();

/// See also [assignLabelToReminder].
class AssignLabelToReminderFamily extends Family<AsyncValue<void>> {
  /// See also [assignLabelToReminder].
  const AssignLabelToReminderFamily();

  /// See also [assignLabelToReminder].
  AssignLabelToReminderProvider call({
    required String labelId,
    required String reminderId,
  }) {
    return AssignLabelToReminderProvider(
      labelId: labelId,
      reminderId: reminderId,
    );
  }

  @override
  AssignLabelToReminderProvider getProviderOverride(
    covariant AssignLabelToReminderProvider provider,
  ) {
    return call(
      labelId: provider.labelId,
      reminderId: provider.reminderId,
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
  String? get name => r'assignLabelToReminderProvider';
}

/// See also [assignLabelToReminder].
class AssignLabelToReminderProvider extends AutoDisposeFutureProvider<void> {
  /// See also [assignLabelToReminder].
  AssignLabelToReminderProvider({
    required String labelId,
    required String reminderId,
  }) : this._internal(
          (ref) => assignLabelToReminder(
            ref as AssignLabelToReminderRef,
            labelId: labelId,
            reminderId: reminderId,
          ),
          from: assignLabelToReminderProvider,
          name: r'assignLabelToReminderProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assignLabelToReminderHash,
          dependencies: AssignLabelToReminderFamily._dependencies,
          allTransitiveDependencies:
              AssignLabelToReminderFamily._allTransitiveDependencies,
          labelId: labelId,
          reminderId: reminderId,
        );

  AssignLabelToReminderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.labelId,
    required this.reminderId,
  }) : super.internal();

  final String labelId;
  final String reminderId;

  @override
  Override overrideWith(
    FutureOr<void> Function(AssignLabelToReminderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssignLabelToReminderProvider._internal(
        (ref) => create(ref as AssignLabelToReminderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        labelId: labelId,
        reminderId: reminderId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _AssignLabelToReminderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssignLabelToReminderProvider &&
        other.labelId == labelId &&
        other.reminderId == reminderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, labelId.hashCode);
    hash = _SystemHash.combine(hash, reminderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AssignLabelToReminderRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `labelId` of this provider.
  String get labelId;

  /// The parameter `reminderId` of this provider.
  String get reminderId;
}

class _AssignLabelToReminderProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with AssignLabelToReminderRef {
  _AssignLabelToReminderProviderElement(super.provider);

  @override
  String get labelId => (origin as AssignLabelToReminderProvider).labelId;
  @override
  String get reminderId => (origin as AssignLabelToReminderProvider).reminderId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
