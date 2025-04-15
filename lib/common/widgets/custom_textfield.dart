import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField {
  static Widget normalTextField({
    bool readOnly = false,
    bool obscureText = false,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    Widget? animation,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function()? onTap,
    AutovalidateMode? autovalidateMode,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? prefixIcon,
    int? maxLength,
    bool required = false,
    Widget? icRequired,
    Widget? suffixIcon,
    double? height,
    bool? contentPadding,
    void Function(String)? onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (labelText != null)
            Row(
              mainAxisAlignment:
                  animation != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        labelText,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      icRequired ??
                          (required
                              ? Text(
                                '*',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red,
                                ),
                              )
                              : SizedBox()),
                    ],
                  ),
                ),
                animation ?? const SizedBox(),
              ],
            ),
          SizedBox(
            height: height,
            child: TextFormField(
              cursorWidth: 1,
              cursorHeight: 16,
              controller: controller,
              readOnly: readOnly,
              focusNode: focusNode,
              obscureText: obscureText,
              cursorColor: Colors.black,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              onTap: onTap,
              onChanged: onChanged,
              maxLength: maxLength,
              autovalidateMode: autovalidateMode,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                contentPadding:
                    contentPadding != null
                        ? EdgeInsets.symmetric(horizontal: 12)
                        : null,
                suffixIcon: suffixIcon,
                // helperText: ' ',
                helperStyle: const TextStyle(fontSize: 11),
                prefixIcon: prefixIcon,
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 33, // kasih ruang yang cukup
                  minHeight: 20,
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
                // Garis bawah lebih tebal saat fokus
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: 1, // Border normal
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1, // Border normal
                    color: Colors.blue,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1, // Border normal
                    color: Colors.red,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1, // Border normal
                    color: Colors.red,
                  ),
                ),
              ),
              inputFormatters: inputFormatters,
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
