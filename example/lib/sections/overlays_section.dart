import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';

/// 바텀시트 · 액션시트 · 확인 다이얼로그 · 하단 CTA · 선택 바 · 더 불러오기 목록.
List<Widget> overlaysSection(BuildContext context) {
  final a = AThemeData.of(context);
  final caption = Theme.of(context).textTheme.bodySmall;

  Widget label(String text) => Text(text, style: caption);
  void toast(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  Widget box({required double height, required Widget child}) => ClipRRect(
    borderRadius: BorderRadius.circular(a.radii.lg),
    child: DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(a.radii.lg),
      ),
      child: SizedBox(height: height, child: child),
    ),
  );

  return [
    label('Sheets and dialogs (result shows in a snackbar)'),
    Wrap(
      spacing: a.spacing.sm,
      runSpacing: a.spacing.sm,
      children: [
        OutlinedButton(
          onPressed: () async {
            final picked = await showABottomSheet<String>(
              context,
              title: const Text('Where should it go?'),
              subtitle: const Text('You can edit imported questions later'),
              builder: (context) => Column(
                children: [
                  for (final f in ['New folder', 'Existing folder'])
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(f),
                      onTap: () => Navigator.pop(context, f),
                    ),
                ],
              ),
              action: Builder(
                builder: (context) => FilledButton(
                  onPressed: () => Navigator.pop(context, 'Import'),
                  child: const Text('Import 30 questions'),
                ),
              ),
            );
            toast('Sheet: $picked');
          },
          child: const Text('Bottom sheet'),
        ),
        OutlinedButton(
          onPressed: () async {
            final action = await showAActionSheet<String>(
              context,
              title: const Text('What to add?'),
              items: const [
                AActionSheetItem(
                  label: 'New folder',
                  value: 'folder',
                  icon: Icon(Icons.create_new_folder_outlined),
                  subtitle: 'Folders can nest',
                ),
                AActionSheetItem(
                  label: 'Rename',
                  value: 'rename',
                  icon: Icon(Icons.edit_outlined),
                ),
                AActionSheetItem(
                  label: 'Delete',
                  value: 'delete',
                  icon: Icon(Icons.delete_outline),
                  destructive: true,
                ),
              ],
            );
            toast('Action sheet: $action');
          },
          child: const Text('Action sheet'),
        ),
        OutlinedButton(
          onPressed: () async {
            final ok = await showAConfirmDialog(
              context,
              title: const Text('Leave the quiz?'),
              content: const Text('Your answers so far are saved.'),
              confirmLabel: 'Leave',
            );
            toast('Confirm: $ok');
          },
          child: const Text('Confirm dialog'),
        ),
        OutlinedButton(
          onPressed: () async {
            final ok = await showAConfirmDialog(
              context,
              title: const Text('Delete this folder?'),
              content: const Text('12 questions inside are deleted too.'),
              confirmLabel: 'Delete',
              destructive: true,
            );
            toast('Destructive confirm: $ok');
          },
          child: const Text('Destructive confirm'),
        ),
      ],
    ),
    label('ABottomCta (fade over scrolling content)'),
    box(
      height: 220,
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(a.spacing.lg),
            children: [for (var i = 1; i <= 12; i++) Text('Question $i')],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ABottomCta(
              child: Row(
                spacing: a.spacing.sm,
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () {},
                      child: const Text('Save'),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    label('ASelectionBar (with note, destructive and disabled actions)'),
    box(
      height: 140,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ASelectionBar(
          note: const Text('1 folder is skipped'),
          actions: [
            ASelectionBarAction(
              icon: const Icon(Icons.drive_file_move_outline),
              label: 'Move',
              onPressed: () => toast('Move'),
            ),
            ASelectionBarAction(
              icon: const Icon(Icons.delete_outline),
              label: 'Delete',
              onPressed: () => toast('Delete'),
              destructive: true,
            ),
            const ASelectionBarAction(
              icon: Icon(Icons.copy),
              label: 'Copy',
              onPressed: null,
            ),
          ],
          primary: FilledButton(
            onPressed: () => toast('Play'),
            child: const Text('Play 2'),
          ),
        ),
      ),
    ),
    label('APaginatedListView (loads 15 more near the end, up to 60)'),
    box(height: 240, child: const _PaginatedDemo()),
  ];
}

class _PaginatedDemo extends StatefulWidget {
  const _PaginatedDemo();

  @override
  State<_PaginatedDemo> createState() => _PaginatedDemoState();
}

class _PaginatedDemoState extends State<_PaginatedDemo> {
  int _count = 15;
  bool _loading = false;

  Future<void> _loadMore() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _count += 15;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return APaginatedListView(
      itemCount: _count,
      itemBuilder: (context, i) => ListTile(title: Text('Item ${i + 1}')),
      separatorBuilder: (_, _) => const Divider(),
      onLoadMore: _count < 60 ? _loadMore : null,
      isLoadingMore: _loading,
    );
  }
}
