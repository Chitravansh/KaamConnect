import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Flutter Logs
    FlutterLogs.initLogs(
      logLevelsEnabled: [LogLevel.ERROR, LogLevel.INFO, LogLevel.WARNING],
      timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
      directoryStructure: DirectoryStructure.FOR_EVENT,
      logFileExtension: LogFileExtension.LOG,
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.cyan,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: RegistrationPage(),
          ),
        ),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  bool _isRegisterButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateEmail);
    _passwordController.removeListener(_validatePassword);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text;
    setState(() {
      _emailError = _getEmailError(email);
      _validateForm();
    });

    if (_emailError != null) {
      FlutterLogs.logError("[KaamConnect Assignment]", "Email Validation Error", _emailError!);
    } else {
      FlutterLogs.logInfo("[KaamConnect Assignment]", "Email Validation Successful", "Email validation passed");
    }
  }

  String? _getEmailError(String email) {
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'Invalid email format.';
    }
    return null;
  }

  void _validatePassword() {
    final password = _passwordController.text;
    setState(() {
      _passwordError = _getPasswordError(password);
      _validateForm();
    });

    if (_passwordError != null) {
      FlutterLogs.logError("[KaamConnect Assignment]", "Password Validation Error", _passwordError!);
    } else {
      FlutterLogs.logInfo("[KaamConnect Assignment]", "Password Validation Successful", "Password validation passed");
    }
  }

  String? _getPasswordError(String password) {
    if (password.length < 8 || password.length > 50) {
      return 'Password must be between 8 and 50 characters.';
    }
    if (!_hasTwoCapitalLetters(password)) {
      return 'Password must contain at least two capital letters.';
    }
    if (!_hasOneSmallLetter(password)) {
      return 'Password must contain at least one small letter.';
    }
    if (!_hasOneSpecialCharacter(password)) {
      return 'Password must contain at least one special character except "*".';
    }
    return null;
  }

  bool _hasTwoCapitalLetters(String password) {
    return RegExp(r'[A-Z]').allMatches(password).length >= 2;
  }

  bool _hasOneSmallLetter(String password) {
    return RegExp(r'[a-z]').hasMatch(password);
  }

  bool _hasOneSpecialCharacter(String password) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  void _validateForm() {
    _isRegisterButtonDisabled = _emailError != null || _passwordError != null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40), // Spacer for top margin
          const Text(
            'Hello, Welcome back!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Login to Continue',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              errorText: _emailError,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              errorText: _passwordError,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              FlutterLogs.logInfo("[KaamConnect Assignment]", "Forgot Password", "Forgot Password is clicked");
            },
            child: const Text('Forgot Password?'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _isRegisterButtonDisabled ? null : () {
              FlutterLogs.logInfo("[KaamConnect Assignment]", "Register", "Register is clicked");
            },
            child: const Text('Register'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Or sign in with',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              FlutterLogs.logInfo("[KaamConnect Assignment]", "Google Login", "Google is clicked");
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/Google.png',
                  width: 22,
                  height: 22,
                ),
                const SizedBox(width: 10),
                const Text('Login with Google'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              FlutterLogs.logInfo("[KaamConnect Assignment]", "Facebook Login", "Facebook is clicked");
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/Facebook.png',
                  width: 22,
                  height: 22,
                ),
                const SizedBox(width: 10),
                const Text('Login with Facebook'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account?'),
              TextButton(
                onPressed: () {
                  FlutterLogs.logInfo("[KaamConnect Assignment]", "Sign Up", "Sign Up is clicked");
                },
                child: const Text('Sign up'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
