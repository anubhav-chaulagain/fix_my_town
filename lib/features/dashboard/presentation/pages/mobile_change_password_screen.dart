// mobile_change_password_screen.dart
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileChangePasswordScreen extends ConsumerStatefulWidget {
  const MobileChangePasswordScreen({super.key});

  @override
  ConsumerState<MobileChangePasswordScreen> createState() =>
      _MobileChangePasswordScreenState();
}

class _MobileChangePasswordScreenState
    extends ConsumerState<MobileChangePasswordScreen> {
  static const primary = Color(0xFF1EA095);

  bool _isLoading = false;
  bool _emailSent = false;
  String? _error;

  Future<void> _requestReset() async {
    final email = ref.read(userSessionServiceProvider).getUserEmail() ?? '';
    if (email.isEmpty) {
      setState(() => _error = 'Could not find your email address.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.post(
        '/api/auth/request-password-reset',
        data: {'email': email},
      );

      if (response.data['success'] == true) {
        setState(() => _emailSent = true);
      } else {
        setState(() {
          _error = response.data['message'] ?? 'Failed to send reset email';
        });
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openEmailApp() async {
    final uri = Uri.parse('mailto:');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _emailSent ? _buildSuccess() : _buildRequest(),
      ),
    );
  }

  Widget _buildRequest() {
    final email = ref.read(userSessionServiceProvider).getUserEmail() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.lock_reset_outlined,
            size: 32,
            color: primary,
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Reset your password',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "We'll send a password reset link to your email address.",
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
        ),

        const SizedBox(height: 24),

        // Email display card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.email_outlined,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 10),
              Text(
                email,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),

        if (_error != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFDC2626),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _requestReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: primary.withValues(alpha: 0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Send Reset Link',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            size: 32,
            color: Color(0xFF059669),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Check your email',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'A password reset link has been sent to your email. Click the link in the email to reset your password.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
        ),

        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFFB45309),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "The link will expire in 15 minutes. Check your spam folder if you don't see it.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[800],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _openEmailApp,
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text(
              'Open Email App',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => setState(() {
              _emailSent = false;
              _error = null;
            }),
            style: OutlinedButton.styleFrom(
              foregroundColor: primary,
              side: const BorderSide(color: primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Resend Email',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
