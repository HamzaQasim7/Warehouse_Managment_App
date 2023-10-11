import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final String? Function(String?)? validator;
  final IconData? icon;
  final String? hint;
  final Widget? suffixIcon;
  final String? errorText;
  final bool isObscure;
  final bool isIcon;
  final TextInputType? inputType;
  final TextEditingController textController;
  final EdgeInsets padding;
  final Color hintColor;
  final Color iconColor;
  final FocusNode? focusNode;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final bool autoFocus;
  final TextInputAction? inputAction;
  final int maxLines;
  final String? imageIcon;
  final Function? onTap;
  final bool isReadOnly;
  final TextStyle? textStyle;
  final String? labelText;

  final List<TextInputFormatter>? inputFormat;

  final String? autofillHint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        autofillHints: autofillHint != null ? [autofillHint!] : null,
        validator: validator,
        inputFormatters: inputFormat ?? [],
        readOnly: isReadOnly,
        onTap: onTap != null
            ? () {
          onTap!();
        }
            : () {},
        controller: textController,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        autofocus: autoFocus,
        textInputAction: inputAction,
        obscureText: isObscure,
        maxLines: maxLines,
        focusNode: focusNode,
        keyboardType: inputType,
        style: textStyle ?? Theme.of(context).textTheme.bodyLarge,
        decoration: errorText != null
            ? InputDecoration(
            labelText: labelText,
            prefixIcon: imageIcon == null
                ? icon != null
                ? Icon(icon)
                : null
                : ImageIcon(AssetImage(imageIcon!)),
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: hintColor),
            errorText: errorText,
            counterText: '',
            suffixIcon: suffixIcon

          // icon: this.isIcon ? Icon(this.icon, color: iconColor) : null,
        )
            : InputDecoration(
            labelText: labelText,
            prefixIcon: imageIcon == null
                ? icon != null
                ? Icon(icon)
                : null
                : ImageIcon(AssetImage(imageIcon!)),
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: hintColor),
            counterText: '',
            suffixIcon: suffixIcon
          // icon: this.isIcon ? Icon(this.icon, color: iconColor) : null,
        ),
      ),
    );
  }

  const TextFieldWidget({
    Key? key,
    this.validator,
    this.autofillHint,
    this.inputFormat,
    this.labelText,
    this.icon,
    this.isReadOnly = false,
    this.maxLines = 1,
    this.errorText,
    required this.textController,
    this.inputType,
    this.hint,
    this.suffixIcon,
    this.isObscure = false,
    this.isIcon = true,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
    this.imageIcon,
    this.onTap,
    this.textStyle,
  }) : super(key: key);
}

class TextFieldPasswordWidget extends StatelessWidget {
  final IconData? icon;
  final String? hint;
  final String? errorText;
  final bool isObscure;
  final bool isIcon;
  final TextInputType? inputType;
  final TextEditingController textController;
  final EdgeInsets padding;
  final Color hintColor;
  final Color iconColor;
  final FocusNode? focusNode;
  final ValueChanged? onFieldSubmitted;
  final ValueChanged? onChanged;
  final bool autoFocus;
  final TextInputAction? inputAction;
  final int maxLines;
  final String? imageIcon;
  final Function onPasswordToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextFormField(
        controller: textController,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        autofocus: autoFocus,
        textInputAction: inputAction,
        obscureText: isObscure,
        maxLength: 40,

        maxLines: maxLines,
        keyboardType: inputType,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: errorText != null
            ? InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              onPasswordToggle();
            },
            icon: Icon(isObscure ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
          ),
          prefixIcon: imageIcon == null
              ? icon != null
              ? Icon(icon)
              : null
              : ImageIcon(AssetImage(imageIcon!)),

          hintText: hint,
          errorMaxLines: 2,
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: hintColor),
          errorText: errorText,
          counterText: '',
          // icon: this.isIcon ? Icon(this.icon, color: iconColor) : null,
        )
            : InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              onPasswordToggle();
            },
            icon: Icon(isObscure ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
          ),
          prefixIcon: imageIcon == null
              ? icon != null
              ? Icon(icon)
              : null
              : ImageIcon(AssetImage(imageIcon!)),

          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: hintColor),

          counterText: '',
          // icon: this.isIcon ? Icon(this.icon, color: iconColor) : null,
        ),
      ),
    );
  }

  const TextFieldPasswordWidget({
    Key? key,
    required this.onPasswordToggle,
    this.icon,
    this.maxLines = 1,
    this.errorText,
    required this.textController,
    this.inputType,
    this.hint,
    this.isObscure = false,
    this.isIcon = true,
    this.padding = const EdgeInsets.all(0),
    this.hintColor = Colors.grey,
    this.iconColor = Colors.grey,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.autoFocus = false,
    this.inputAction,
    this.imageIcon,
  }) : super(key: key);
}
