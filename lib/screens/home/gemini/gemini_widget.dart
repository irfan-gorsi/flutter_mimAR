import 'package:flutter/material.dart';
import 'gemini_controller.dart';

class GeminiWidget extends StatefulWidget {
  const GeminiWidget({super.key});

  @override
  State<GeminiWidget> createState() => _GeminiWidgetState();
}

class _GeminiWidgetState extends State<GeminiWidget> {
  final _controller = TextEditingController();
  final GeminiController _geminiController = GeminiController();
  final _scrollController = ScrollController();

  String? _response;
  bool _loading = false;

  static const Color primaryBlue = Color(0xFF1E88E5);

  void _generateResponse() async {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _loading = true;
      _response = null;
    });

    try {
      final result = await _geminiController.generateText(prompt);
      setState(() {
        _response = result;
        _loading = false;
        _controller.clear();
      });

      await Future.delayed(const Duration(milliseconds: 300));
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      setState(() {
        _response = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF0F2F5),

      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          radius: const Radius.circular(20),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_response == null && !_loading)
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: primaryBlue.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ask Gemini a question',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_loading)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(primaryBlue),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Thinking...',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (_response != null) ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.auto_awesome,
                                color: primaryBlue,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Response',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        SelectableText(
                          _response!,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _generateResponse(),
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Ask a question...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                  onTap: _loading ? null : _generateResponse,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}