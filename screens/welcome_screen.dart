import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Importar flutter_animate
import '../providers/theme_provider.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Definição de cores para o gradiente
    final List<Color> lightGradientColors = [
      Theme.of(context).colorScheme.primary.withOpacity(0.9), // Cor primária mais suave
      Theme.of(context).colorScheme.primary, // Cor primária original
    ];
    final List<Color> darkGradientColors = [
      const Color(0xFF0F0F1A), // Um azul escuro quase preto
      const Color(0xFF1E1E3A), // Um azul escuro um pouco mais claro
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, // Gradiente mais dinâmico
            end: Alignment.bottomRight,
            colors: isDarkMode ? darkGradientColors : lightGradientColors,
          ),
        ),
        child: SafeArea( // Garante que o conteúdo não invada a área da barra de status
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20), // Ajustar top padding
                child: Align(
                  alignment: Alignment.topRight,
                  child: Animate( // Animação para o Switch
                    effects: const [FadeEffect(), SlideEffect(begin: Offset(0.5, 0))],
                    child: Switch.adaptive(
                      value: isDarkMode,
                      onChanged: (value) {
                        themeProvider.toggleTheme(value);
                      },
                      activeColor: Colors.white.withOpacity(0.9), // Cor de ativação suave
                      inactiveThumbColor: Colors.grey[400],
                      inactiveTrackColor: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: AnimateList( // Animação para os elementos centrais
                    interval: 100.ms, // Intervalo entre as animações
                    effects: [FadeEffect(duration: 500.ms), SlideEffect(begin: Offset(0, 50), end: Offset(0,0))],
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 150, // Logo maior
                        height: 150,
                        color: Colors.white, // O logo em si deve ser branco, o ícone dentro dele
                      ),
                      const SizedBox(height: 25), // Aumentar espaçamento
                      Text(
                        'Task Master', // Nome ligeiramente alterado para dar um toque "profissional"
                        style: const TextStyle(
                          fontSize: 40, // Título maior
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5, // Espaçamento entre letras para estilo
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Sua jornada de produtividade começa aqui!', // Slogan mais engajador
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withOpacity(0.9), // Texto um pouco mais opaco
                          fontStyle: FontStyle.italic, // Estilo itálico para o slogan
                        ),
                      ),
                      const SizedBox(height: 50),
                      _buildFeatureItem(Icons.task_alt, 'Organização impecável das tarefas'),
                      _buildFeatureItem(Icons.notifications_active, 'Lembretes inteligentes e pontuais'), // Ícone mais ativo
                      _buildFeatureItem(Icons.calendar_month, 'Prazos flexíveis e visão clara'), // Ícone e texto mais claros
                      _buildFeatureItem(Icons.insights, 'Análise de progresso intuitiva'), // Novo recurso
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 40), // Ajustar padding do botão
                child: Animate( // Animação para o botão
                  effects: [FadeEffect(delay: 500.ms, duration: 800.ms), ScaleEffect(delay: 500.ms, begin: Offset(0.8, 0.8))],
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Botão branco
                      foregroundColor: Theme.of(context).colorScheme.primary, // Texto na primary color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Bordas bem arredondadas
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18), // Aumentar padding vertical
                      minimumSize: const Size(double.infinity, 0), // Ocupa toda largura
                      elevation: 8, // Sombra sutil para o botão
                    ),
                    child: const Text(
                      'COMEÇAR MINHA JORNADA', // Texto mais convidativo
                      style: TextStyle(
                        fontSize: 18, // Texto maior
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8, // Espaçamento entre letras
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40), // Aumentar padding vertical
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinhar texto e ícone no topo
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.9), size: 28), // Ícone maior e mais opaco
          const SizedBox(width: 20), // Aumentar espaçamento
          Expanded( // Garante que o texto ocupe o espaço restante
            child: Text(
              text,
              style: TextStyle(
                fontSize: 17, // Texto ligeiramente maior
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    ).animate(
      effects: [FadeEffect(duration: 500.ms), const SlideEffect(begin: Offset(0, 50), end: Offset(0,0))] // Animação para cada item de recurso
    );
  }
}