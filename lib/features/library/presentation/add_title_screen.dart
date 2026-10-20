import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_spacing.dart';
import '../domain/add_title_result.dart';
import '../domain/library_entry.dart';
import '../domain/media_item.dart';
import '../domain/media_type.dart';
import '../domain/watch_status.dart';
import '../domain/watch_status_label.dart';

class AddTitleScreen extends StatefulWidget {
  const AddTitleScreen({super.key});

  @override
  State<AddTitleScreen> createState() => _AddTitleScreenState();
}

class _AddTitleScreenState extends State<AddTitleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _overviewController = TextEditingController();
  MediaType _type = MediaType.movie;
  WatchStatus _status = WatchStatus.wantToWatch;
  double _rating = 3.0;

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _overviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add title')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            TextFormField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final title = value?.trim() ?? '';
                if (title.isEmpty) {
                  return 'Enter a title';
                }
                if (title.length < 2) {
                  return 'Title must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Year (optional)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return null;
                }
                final year = int.tryParse(text);
                final maximumYear = DateTime.now().year + 5;
                if (year == null || year < 1888 || year > maximumYear) {
                  return 'Enter a year from 1888 to $maximumYear';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Text('Type', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            SegmentedButton<MediaType>(
              segments: const [
                ButtonSegment(value: MediaType.movie, label: Text('Movie')),
                ButtonSegment(value: MediaType.series, label: Text('Series')),
              ],
              selected: {_type},
              onSelectionChanged: (selection) {
                setState(() => _type = selection.first);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<WatchStatus>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final status in WatchStatus.values)
                  DropdownMenuItem(
                    value: status,
                    child: Text(status.label),
                  ),
              ],
              onChanged: (status) {
                if (status != null) {
                  setState(() => _status = status);
                }
              },
            ),
            if (_status == WatchStatus.watched) ...[
              const SizedBox(height: AppSpacing.md),
              Text('Your rating: ${_rating.toStringAsFixed(1)}'),
              Slider(
                min: 0.5,
                max: 5.0,
                divisions: 9,
                value: _rating,
                label: _rating.toStringAsFixed(1),
                onChanged: (rating) => setState(() => _rating = rating),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _overviewController,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Overview (optional)',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final now = DateTime.now();
    final yearText = _yearController.text.trim();
    final item = MediaItem(
      id: now.millisecondsSinceEpoch,
      title: _titleController.text.trim(),
      type: _type,
      year: yearText.isEmpty ? null : int.parse(yearText),
      overview: _overviewController.text.trim().isEmpty
          ? null
          : _overviewController.text.trim(),
    );
    final entry = LibraryEntry(
      mediaId: item.id,
      status: _status,
      addedAt: now,
      userRating: _status == WatchStatus.watched ? _rating : null,
    );

    Navigator.of(context).pop(
      AddTitleResult(mediaItem: item, libraryEntry: entry),
    );
  }
}
