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

*   **App Structure:** Basic app structure with a `main.dart` file and a bottom navigation bar for "Bible" and "Lessons" tabs.
*   **Theming:** Implemented a theme using `ColorScheme.fromSeed` with the specified primary color, and the 'PT Sans' and 'Playfair' fonts. A `ThemeProvider` manages the theme state, and a theme toggle is available in the `AppBar`.
*   **Screens:**
    *   `BibleScreen`: Displays a list of Bible books.
    *   `LessonsScreen`: Displays a list of available lessons.
    *   `BookScreen`: Displays chapters of a selected book in a grid.
    *   `ChapterScreen`: Displays verses of a selected chapter.
    *   `LessonDetailScreen`: Displays the details of a selected lesson.
*   **Data Models:**
    *   `Bible`: Represents the Bible with a translation and a list of books.
    *   `Book`: Represents a book of the Bible with a name and a list of chapters.
    *   `Chapter`: Represents a chapter with a number and a list of verses.
    *   `Verse`: Represents a verse with a number and text.
    *   `Lesson`: Represents a lesson with a title, date, introduction, and sections.
    *   `Section`: Represents a section of a lesson with a title and content.
*   **Services:**
    *   `BibleService`: Provides sample data for the Bible (KJV with Genesis, Exodus, Leviticus).
    *   `DataService`: Provides sample data for two lessons.
*   **Navigation:** Basic navigation between screens using `Navigator.push`.
