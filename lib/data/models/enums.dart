enum Track { beginners, primaryPals, answer, search, discovery, daybreak }

enum Role {
  learner,
  teacher;

  static const List<Role> selectableValues = <Role>[
    Role.learner,
    Role.teacher,
  ];

  static Role fromStorage(String? value) {
    switch (value) {
      case 'teacher':
        return Role.teacher;
      case 'learner':
      case 'parent':
      case 'admin':
      case 'anonymous':
      default:
        return Role.learner;
    }
  }
}

enum Translation { kjv, shona }

enum Testament {
  old,
  newTestament,
}
