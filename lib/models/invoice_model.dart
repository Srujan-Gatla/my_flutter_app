import 'package:flutter/material.dart';

enum PaymentStatus {
  pending,
  processing,
  paid,
  failed,
  cancelled,
}

class ProjectMilestone {
  final String id;
  final String title;
  final String project;
  final double amount; // in INR
  final String description;
  final List<String> deliverables;
  PaymentStatus status;
  String? paymentId;
  DateTime? paidAt;
  final IconData icon;

  ProjectMilestone({
    required this.id,
    required this.title,
    required this.project,
    required this.amount,
    required this.description,
    required this.deliverables,
    this.status = PaymentStatus.pending,
    this.paymentId,
    this.paidAt,
    this.icon = Icons.assignment_turned_in_rounded,
  });
}

class PaymentResult {
  final bool isSuccess;
  final String? paymentId;
  final String? orderId;
  final String? signature;
  final int? errorCode;
  final String? errorMessage;
  final DateTime timestamp;

  PaymentResult({
    required this.isSuccess,
    this.paymentId,
    this.orderId,
    this.signature,
    this.errorCode,
    this.errorMessage,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory PaymentResult.success({
    required String paymentId,
    String? orderId,
    String? signature,
  }) {
    return PaymentResult(
      isSuccess: true,
      paymentId: paymentId,
      orderId: orderId,
      signature: signature,
    );
  }

  factory PaymentResult.failure({
    int? code,
    String? message,
  }) {
    return PaymentResult(
      isSuccess: false,
      errorCode: code,
      errorMessage: message ?? 'Payment was cancelled or unsuccessful.',
    );
  }
}

class InvoiceMilestonesData {
  static List<ProjectMilestone> getDefaultMilestones() {
    return [
      ProjectMilestone(
        id: 'MS-101',
        title: 'Sprint 1: Architecture & Glassmorphic UI/UX',
        project: 'Mobile Application Delivery',
        amount: 15000.0,
        description:
            'Complete wireframing, high-fidelity Figma to Flutter translation, theme design, and component library.',
        deliverables: [
          'Design tokens & Glassmorphism system',
          'Responsive navigation & layout scaffold',
          'State management architecture setup',
        ],
        icon: Icons.palette_rounded,
      ),
      ProjectMilestone(
        id: 'MS-102',
        title: 'Sprint 2: Core Flutter & REST API Integration',
        project: 'Mobile Application Delivery',
        amount: 25000.0,
        description:
            'Full API service layer, caching, pagination, authentication flows (JWT/OAuth), and offline resilience.',
        deliverables: [
          'REST API integration with error handling',
          'JWT authentication & session refresh',
          'Dynamic state management & test suites',
        ],
        icon: Icons.code_rounded,
      ),
      ProjectMilestone(
        id: 'MS-103',
        title: 'Sprint 3: Google Gemini AI & Workflow Automation',
        project: 'AI-Powered Enterprise Systems',
        amount: 20000.0,
        description:
            'Multimodal Gemini API pipelines, automated document summarization, embedding search, and prompt engineering.',
        deliverables: [
          'Google Gemini API prompt orchestration',
          'Real-time streaming responses & parsing',
          'Security boundaries & API key protection',
        ],
        icon: Icons.psychology_rounded,
      ),
      ProjectMilestone(
        id: 'MS-CUSTOM',
        title: 'Custom Retainer / Freelance Invoicing',
        project: 'Contract Engineering',
        amount: 10000.0,
        description:
            'Custom milestone deposit or retainer invoice defined for ad-hoc features, consultations, or maintenance sprints.',
        deliverables: [
          'Agile engineering hours / custom deliverable',
          'Full source code repository rights',
          'Dedicated review and deployment support',
        ],
        icon: Icons.tune_rounded,
      ),
    ];
  }
}
