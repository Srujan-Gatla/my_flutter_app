import 'package:flutter/material.dart';

class ContactInfo {
  final String email;
  final String phone;
  final String location;
  final String githubUsername;
  final String githubUrl;
  final String linkedinName;
  final String linkedinUrl;

  const ContactInfo({
    required this.email,
    required this.phone,
    required this.location,
    required this.githubUsername,
    required this.githubUrl,
    required this.linkedinName,
    required this.linkedinUrl,
  });
}

class SkillCategory {
  final String categoryName;
  final IconData icon;
  final Color accentColor;
  final List<String> skills;

  const SkillCategory({
    required this.categoryName,
    required this.icon,
    required this.accentColor,
    required this.skills,
  });
}

class ExperienceItem {
  final String company;
  final String role;
  final String period;
  final String location;
  final String description;
  final List<String> highlights;
  final List<String> tags;
  final bool isCurrent;
  final IconData icon;

  const ExperienceItem({
    required this.company,
    required this.role,
    required this.period,
    required this.location,
    required this.description,
    required this.highlights,
    required this.tags,
    this.isCurrent = false,
    this.icon = Icons.work_outline_rounded,
  });
}

class ProjectItem {
  final String title;
  final String category;
  final String description;
  final List<String> techStack;
  final List<String> keyFeatures;
  final IconData icon;
  final Color accentColor;

  const ProjectItem({
    required this.title,
    required this.category,
    required this.description,
    required this.techStack,
    required this.keyFeatures,
    required this.icon,
    required this.accentColor,
  });
}

class EducationItem {
  final String degree;
  final String institution;
  final String score;
  final String period;
  final String details;
  final IconData icon;

  const EducationItem({
    required this.degree,
    required this.institution,
    required this.score,
    required this.period,
    required this.details,
    required this.icon,
  });
}

class PortfolioData {
  static const String name = 'Srujan Gatla';
  static const String title = 'AI/ML Engineer & Full Stack Developer';
  static const String subtitle = 'AI/ML Engineer | Full Stack & Mobile Developer';
  static const String initials = 'SG';

  static const String professionalSummary =
      'AI/ML Engineer and CS student experienced in Python, AI application integration '
      '(Google Gemini AI), mobile development (Flutter/Dart), and full-stack web platforms '
      '(React, Node, MongoDB, Supabase, PostgreSQL). Dedicated to crafting intuitive, performant '
      'cross-platform mobile apps and resilient AI-driven workflows.';

  static const ContactInfo contact = ContactInfo(
    email: 'srujangatla4@gmail.com',
    phone: '+91-9063966908',
    location: 'Hyderabad, Telangana, India',
    githubUsername: 'Srujan-Gatla',
    githubUrl: 'https://github.com/Srujan-Gatla',
    linkedinName: 'Srujan Gatla',
    linkedinUrl: 'https://linkedin.com/in/srujan-gatla',
  );

  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      categoryName: 'AI & Core Engineering',
      icon: Icons.psychology_rounded,
      accentColor: Color(0xFF8B5CF6),
      skills: [
        'Google Gemini AI Integration',
        'AI-Assisted Document Processing',
        'Async Programming',
        'JWT Auth',
        'State Management',
      ],
    ),
    SkillCategory(
      categoryName: 'Mobile & Web Development',
      icon: Icons.phone_android_rounded,
      accentColor: Color(0xFF00E5FF),
      skills: [
        'Flutter',
        'React.js',
        'HTML5',
        'CSS3',
        'Tailwind CSS',
      ],
    ),
    SkillCategory(
      categoryName: 'Programming Languages',
      icon: Icons.code_rounded,
      accentColor: Color(0xFFEC4899),
      skills: [
        'Python',
        'JavaScript',
        'Dart',
        'SQL',
        'C',
      ],
    ),
    SkillCategory(
      categoryName: 'Backend & Databases',
      icon: Icons.dns_rounded,
      accentColor: Color(0xFF10B981),
      skills: [
        'Node.js',
        'Express.js',
        'REST APIs',
        'MongoDB',
        'PostgreSQL',
        'Supabase',
      ],
    ),
    SkillCategory(
      categoryName: 'Tools & Workflow',
      icon: Icons.build_circle_rounded,
      accentColor: Color(0xFFF59E0B),
      skills: [
        'Git',
        'GitHub',
        'Android Studio',
        'VS Code',
        'Postman',
      ],
    ),
  ];

  static const List<ExperienceItem> experiences = [
    ExperienceItem(
      company: 'Ozrit',
      role: 'Flutter Developer Intern',
      period: 'May 2026 – Present',
      location: 'Hyderabad, India',
      description:
          'Engineering cross-platform mobile solutions using Flutter and Dart with focus on clean architecture and high frame rate performance.',
      highlights: [
        'Building cross-platform mobile apps using Flutter/Dart with responsive glassmorphic layouts.',
        'Integrating REST APIs and external endpoints with robust error handling.',
        'Architecting reactive state management and optimizing UI render cycles.',
      ],
      tags: ['Flutter', 'Dart', 'REST APIs', 'State Management', 'UI Optimization'],
      isCurrent: true,
      icon: Icons.phone_iphone_rounded,
    ),
    ExperienceItem(
      company: 'DevGnan',
      role: 'Full Stack Developer Intern',
      period: 'Jan 2026 – May 2026',
      location: 'Hyderabad, India',
      description:
          'Developed robust server-side APIs and full-stack application integrations with secure authentication layers.',
      highlights: [
        'Designed and implemented production-grade RESTful APIs with Node.js and Express.',
        'Implemented secure JWT-based authentication and role-based access control.',
        'Collaborated on database schema design and frontend client integration.',
      ],
      tags: ['Node.js', 'Express.js', 'REST APIs', 'JWT Auth', 'Full Stack'],
      icon: Icons.layers_rounded,
    ),
    ExperienceItem(
      company: 'Edunet Foundation IBM SkillsBuild',
      role: 'Frontend Development Intern',
      period: 'Aug 2025 – Oct 2025',
      location: 'Virtual / Hyderabad',
      description:
          'Specialized in modern responsive frontend engineering and accessible web standards under IBM SkillsBuild program.',
      highlights: [
        'Built dynamic and accessible UI components using modern JavaScript and CSS.',
        'Applied responsive design patterns across diverse screen resolutions.',
      ],
      tags: ['Frontend', 'JavaScript', 'HTML/CSS', 'Responsive Design'],
      icon: Icons.web_rounded,
    ),
    ExperienceItem(
      company: 'CITD, Hyderabad',
      role: 'IoT Intern',
      period: 'Aug 2024 – Sep 2024',
      location: 'Hyderabad, Telangana',
      description:
          'Conducted hands-on hardware and embedded system integrations utilizing Raspberry Pi and Python scripting.',
      highlights: [
        'Learned core IoT fundamentals and sensor interfacing using Raspberry Pi hardware.',
        'Programmed Python automation scripts for telemetry collection and serial data processing.',
      ],
      tags: ['IoT', 'Raspberry Pi', 'Python', 'Sensors', 'Embedded Systems'],
      icon: Icons.memory_rounded,
    ),
  ];

  static const List<ProjectItem> projects = [
    ProjectItem(
      title: 'IAOMS Academic Affairs Management System',
      category: 'Full Stack & AI Automation',
      description:
          'Comprehensive enterprise workflow automation and academic affairs portal automating institutional workflows and document intelligence.',
      techStack: [
        'React',
        'TypeScript',
        'Node.js',
        'Supabase',
        'PostgreSQL',
        'Google Gemini AI',
      ],
      keyFeatures: [
        'AI-powered document processing powered by Google Gemini AI API.',
        'Real-time database sync and row-level security with Supabase & PostgreSQL.',
        'Interactive faculty, student, and administration role dashboards.',
      ],
      icon: Icons.account_balance_rounded,
      accentColor: Color(0xFF8B5CF6),
    ),
    ProjectItem(
      title: 'Movie Application',
      category: 'Cross-Platform Mobile App',
      description:
          'Modern media exploration app fetching and streaming real-time cinematic catalogs with instant search and detailed insights.',
      techStack: ['Flutter', 'Dart', 'OMDb API', 'REST API', 'JSON Parsing'],
      keyFeatures: [
        'Real-time live queries to the OMDb API with fast debounced searching.',
        'Rich detailed views with ratings, poster carousels, genre pills, and cast information.',
        'Smooth transitions and offline caching placeholders.',
      ],
      icon: Icons.movie_filter_rounded,
      accentColor: Color(0xFF00E5FF),
    ),
    ProjectItem(
      title: 'To-Do Application',
      category: 'Productivity Mobile App',
      description:
          'Sleek, fluid task organizer featuring swipe interactions, priority tagging, and dynamic state updates.',
      techStack: ['Flutter', 'Dart', 'ListView.builder', 'setState()', 'Custom Animations'],
      keyFeatures: [
        'High performance dynamic item rendering via ListView.builder.',
        'Local state management handling creation, completion, and deletion.',
        'Haptic touch feedbacks and subtle swipe gestures.',
      ],
      icon: Icons.checklist_rounded,
      accentColor: Color(0xFF10B981),
    ),
    ProjectItem(
      title: 'Responsive E-Commerce Frontend',
      category: 'Web Platform UI/UX',
      description:
          'High-converting mobile-friendly storefront with smooth cart animations, filterable product grids, and instant checkout flow.',
      techStack: ['HTML5', 'CSS3', 'JavaScript', 'Mobile-First Design'],
      keyFeatures: [
        'Fluid fluid layout system adapting from small smartphones to wide 4K screens.',
        'Interactive shopping cart drawer with live price calculations.',
        'Optimized asset loading with clean modular CSS architecture.',
      ],
      icon: Icons.shopping_bag_rounded,
      accentColor: Color(0xFFEC4899),
    ),
  ];

  static const List<EducationItem> education = [
    EducationItem(
      degree: 'B.Tech in CSE (Internet of Things)',
      institution: 'HITAM (Hyderabad Institute of Technology and Management)',
      score: 'CGPA: 8.0',
      period: '2022 – 2026',
      details:
          'Specialized curriculum encompassing IoT architectures, data structures, algorithms, AI systems, cloud computing, and mobile engineering.',
      icon: Icons.school_rounded,
    ),
    EducationItem(
      degree: 'Intermediate (MPC - Maths, Physics, Chemistry)',
      institution: 'NSR Impulse Junior College',
      score: 'CGPA: 9.2',
      period: '2020 – 2022',
      details:
          'Solid analytical foundation in advanced mathematics, analytical physics, and chemistry with distinction.',
      icon: Icons.menu_book_rounded,
    ),
  ];

  static const List<String> interests = [
    'Artificial Intelligence & LLMs',
    'Google Gemini AI Integration',
    'Flutter & Cross-Platform UI/UX',
    'Glassmorphic Design Systems',
    'Scalable Cloud Architecture',
    'IoT & Embedded Hardware',
    'Full-Stack Web Innovation',
    'Open Source Contribution',
  ];
}
