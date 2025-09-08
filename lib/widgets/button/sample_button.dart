part of '../../flutter_artis_ui_kit.dart';

class SampleButton extends StatelessWidget {
  const SampleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text('Sample Button!'),
      onPressed: (){}); 
  }
}