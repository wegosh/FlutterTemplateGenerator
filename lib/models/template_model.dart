class TemplateModel {
  final String templateContent;
  final Map<String, String> variables;

  TemplateModel(this.templateContent, this.variables);

  String applyTemplate() {
    var result = templateContent;
    variables.forEach((key, value) {
      result = result.replaceAll('\${$key}', value);
    });
    return result;
  }
}
