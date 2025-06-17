import 'package:flutter/material.dart';
import 'dart:math'; // Necessário para cálculos de seno e cosseno para o arco

class StatsScreen extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const StatsScreen({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;
    final pendingTasks = totalTasks - completedTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suas Estatísticas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Centraliza o título da AppBar
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white), // Ícone de voltar branco
      ),
      body: SingleChildScrollView( // Permite rolagem se o conteúdo for maior que a tela
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Estica os elementos na largura
          children: [
            // Card Principal de Progresso Geral
            Card(
              elevation: 8, // Sombra mais proeminente
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Bordas mais arredondadas
              ),
              child: Padding(
                padding: const EdgeInsets.all(30), // Mais padding interno
                child: Column(
                  children: [
                    Text(
                      'Progresso Geral',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 200, // Um pouco maior
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 16, // Mais espesso
                            backgroundColor: Colors.grey[300], // Fundo mais claro
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.secondary, // Usar secondary color para destaque
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${(progress * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 40, // Porcentagem maior
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const Text(
                                'de tarefas concluídas',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Cards de Estatísticas Individuais
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatCard(
                          context,
                          'Total',
                          '$totalTasks',
                          Icons.assignment_outlined,
                          Colors.blueAccent, // Cor para Total
                        ),
                        _buildStatCard(
                          context,
                          'Concluídas',
                          '$completedTasks',
                          Icons.check_circle_outline,
                          Colors.green, // Cor para Concluídas
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Seção de Análise Detalhada (com um gráfico de pizza simples)
            if (totalTasks > 0)
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                      Text(
                        'Distribuição das Tarefas',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CustomPaint(
                          painter: _PieChartPainter(
                            completedPercentage: progress,
                            completedColor: Colors.green,
                            pendingColor: Colors.redAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Legenda do gráfico
                      _buildLegendItem(
                        context,
                        'Tarefas Concluídas',
                        Colors.green,
                        completedTasks,
                      ),
                      const SizedBox(height: 10),
                      _buildLegendItem(
                        context,
                        'Tarefas Pendentes',
                        Colors.redAccent,
                        pendingTasks,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget para os cards de estatísticas individuais
  Widget _buildStatCard(
      BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded( // Garante que o card ocupe o espaço disponível
      child: Card(
        elevation: 4, // Sombra suave
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Icon(icon, size: 36, color: color), // Ícone maior com cor temática
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24, // Valor maior
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para itens da legenda do gráfico
  Widget _buildLegendItem(
      BuildContext context, String title, Color color, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$title ($count)',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

// CustomPainter para o Gráfico de Pizza Simples
class _PieChartPainter extends CustomPainter {
  final double completedPercentage;
  final Color completedColor;
  final Color pendingColor;

  _PieChartPainter({
    required this.completedPercentage,
    required this.completedColor,
    required this.pendingColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Pintar o segmento de tarefas pendentes (complementar ao concluído)
    final pendingSweepAngle = (1 - completedPercentage) * 2 * pi;
    final pendingPaint = Paint()..color = pendingColor..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2 + (completedPercentage * 2 * pi), // Começa após o segmento concluído
      pendingSweepAngle,
      true,
      pendingPaint,
    );

    // Pintar o segmento de tarefas concluídas
    final completedSweepAngle = completedPercentage * 2 * pi;
    final completedPaint = Paint()..color = completedColor..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Começa do topo
      completedSweepAngle,
      true,
      completedPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) {
    return oldDelegate.completedPercentage != completedPercentage ||
           oldDelegate.completedColor != completedColor ||
           oldDelegate.pendingColor != pendingColor;
  }
}