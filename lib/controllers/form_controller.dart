class FormController {
  Map<String, dynamic> values;
  Map<String, String> errors = {};
  Map<String, bool> touched = {};
  bool isSubmitting = false;
  final Map<String, String> Function(Map<String, dynamic>) validate;

  FormController({required this.values, required this.validate});

  void setValue(String field, dynamic value) {
    values[field] = value;
    touched[field] = true;
    errors = validate(values);
  }

  Future<void> submit(
    Future<void> Function(Map<String, dynamic>) values,
  ) async {
    if (isSubmitting) return;

    errors = validate(this.values);
    if (errors.isEmpty) {
      try {
        isSubmitting = true;
        await values(this.values);
      } finally {
        isSubmitting = false;
      }
    }
  }

  void reset() {
    values = values.map((key, value) => MapEntry(key, ''));
    errors.clear();
    touched.clear();
    isSubmitting = false;
  }
}
