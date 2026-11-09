import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const FatzGptApp());

const bg = Color(0xFF080511);
const violet = Color(0xFF9B5CFF);
const lavender = Color(0xFFD8B8FF);

class FatzGptApp extends StatelessWidget {
  const FatzGptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fatzGPT',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: violet,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _orbController;
  final _messageController = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();
  }

  @override
  void dispose() {
    _orbController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final value = _messageController.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _messages.add(value);
      _messageController.clear();
    });
    // TODO: Connect this point to the selected LLM provider.
  }

  void _openApiSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ApiSettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _AmbientBackground(),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: violet.withOpacity(.15),
                          border: Border.all(color: violet.withOpacity(.5)),
                        ),
                        child: const Icon(Icons.auto_awesome,
                            color: lavender, size: 19),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'fatzGPT',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .4,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'API settings',
                        onPressed: _openApiSettings,
                        icon: const Icon(Icons.tune_rounded),
                      ),
                      IconButton(
                        tooltip: 'New chat',
                        onPressed: () => setState(_messages.clear),
                        icon: const Icon(Icons.add_comment_outlined),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _messages.isEmpty
                      ? _WelcomeView(controller: _orbController)
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) => Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              constraints: const BoxConstraints(maxWidth: 300),
                              decoration: BoxDecoration(
                                color: const Color(0xFF25143D),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                    color: violet.withOpacity(.35)),
                              ),
                              child: Text(_messages[index]),
                            ),
                          ),
                        ),
                ),
                _Composer(
                  controller: _messageController,
                  onSend: _sendMessage,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView({required this.controller});
  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 270,
              height: 270,
              child: CustomPaint(
                painter: OrbPainter(controller.value),
                child: const Center(
                  child: Icon(Icons.auto_awesome,
                      size: 42, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'YOUR AI, YOUR UNIVERSE',
              style: TextStyle(
                color: lavender,
                fontSize: 11,
                letterSpacing: 3.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Halo, js.',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Apa yang ingin kamu buat hari ini?',
              style: TextStyle(color: Colors.white.withOpacity(.62)),
            ),
          ],
        );
      },
    );
  }
}

class OrbPainter extends CustomPainter {
  OrbPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final pulse = .5 + .5 * math.sin(t * math.pi * 2);
    final base = size.width * (.245 + pulse * .012);

    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          lavender.withOpacity(.42),
          violet.withOpacity(.20),
          violet.withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(center: c, radius: size.width * .49));
    canvas.drawCircle(c, size.width * .49, glow);

    for (var i = 0; i < 3; i++) {
      final radius = size.width * (.30 + i * .065);
      final ring = Paint()
        ..color = lavender.withOpacity(.34 - i * .07)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: radius),
        t * math.pi * 2 + i,
        math.pi * (1.12 + .12 * math.sin(t * math.pi * 2 + i)),
        false,
        ring,
      );
    }

    final sphere = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-.32, -.38),
        radius: .9,
        colors: [
          Color(0xFFF0DFFF),
          Color(0xFFB77BFF),
          Color(0xFF7434D6),
          Color(0xFF29104F),
        ],
        stops: [0, .22, .62, 1],
      ).createShader(Rect.fromCircle(center: c, radius: base));
    canvas.drawCircle(c, base, sphere);

    final highlight = Paint()
      ..color = Colors.white.withOpacity(.42)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawCircle(
      c.translate(-base * .32, -base * .36),
      base * .19,
      highlight,
    );

    final dotPaint = Paint()..color = lavender.withOpacity(.8);
    for (var i = 0; i < 18; i++) {
      final a = (i / 18) * math.pi * 2 + t * math.pi * 2;
      final r = size.width * (.37 + .025 * math.sin(a * 3 + t * 6));
      final p = c + Offset(math.cos(a) * r, math.sin(a) * r);
      canvas.drawCircle(p, i % 3 == 0 ? 2 : 1, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant OrbPainter oldDelegate) => oldDelegate.t != t;
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -.35),
          radius: 1.15,
          colors: [Color(0xFF211039), bg, Color(0xFF05030A)],
          stops: [0, .58, 1],
        ),
      ),
      child: CustomPaint(
        painter: _GridPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = violet.withOpacity(.045)
      ..strokeWidth = .6;
    const step = 34.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Composer extends StatelessWidget {
  const _Composer({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 5, 6, 5),
        decoration: BoxDecoration(
          color: const Color(0xFF171020).withOpacity(.96),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: violet.withOpacity(.45)),
          boxShadow: [
            BoxShadow(
              color: violet.withOpacity(.12),
              blurRadius: 24,
              spreadRadius: 1,
            )
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.add, color: lavender),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: const InputDecoration(
                  hintText: 'Kirim pesan ke fatzGPT...',
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Voice (coming soon)',
              onPressed: () {},
              icon: const Icon(Icons.mic_none_rounded, color: lavender),
            ),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFCB9BFF), Color(0xFF7838D4)],
                ),
              ),
              child: IconButton(
                onPressed: onSend,
                icon: const Icon(Icons.arrow_upward_rounded,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApiSettingsScreen extends StatefulWidget {
  const ApiSettingsScreen({super.key});

  @override
  State<ApiSettingsScreen> createState() => _ApiSettingsScreenState();
}

class _ApiSettingsScreenState extends State<ApiSettingsScreen> {
  final _keyController = TextEditingController();
  String _provider = 'OpenAI';

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Manager')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Hubungkan otak fatzGPT',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih provider dan masukkan API key. Penyimpanan aman dan koneksi API belum diaktifkan pada starter ini.',
            style: TextStyle(color: Colors.white.withOpacity(.62)),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _provider,
            decoration: const InputDecoration(
              labelText: 'Provider',
              border: OutlineInputBorder(),
            ),
            items: const ['OpenAI', 'Gemini', 'Groq', 'OpenRouter']
                .map((name) =>
                    DropdownMenuItem(value: name, child: Text(name)))
                .toList(),
            onChanged: (value) =>
                setState(() => _provider = value ?? 'OpenAI'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _keyController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'API Key',
              hintText: 'Tempel API key di sini',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.key_rounded),
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'UI siap. Integrasi penyimpanan aman dan tes API menjadi tahap berikutnya.',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('Simpan konfigurasi'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Keamanan: jangan memasukkan API key ke source code atau membagikan APK yang berisi key pribadi. Tahap integrasi akan memakai penyimpanan aman dan backend/proxy untuk melindungi kredensial.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
