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

*   **App Structure:** The app has a well-defined structure with a `main.dart` entry point, a bottom navigation bar for "Bible" and "Lessons", and a drawer for future Bible translation options.
*   **Theming:** A comprehensive theme has been implemented using `ColorScheme.fromSeed` with the specified primary and accent colors. The app supports both light and dark modes, managed by a `ThemeProvider`, with a toggle in the `AppBar`.
*   **Screens:**
    *   `HomeScreen`: The main screen with a bottom navigation bar and a drawer.
    *   `BibleScreen`: Displays a searchable grid of Bible books for easy navigation.
    *   `LessonsScreen`: Displays lessons grouped by age in expandable tiles for a clean and organized view.
    *   `BookScreen`: Shows the chapters of a selected book in a visually appealing grid.
    *   `ChapterScreen`: Presents the verses of a selected chapter in a readable and engaging format.
    *   `LessonDetailScreen`: Provides a detailed view of a lesson with styled introduction and section cards for better readability.
*   **Data Models:**
    *   `Bible`, `Book`, `Chapter`, `Verse`: Models for the Bible structure.
    *   `Lesson`, `Section`: Models for the lesson content.
*   **Services:**
    *   `BibleService`: Provides sample data for the KJV Bible.
    *   `DataService`: Provides a variety of sample lessons for different age groups.
*   **Navigation:** Implemented navigation between screens using `Navigator.push`, ensuring a smooth user flow.

## Next Steps

*   Implement multiple Bible translations and a way for the user to switch between them.
*   Add functionality to download and store lessons locally for offline access.
*   Integrate external links for further study.
*   Add animations and transitions to enhance the user experience.
*   Ensure the app is fully responsive and works well on various screen sizes.
