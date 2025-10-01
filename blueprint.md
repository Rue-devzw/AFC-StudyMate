# AFC StudyMate Blueprint

## Overview

AFC StudyMate is a mobile application designed to provide a comprehensive and interactive Bible study experience for users of all ages. The app offers access to multiple Bible translations, curated Sunday School lessons, and Wednesday Bible study series, all available for offline use.

## Core Features

*   **Multi-Bible Access:** Access multiple Bible translations (KJV, AMP, Ndebele, Shona, Portuguese) offline.
*   **Local Lesson Storage:** Download and access study lessons locally.
*   **External Resource Alignment:** Open external links for more online-based study content.
*   **Age-Grouped Sunday School Lessons:** Curated lessons for Beginners (2-5), Primary Pals (1st-3rd Grade), Answer (4th-8th Grade), and Search (High School-Adults).
*   **Wednesday Bible Study Series:** Includes the Discovery (High School-Adults) series.
*   **Interactive Lesson Presentation:** Visually interactive lesson designs tailored to each age group.

## Style Guidelines

*   **Primary Color:** Deep blue (`#3F51B5`)
*   **Background Color:** Very light blue (`#E8EAF6`)
*   **Accent Color:** Yellow-orange (`#FFAB40`)
*   **Body Text:** 'PT Sans', sans-serif
*   **Headline Text:** 'Playfair', serif
*   **Iconography:** Clear, age-appropriate icons for navigation and lesson topics.
*   **Layout:** Age-appropriate, readable layout for textual lesson content.
*   **Transitions:** Subtle transitions between Bible verses and lesson sections.

## Current Implementation

*   **App Structure:** The app has a well-defined structure with a `main.dart` entry point, a bottom navigation bar for "Bible" and "Lessons", and a drawer for Bible translation options.
*   **Theming and State Management:**
    *   `ThemeProvider`: Manages light and dark modes.
    *   `BibleProvider`: Manages the currently selected Bible translation, allowing the user to switch between different versions (KJV, Amplified, Ndebele).
*   **Screens:**
    *   `HomeScreen`: The main screen with a bottom navigation bar and a drawer that allows switching between the "King James Version", "Amplified Version", and "Ndebele Version".
    *   `BibleScreen`: Displays a searchable grid of Bible books. The list features staggered fade-in and scale animations.
    *   `LessonsScreen`: Displays lessons grouped by age in expandable tiles. The list features staggered fade-in and slide animations.
    *   `BookScreen`: Dynamically displays the chapters of the selected Bible translation from the `BibleProvider`. The chapter grid is animated.
    *   `ChapterScreen`: Dynamically displays the verses of the selected chapter from the `BibleProvider`. The verse list is animated.
    *   `LessonDetailScreen`: Provides a detailed view of a lesson with styled introduction and section cards.
*   **Data Models:**
    *   `Bible`, `Book`, `Chapter`, `Verse`: Models for the Bible structure.
    *   `Lesson`, `Section`: Models for the lesson content.
*   **Services:**
    *   `BibleService`: Provides sample data for the KJV, Amplified, and Ndebele Bible versions.
    *   `DataService`: Provides a variety of sample lessons for different age groups.
*   **Navigation:** Implemented navigation between screens using `Navigator.push`.
*   **Animations:** Added subtle, staggered animations to the `BibleScreen`, `LessonsScreen`, `BookScreen`, and `ChapterScreen` using the `flutter_staggered_animations` package to enhance the user experience.

## Next Steps

*   Add the remaining Bible translations (Shona, Portuguese) with their corresponding data.
*   Implement local storage for offline access to Bibles and lessons.
*   Integrate external links for further study within the lesson details.
*   Ensure the app is fully responsive and works well on various screen sizes.
