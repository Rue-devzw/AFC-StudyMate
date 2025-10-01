# AFC StudyMate Blueprint

## Overview

AFC StudyMate is a mobile application designed to provide a comprehensive and interactive Bible study experience for users of all ages. The app offers access to multiple Bible translations, curated Sunday School lessons, and Wednesday Bible study series, all available for offline use. The app now fetches Bible data from the `api.bible` API, providing a much wider range of translations and ensuring the data is always up-to-date.

## Core Features

*   **Multi-Bible Access:** Access multiple Bible translations from the `api.bible` API.
*   **Offline Access:** Caches Bible data locally for offline access.
*   **Bible Search:** Search for keywords across the entire text of the currently selected Bible.
*   **Local Lesson Storage:** Download and access study lessons locally.
*   **External Resource Alignment:** Open external links for more online-based study content.
*   **Age-Grouped Sunday School Lessons:** Curated lessons for Beginners (2-5), Primary Pals (1st-3rd Grade), Answer (4th-8th Grade), and Search (High School-Adults).
*   **Wednesday Bible Study Series:** Includes the Discovery (High School-Adults) series.
*   **Interactive Lesson Presentation:** Visually interactive lesson designs tailored to each age group.
*   **About Screen:** Provides information about the app, its mission, and its creators.

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

*   **App Structure:** The app has a well-defined structure with a `main.dart` entry point, a bottom navigation bar for "Bible" and "Lessons", and a drawer for Bible translation options and an "About" screen.
*   **Theming and State Management:**
    *   `ThemeProvider`: Manages light and dark modes.
    *   `BibleProvider`: Manages the currently selected Bible translation by its ID, and fetches the list of available Bibles and the content of the selected Bible asynchronously from the `api.bible` API.
*   **Screens:**
    *   `HomeScreen`: The main screen with a bottom navigation bar and a drawer that displays a list of available Bible translations fetched from the `api.bible` API, and a link to the About screen.
    *   `BibleScreen`: Displays a grid of Bible books and includes a search bar in the `AppBar` to allow users to search the Bible.
    *   `SearchScreen`: Displays the results of a Bible search in a list view.
    *   `LessonsScreen`: Displays lessons grouped by age in expandable tiles. The list features staggered fade-in and slide animations.
    *   `BookScreen`: Dynamically displays the chapters of the selected Bible book, fetched asynchronously using a `FutureBuilder`.
    *   `ChapterScreen`: Dynamically displays the verses of the selected chapter, fetched asynchronously using a `FutureBuilder`.
    *   `LessonDetailScreen`: Provides a detailed view of a lesson with styled introduction and section cards, and a button to open external links for further study.
    *   `AboutScreen`: Displays information about the app, its purpose, and its creators.
*   **Data Models:**
    *   `Bible`, `Book`, `Chapter`, `Verse`: Models for the Bible structure, with `fromJson` and `toJson` constructors to deserialize and serialize the data for caching.
    *   `Lesson`, `Section`: Models for the lesson content, with the `Section` model now including a `url` field for external links.
*   **Services:**
    *   `BibleService`: Fetches Bible data from the `api.bible` API and caches it locally using the `CacheService`.
    *   `CacheService`: A service that uses the `shared_preferences` package to store and retrieve Bible data from the local storage.
    *   `DataService`: Provides a variety of sample lessons for different age groups.
*   **Navigation:** Implemented navigation between screens using `Navigator.push`.
*   **Animations:** Added subtle, staggered animations to the `BibleScreen`, `LessonsScreen`, `BookScreen`, and `ChapterScreen` using the `flutter_staggered_animations` package to enhance the user experience.
*   **External Links:** The `LessonDetailScreen` now includes a button that opens a URL in a browser using the `url_launcher` package.
