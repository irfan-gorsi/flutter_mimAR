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

      // Scroll to top after new response
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
      backgroundColor: const Color(0xFFF8F9FB),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_response != null) ...[
                  const Text(
                    'Response',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: SelectableText(
                      _response!,
                      style: const TextStyle(fontSize: 16, height: 1.4),
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
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
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
                  decoration: const InputDecoration(
                    hintText: 'Type your question...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: _loading ? null : _generateResponse,
                icon: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
