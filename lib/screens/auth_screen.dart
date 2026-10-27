import 'package:auroria/services/auth_service.dart';
import 'package:auroria/theme/app_theme.dart';
import 'package:auroria/utils/validators.dart';
import 'package:auroria/widgets/aurora_field.dart';
import 'package:auroria/widgets/brand_logo.dart';
import 'package:auroria/widgets/fade_slide_in.dart';
import 'package:auroria/widgets/glass_card.dart';
import 'package:auroria/widgets/gradient_background.dart';
import 'package:auroria/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isRegister = false;
  bool _hidePassword = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _setMode(bool register) {
    if (_isRegister == register) return;
    setState(() {
      _isRegister = register;
      _error = null;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthService>();
    setState(() {
      _busy = true;
      _error = null;
    });
    final String? error;
    if (_isRegister) {
      error = await auth.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      error = await auth.login(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = error;
    });
    if (error == null && _isRegister) {
      _passwordController.clear();
      setState(() => _isRegister = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado! Agora é só entrar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBottom,
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: FadeSlideIn(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BrandLogo(),
                      const SizedBox(height: 28),
                      GlassCard(
                        padding: const EdgeInsets.all(22),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              _ModeSwitch(
                                isRegister: _isRegister,
                                onChanged: _setMode,
                              ),
                              const SizedBox(height: 20),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                alignment: Alignment.topCenter,
                                child: _isRegister
                                    ? Column(
                                        children: [
                                          AuroraField(
                                            controller: _nameController,
                                            label: 'Nome',
                                            icon: Icons.person_rounded,
                                            keyboardType: TextInputType.name,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: Validators.name,
                                          ),
                                          const SizedBox(height: 14),
                                        ],
                                      )
                                    : const SizedBox(width: double.infinity),
                              ),
                              AuroraField(
                                controller: _emailController,
                                label: 'E-mail',
                                icon: Icons.alternate_email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: Validators.email,
                              ),
                              const SizedBox(height: 14),
                              AuroraField(
                                controller: _passwordController,
                                label: 'Senha',
                                icon: Icons.lock_rounded,
                                obscure: _hidePassword,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _submit(),
                                validator: Validators.password,
                                suffix: IconButton(
                                  onPressed: () => setState(
                                    () => _hidePassword = !_hidePassword,
                                  ),
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ),
                              if (_error != null) ...[
                                const SizedBox(height: 14),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0x33FF3D6E),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline_rounded,
                                        color: Color(0xFFFF8AB8),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          _error!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 22),
                              SizedBox(
                                width: double.infinity,
                                child: GradientButton(
                                  label: _isRegister ? 'Criar conta' : 'Entrar',
                                  icon: _isRegister
                                      ? Icons.rocket_launch_rounded
                                      : Icons.login_rounded,
                                  loading: _busy,
                                  onPressed: _submit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.isRegister, required this.onChanged});

  final bool isRegister;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0x26000000),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeOption(
              label: 'Entrar',
              selected: !isRegister,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _ModeOption(
              label: 'Cadastrar',
              selected: isRegister,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient:
              selected ? AppColors.primaryGradient : AppColors.clearGradient,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.mutedText,
          ),
        ),
      ),
    );
  }
}