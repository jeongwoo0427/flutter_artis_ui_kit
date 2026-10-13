import 'package:flutter/material.dart';

/// 킷 갤러리 — 컴포넌트를 상태 · 톤 · 다크 · 창 너비별로 한 화면에서 본다.
///
/// 컴포넌트가 추가될 때마다 페이지를 하나씩 붙인다(0.1.0 은 뼈대뿐).
void main() => runApp(const GalleryApp());

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artis UI Kit',
      home: Scaffold(
        appBar: AppBar(title: const Text('Artis UI Kit')),
        body: const Center(child: Text('컴포넌트가 아직 없어요 — 1.0.0 에서 채워져요.')),
      ),
    );
  }
}
