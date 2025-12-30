import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'pdf_parser.dart';

void main() {
  runApp(const KaspiAnalyzerApp());
}

class KaspiAnalyzerApp extends StatelessWidget {
  const KaspiAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kaspi Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AnalysisResult? _result;
  bool _isLoading = false;
  String? _error;

  Future<void> _pickAndAnalyzePdf() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      // Выбираем PDF файл
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;

        // Парсим PDF
        final parser = KaspiPdfParser();
        final analysisResult = await parser.parsePdf(filePath);

        setState(() {
          _result = analysisResult;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Ошибка при анализе файла: $e';
        _isLoading = false;
      });
    }
  }

  void _reset() {
    setState(() {
      _result = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_result != null) {
      return _buildResultScreen();
    } else {
      return _buildUploadScreen();
    }
  }

  Widget _buildUploadScreen() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Kaspi Analyzer',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 60),

                // Кнопка загрузки
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: _isLoading ? null : _pickAndAnalyzePdf,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 50,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          _isLoading
                              ? const CircularProgressIndicator()
                              : const Icon(
                                  Icons.description,
                                  size: 80,
                                  color: Colors.red,
                                ),
                          const SizedBox(height: 20),
                          Text(
                            _isLoading ? 'Анализ...' : 'Загрузить выписку',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Информация о приватности
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Данные не покидают устройство',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                // Ошибка, если есть
                if (_error != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final formatter = NumberFormat('#,###', 'ru_RU');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Kaspi Analyzer',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),

                // Период
                if (_result!.periodStart.isNotEmpty && _result!.periodEnd.isNotEmpty)
                  Text(
                    '${_result!.periodStart} — ${_result!.periodEnd}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),

                const SizedBox(height: 40),

                // Карточка: количество людей
                _buildStatCard(
                  icon: Icons.people,
                  value: '${_result!.peopleCount}',
                  label: _getPeopleLabel(_result!.peopleCount),
                  color: Colors.blue,
                ),

                const SizedBox(height: 20),

                // Карточка: общая сумма
                _buildStatCard(
                  icon: Icons.attach_money,
                  value: '${formatter.format(_result!.totalAmount.round())} ₸',
                  label: 'отправлено',
                  color: Colors.green,
                ),

                const SizedBox(height: 40),

                // Кнопка "Загрузить другую"
                ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Загрузить другую',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 60,
            color: color,
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getPeopleLabel(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'человек';
    } else if ([2, 3, 4].contains(count % 10) && ![12, 13, 14].contains(count % 100)) {
      return 'человека';
    } else {
      return 'человек';
    }
  }
}
