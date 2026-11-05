import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MahamHazemApp());
}

class MahamHazemApp extends StatelessWidget {
  const MahamHazemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مهام حازم - Maham Hazem',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF8B5CF6),
          secondary: Color(0xFFEC4899),
          surface: Color(0xFF13151F),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// -----------------------------------------------------------------------------
// MODELS
// -----------------------------------------------------------------------------
class Task {
  final String id;
  final String title;
  final String duration;
  final int xp;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.duration,
    required this.xp,
    this.isCompleted = false,
  });
}

class AnimeSensei {
  final String id;
  final String name;
  final String anime;
  final String icon;
  final Color color;
  final String quote;

  AnimeSensei({
    required this.id,
    required this.name,
    required this.anime,
    required this.icon,
    required this.color,
    required this.quote,
  });
}

// -----------------------------------------------------------------------------
// MAIN SCREEN WITH CUSTOM ANIMATED TRANSITIONS
// -----------------------------------------------------------------------------
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _totalXp = 120;
  int _streak = 3;

  final List<AnimeSensei> _senseis = [
    AnimeSensei(
      id: 'gojo',
      name: 'ساتورو غوجو',
      anime: 'Jujutsu Kaisen',
      icon: '👁️⚡',
      color: Colors.cyanAccent,
      quote:
          'استمر في التطور! التقاعس ليس خياراً لأولئك الذين يريدون الوصول للقمة.',
    ),
    AnimeSensei(
      id: 'levi',
      name: 'ليفاي أكرمان',
      anime: 'Attack on Titan',
      icon: '⚔️🔥',
      color: Colors.greenAccent,
      quote:
          'لا تندم على قراراتك، ركز على مهمتك التالية فوراً ونفذها بدون تردد.',
    ),
    AnimeSensei(
      id: 'naruto',
      name: 'ناروتو أوزوماكي',
      anime: 'Naruto',
      icon: '🌀📜',
      color: Colors.orangeAccent,
      quote: 'هذا هو طريقي في النينجا! لن أتراجع عن خطتي ولن أنكث بعهدي!',
    ),
  ];

  late AnimeSensei _selectedSensei;

  final List<Task> _tasks = [
    Task(
        id: '1',
        title: 'مذاكرة 45 دقيقة لغة بايثون',
        duration: '45 دقيقة',
        xp: 50),
    Task(
        id: '2',
        title: 'تمارين رياضية وانضباط حركي',
        duration: '30 دقيقة',
        xp: 30),
  ];

  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSensei = _senseis[0];
  }

  void _addTask() {
    if (_taskController.text.trim().isEmpty) return;
    setState(() {
      _tasks.insert(
        0,
        Task(
          id: DateTime.now().toString(),
          title: _taskController.text,
          duration: '30 دقيقة',
          xp: 40,
        ),
      );
      _taskController.clear();
    });
  }

  void _toggleTask(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted) {
        _totalXp += task.xp;
      } else {
        _totalXp -= task.xp;
      }
    });
  }

  void _deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF13151F),
        elevation: 0,
        title: const Row(
          children: [
            Text('⚡', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text(
              'مهام حازم | Maham Hazem',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orangeAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orangeAccent),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: Colors.orangeAccent, size: 18),
                const SizedBox(width: 4),
                Text('$_streak أيام',
                    style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _buildCurrentTab(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF13151F),
        selectedItemColor: const Color(0xFF8B5CF6),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline), label: 'المهام'),
          BottomNavigationBarItem(
              icon: Icon(Icons.psychology), label: 'المعلم'),
          BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined), label: 'التركيز'),
        ],
      ),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentIndex) {
      case 0:
        return _buildTasksTab();
      case 1:
        return _buildSenseiTab();
      case 2:
        return _buildFocusTimerTab();
      default:
        return _buildTasksTab();
    }
  }

  // ---------------------------------------------------------------------------
  // TAB 1: TASKS LIST WITH ANIMATED CARDS
  // ---------------------------------------------------------------------------
  Widget _buildTasksTab() {
    int level = (_totalXp / 100).floor() + 1;
    double progress = (_totalXp % 100) / 100.0;

    return SingleChildScrollView(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // XP Status Animated Card
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('المستوى $level',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text('$_totalXp XP',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent)),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.black26,
                    color: Colors.amberAccent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Sensei Live Quote Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF13151F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _selectedSensei.color.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Text(_selectedSensei.icon,
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_selectedSensei.name,
                          style: TextStyle(
                              color: _selectedSensei.color,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text('"${_selectedSensei.quote}"',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Add Task Input Box
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                    hintText: 'أضف مهمة جديدة للانضباط...',
                    filled: true,
                    fillColor: const Color(0xFF13151F),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _addTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 20),

          // Animated List of Tasks
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              final task = _tasks[index];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: task.isCompleted
                      ? Colors.green.withOpacity(0.1)
                      : const Color(0xFF13151F),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color:
                        task.isCompleted ? Colors.greenAccent : Colors.white10,
                  ),
                ),
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color:
                          task.isCompleted ? Colors.greenAccent : Colors.grey,
                    ),
                    onPressed: () => _toggleTask(task),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration:
                          task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? Colors.grey : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('+${task.xp} XP • ${task.duration}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.purpleAccent)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: 20),
                    onPressed: () => _deleteTask(task.id),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: SELECT ANIME SENSEI
  // ---------------------------------------------------------------------------
  Widget _buildSenseiTab() {
    return Padding(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('اختر مرشدك في الانضباط:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _senseis.length,
              itemBuilder: (context, index) {
                final sensei = _senseis[index];
                final isSelected = sensei.id == _selectedSensei.id;

                return GestureDetector(
                  onTap: () => setState(() => _selectedSensei = sensei),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13151F),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? sensei.color : Colors.transparent,
                        width: isSelected ? 2 : 0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: sensei.color.withOpacity(0.3),
                                  blurRadius: 10)
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Text(sensei.icon, style: const TextStyle(fontSize: 40)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(sensei.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: sensei.color)),
                              Text(sensei.anime,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              const SizedBox(height: 6),
                              Text('"${sensei.quote}"',
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.white70)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: FOCUS TIMER (POMODORO)
  // ---------------------------------------------------------------------------
  Widget _buildFocusTimerTab() {
    return const FocusTimerWidget(key: ValueKey(2));
  }
}

// -----------------------------------------------------------------------------
// FOCUS TIMER WIDGET WITH BREATHING ANIMATION
// -----------------------------------------------------------------------------
class FocusTimerWidget extends StatefulWidget {
  const FocusTimerWidget({super.key});

  @override
  State<FocusTimerWidget> createState() => _FocusTimerWidgetState();
}

class _FocusTimerWidgetState extends State<FocusTimerWidget>
    with SingleTickerProviderStateMixin {
  int _secondsLeft = 25 * 60;
  Timer? _timer;
  bool _isRunning = false;

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_secondsLeft > 0) {
          setState(() => _secondsLeft--);
        } else {
          _timer?.cancel();
          setState(() => _isRunning = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _secondsLeft ~/ 60;
    int seconds = _secondsLeft % 60;
    String timeStr =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.05).animate(
              CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
            ),
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF13151F),
                border: Border.all(
                  color: _isRunning
                      ? const Color(0xFFEC4899)
                      : const Color(0xFF8B5CF6),
                  width: 6,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_isRunning
                            ? const Color(0xFFEC4899)
                            : const Color(0xFF8B5CF6))
                        .withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Center(
                child: Text(
                  timeStr,
                  style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _toggleTimer,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isRunning ? Colors.redAccent : const Color(0xFF8B5CF6),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            child: Text(
              _isRunning ? 'إيقاف مؤقت' : 'بدأ جلسة الانضباط (25 دقيقة)',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
