import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/lesson.dart';
import '../services/lesson_provider.dart';
import '../services/lesson_completion_service.dart';
import 'lesson_detail_screen.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  LessonsScreenState createState() => LessonsScreenState();
}

class LessonsScreenState extends State<LessonsScreen> {
  late Future<List<LessonGroup>> _lessonGroupsFuture;
  final TextEditingController _searchController = TextEditingController();
  List<LessonGroup> _allLessonGroups = [];
  List<LessonGroup> _filteredLessonGroups = [];

  @override
  void initState() {
    super.initState();
    _lessonGroupsFuture = LessonProvider().loadLessons();
    _searchController.addListener(_filterLessons);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLessons() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredLessonGroups = _allLessonGroups;
      } else {
        _filteredLessonGroups = _allLessonGroups
            .map((group) {
              final filteredLessons = group.lessons
                  .where((lesson) =>
                      lesson.title.toLowerCase().contains(query) ||
                      group.title.toLowerCase().contains(query))
                  .toList();
              return LessonGroup(title: group.title, lessons: filteredLessons);
            })
            .where((group) => group.lessons.isNotEmpty)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<LessonGroup>>(
        future: _lessonGroupsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No lessons found.'));
          } else {
            if (_allLessonGroups.isEmpty) {
              _allLessonGroups = snapshot.data!;
              _filteredLessonGroups = _allLessonGroups;
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Lessons',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: _filteredLessonGroups.length,
                      itemBuilder: (context, index) {
                        final lessonGroup = _filteredLessonGroups[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: ExpansionTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/lesson_placeholder.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    lessonGroup.title,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  children: lessonGroup.lessons.map((lesson) {
                                    return LessonTile(lesson: lesson);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class LessonTile extends StatefulWidget {
  final Lesson lesson;

  const LessonTile({super.key, required this.lesson});

  @override
  State<LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile> {
  final LessonCompletionService _completionService = LessonCompletionService();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();
  }

  Future<void> _loadCompletionStatus() async {
    final completed = await _completionService.isLessonCompleted(widget.lesson.title);
    if (mounted) {
      setState(() {
        _isCompleted = completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.lesson.title),
      trailing: _isCompleted
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonDetailScreen(lesson: widget.lesson),
          ),
        ).then((_) => _loadCompletionStatus());
      },
    );
  }
}
