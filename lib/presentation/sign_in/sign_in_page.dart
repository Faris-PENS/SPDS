import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spds/core/gen/locale_keys.g.dart';
import 'package:spds/data/domain/entities/result.dart';
import 'provider/auth.dart';
import '../common/message_dialog.dart';
import 'package:spds/presentation/main_page/main_page.dart';

// import 'package:spds/presentation/home_page/home_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends ConsumerState<LoginPage> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool obscure = true;

  


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    ref.listen(loginProvider, (prev, next) {
      if (prev == next) return;

      next.maybeWhen(
        success: (_) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        },
        error: (e) {
          if (!mounted) return;

          showDialog(
            context: context,
            builder: (_) => ErrorMessageDialog(
              titleText: LocaleKeys.failedToSignIn.tr(),
              contentText: e.toString(),
              onRetry: () {
                Navigator.pop(context);
                // ctrl.login(userCtrl.text, passCtrl.text);
              },
            ),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const SizedBox(height: 20),
                Text(
                  LocaleKeys.welcome.tr(),
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  LocaleKeys.signIn.tr(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: userCtrl,
                    decoration: InputDecoration(
                      hintText: LocaleKeys.username.tr(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: passCtrl,
                    obscureText: obscure,
                    decoration: InputDecoration(
                      hintText: LocaleKeys.password.tr(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      suffixIcon: IconButton(
                        icon: Icon(
                            obscure ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() => obscure = !obscure);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.isLoading
                          ? null
                          : () {
                              final user = userCtrl.text.trim();
                              final pass = passCtrl.text.trim();

                              if (user.isEmpty || pass.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      LocaleKeys.fieldIsRequired.tr(),
                                    ),
                                  ),
                                );
                                return;
                              }

                               ref.read(loginProvider.notifier).login(user, pass) ;
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E6FD9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: state.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(LocaleKeys.signIn.tr()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}