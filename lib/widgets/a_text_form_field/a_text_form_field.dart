part of '../../flutter_artis_ui_kit.dart';

class ATextFormField extends StatelessWidget {
  final String title;
  final String? hintText;
  final String? labelText;
  final String? counterText;
  final String? errorText;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final bool? obsecureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? funValidator;
  final ValueChanged<String>? onChanged;
  final void Function(String)? onSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final BorderRadius? borderRadius;
  final double borderWidth;
  final EdgeInsets? contentPadding;
  final BoxConstraints? constraints;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? enabled;
  final bool readOnly;
  final bool expands;

  const ATextFormField({
    super.key,
    this.title = '',
    this.hintText = '',
    this.counterText,
    this.errorText,
    this.labelText,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.obsecureText,
    this.keyboardType,
    this.funValidator,
    this.onChanged,
    this.onSubmitted,
    this.controller,
    this.focusNode,
    this.borderRadius,
    this.borderWidth = 1,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    this.constraints,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled,
    this.readOnly = false,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return TextFormField(
      focusNode: focusNode,
      maxLength: maxLength,
      controller: controller,
      validator: funValidator,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      obscureText: obsecureText ?? false,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      enabled: enabled,
      readOnly: readOnly,
      expands: expands,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        counterText: counterText,
        errorText: errorText,
        constraints: constraints,
        filled: true,
        fillColor: themeData.colorScheme.onSurface.withValues(alpha: 0.15),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: true,
        contentPadding: contentPadding,
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.transparent, //themeData.colorScheme.onBackground.withOpacity(0.3),
            width: borderWidth,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.transparent, //themeData.colorScheme.onBackground.withOpacity(0.3),
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent, width: borderWidth),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          borderSide: BorderSide(color: themeData.colorScheme.error, width: borderWidth),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          borderSide: BorderSide(color: themeData.colorScheme.onSurface, width: borderWidth),
        ),
      ),
    );
  }
}
