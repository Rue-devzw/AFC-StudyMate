import 'package:flutter/material.dart';

class ActivityMatching extends StatefulWidget {
  const ActivityMatching({required this.data, super.key});

  final Map<String, String> data;

  @override
  State<ActivityMatching> createState() => _ActivityMatchingState();
}

class _ActivityMatchingState extends State<ActivityMatching> {
  final Map<String, String?> _answers = <String, String?>{};
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    for (final key in widget.data.keys) {
      _answers[key] = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final targets = widget.data.keys.toList();
    final options = widget.data.values.toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Match the pairs', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: targets.length,
              itemBuilder: (BuildContext context, int index) {
                final key = targets[index];
                return Card(
                  child: ListTile(
                    title: Text(key),
                    subtitle: DropdownButton<String>(
                      isExpanded: true,
                      value: _answers[key],
                      hint: const Text('Select'),
                      onChanged: (String? value) {
                        setState(() {
                          _answers[key] = value;
                          _showResult = false;
                        });
                      },
                      items: options
                          .map(
                            (option) => DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_showResult)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(_resultText(), style: Theme.of(context).textTheme.titleMedium),
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _showResult = true;
              });
            },
            child: const Text('Check answers'),
          ),
        ],
      ),
    );
  }

  String _resultText() {
    var correct = 0;
    widget.data.forEach((key, value) {
      if (_answers[key] == value) {
        correct++;
      }
    });
    return correct == widget.data.length
        ? 'Spot on! You matched every pair.'
        : 'You matched $correct of ${widget.data.length}. Keep practising!';
  }
}
