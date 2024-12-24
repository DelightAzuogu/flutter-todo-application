import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:todo_application/home/providers/label_controller.dart';

class CreateLabelDialog extends ConsumerStatefulWidget {
  const CreateLabelDialog({super.key});

  @override
  ConsumerState<CreateLabelDialog> createState() => _CreateLabelDialogState();
}

class _CreateLabelDialogState extends ConsumerState<CreateLabelDialog> {
  late FormGroup _formGroup;

  @override
  void initState() {
    super.initState();
    _formGroup = FormGroup({
      'name': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(1),
        ],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: _formGroup,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create New Label',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ReactiveTextField(
                formControlName: 'name',
                decoration: InputDecoration(
                  labelText: 'Label Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validationMessages: {
                  'required': (error) => 'Label name is required',
                  'minLength': (error) => 'Label name must be at least 1 character long',
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ReactiveFormConsumer(
                      builder: (context, form, child) {
                        return ElevatedButton(
                          onPressed: form.valid
                              ? () {
                                  final labelName = form.control('name').value as String;
                                  ref.read(labelControllerProvider.notifier).createLabel(labelName);
                                }
                              : null,
                          child: const Text('Create'),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
