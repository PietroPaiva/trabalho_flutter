class Validators {
  static final RegExp _emailPattern = RegExp(r'^[\w.+\-]+@[\w\-]+(\.[\w\-]+)+$');

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe seu nome';
    if (text.length < 2) return 'O nome deve ter pelo menos 2 caracteres';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Informe seu e-mail';
    if (!_emailPattern.hasMatch(text)) return 'Digite um e-mail válido';
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Informe sua senha';
    if (text.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    return null;
  }
}