import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import '../viewmodels/template_viewmodel.dart';

class TemplateView extends StatelessWidget {
  const TemplateView({super.key});
  final double minContainerSize = 100.0;

  @override
  Widget build(BuildContext context) {
    final templateViewModel = context.watch<TemplateViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Template Generator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () => templateViewModel.pickTemplateFile(),
                      child: const Text('Pick Template File'),
                    ),
                    const SizedBox(height: 58),
                    const Text('Template Content:'),
                    Container(
                      constraints: BoxConstraints(minHeight: minContainerSize),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: HighlightView(
                          templateViewModel.templateContent,
                          language: 'json',
                          theme: githubTheme,
                          padding: const EdgeInsets.all(12),
                          textStyle: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () => templateViewModel.pickConfigFile(),
                      child: const Text('Pick Config File'),
                    ),
                    const SizedBox(height: 58),
                    const Text('Config Content:'),
                    Container(
                      constraints: BoxConstraints(minHeight: minContainerSize),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: HighlightView(
                          templateViewModel.configContent,
                          language: 'json',
                          theme: githubTheme,
                          padding: const EdgeInsets.all(12),
                          textStyle: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () => templateViewModel.generateResult(),
                      child: const Text('Generate Result'),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: templateViewModel.result.isEmpty
                          ? null
                          : () => templateViewModel.exportJSON(),
                      child: Text('Export JSON ${templateViewModel.getFileName}'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Result:'),
                    Container(
                      constraints: BoxConstraints(minHeight: minContainerSize),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: HighlightView(
                          templateViewModel.result,
                          language: 'json',
                          theme: githubTheme,
                          padding: const EdgeInsets.all(12),
                          textStyle: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                          ),
                        ),
                      ),
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
