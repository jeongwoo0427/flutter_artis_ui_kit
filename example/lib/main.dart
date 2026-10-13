import 'package:flutter/material.dart';
import 'package:flutter_artis_ui_kit/flutter_artis_ui_kit.dart';

/// 킷 갤러리 — 톤 · 다크를 바꿔 가며 테마가 표준 위젯에 어떻게 입혀지는지 본다.
///
/// 킷 컴포넌트가 추가될 때마다 섹션을 붙인다.
void main() => runApp(const GalleryApp());

const _brands = <String, Color>{
  'Blue': Color(0xFF3182F6),
  'Mint': Color(0xFF00B8A9),
  'Coral': Color(0xFFFF6B5A),
  'Purple': Color(0xFF7C5CFF),
  'Orange': Color(0xFFFF7A1A),
  'Green': Color(0xFF22B573),
};

class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  Color _brand = _brands.values.first;
  ThemeMode _mode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    final tone = ATone.fromBrand(_brand);
    return MaterialApp(
      title: 'Artis UI Kit',
      theme: AThemeBuilder.light(tone: tone),
      darkTheme: AThemeBuilder.dark(tone: tone),
      themeMode: _mode,
      home: _GalleryPage(
        brand: _brand,
        dark: _mode == ThemeMode.dark,
        onBrand: (c) => setState(() => _brand = c),
        onDark: (v) =>
            setState(() => _mode = v ? ThemeMode.dark : ThemeMode.light),
      ),
    );
  }
}

class _GalleryPage extends StatelessWidget {
  const _GalleryPage({
    required this.brand,
    required this.dark,
    required this.onBrand,
    required this.onDark,
  });

  final Color brand;
  final bool dark;
  final ValueChanged<Color> onBrand;
  final ValueChanged<bool> onDark;

  @override
  Widget build(BuildContext context) {
    final a = AThemeData.of(context);
    final text = Theme.of(context).textTheme;
    Widget section(String title, List<Widget> children) => Padding(
      padding: EdgeInsets.only(bottom: a.spacing.md),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(a.spacing.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: a.spacing.md,
            children: [
              Text(title, style: text.titleLarge),
              ...children,
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artis UI Kit'),
        actions: [
          Switch(value: dark, onChanged: onDark),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(a.spacing.screen),
        children: [
          section('Tone', [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final e in _brands.entries)
                  ChoiceChip(
                    label: Text(e.key),
                    selected: e.value == brand,
                    onSelected: (_) => onBrand(e.value),
                  ),
              ],
            ),
          ]),
          section('Typography', [
            Text('80', style: text.displayLarge),
            Text('4,860', style: text.displaySmall),
            Text('Headline', style: text.headlineLarge),
            Text('Body text — the default Text style.', style: text.bodyMedium),
            Text('Caption', style: text.bodySmall),
          ]),
          section('Buttons', [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(onPressed: () {}, child: const Text('Filled')),
                FilledButton.tonal(
                  onPressed: () {},
                  child: const Text('Tonal'),
                ),
                OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
                TextButton(onPressed: () {}, child: const Text('Text')),
                const FilledButton(onPressed: null, child: Text('Disabled')),
                IconButton.filledTonal(
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark),
                ),
              ],
            ),
          ]),
          section('Inputs', [
            const TextField(
              decoration: InputDecoration(hintText: 'Type an answer'),
            ),
            const SearchBar(hintText: 'Search', leading: Icon(Icons.search)),
            Row(
              children: [
                Checkbox(value: true, onChanged: (_) {}),
                RadioGroup<int>(
                  groupValue: 1,
                  onChanged: (_) {},
                  child: const Radio<int>(value: 1),
                ),
                Switch(value: true, onChanged: (_) {}),
              ],
            ),
            const LinearProgressIndicator(value: 0.3),
          ]),
          section('Overlays', [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Delete?'),
                      content: const Text('This cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(c),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                  child: const Text('Dialog'),
                ),
                OutlinedButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    showDragHandle: true,
                    builder: (_) => const SizedBox(
                      height: 200,
                      child: Center(child: Text('Sheet')),
                    ),
                  ),
                  child: const Text('Sheet'),
                ),
                OutlinedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Moved to trash'),
                      action: SnackBarAction(label: 'Undo', onPressed: () {}),
                    ),
                  ),
                  child: const Text('Snackbar'),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
