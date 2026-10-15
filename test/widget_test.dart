import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/models/portfolio_data.dart';
import 'package:my_flutter_app/screens/main_screen.dart';
import 'package:my_flutter_app/screens/payment_invoice_screen.dart';
import 'package:my_flutter_app/screens/splash_screen.dart';
import 'package:my_flutter_app/widgets/glass_container.dart';

void main() {
  testWidgets('SplashScreen renders name, title, and initials logo',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(autoNavigate: false),
      ),
    );

    // Initial pump
    await tester.pump();

    // Verify name and title are present
    expect(find.text(PortfolioData.name), findsOneWidget);
    expect(find.text(PortfolioData.title), findsOneWidget);
    expect(find.text(PortfolioData.initials), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    // Verify GlassContainers are used
    expect(find.byType(GlassContainer), findsWidgets);
  });

  testWidgets('MainScreen renders tab navigation and switches between all 4 tabs',
      (WidgetTester tester) async {
    // Configure virtual display size for mobile
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const MaterialApp(
        home: MainScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify top bar and default tab (About / Profile)
    expect(find.text('Srujan Gatla'), findsWidgets);
    expect(find.text('About'), findsWidgets);
    expect(find.text('Professional Summary'), findsOneWidget);
    expect(find.text('Technical Arsenal'), findsOneWidget);

    // Switch to Experience Tab (Index 1)
    await tester.tap(find.text('Experience'));
    await tester.pumpAndSettle();
    expect(find.text('Work Experience'), findsOneWidget);
    expect(find.text('Ozrit'), findsOneWidget);
    expect(find.text('Flutter Developer Intern'), findsOneWidget);
    expect(find.text('DevGnan'), findsOneWidget);
    expect(find.text('CITD, Hyderabad'), findsOneWidget);

    // Switch to Projects Tab (Index 2)
    await tester.tap(find.text('Projects'));
    await tester.pumpAndSettle();
    expect(find.text('Featured Projects'), findsOneWidget);
    expect(find.text('IAOMS Academic Affairs Management System'), findsOneWidget);
    expect(find.text('Movie Application'), findsOneWidget);
    expect(find.text('To-Do Application'), findsOneWidget);

    // Switch to Education Tab (Index 3)
    await tester.tap(find.text('Education'));
    await tester.pumpAndSettle();
    expect(find.text('Academic Background'), findsOneWidget);
    expect(find.text('B.Tech in CSE (Internet of Things)'), findsOneWidget);
    expect(find.text('CGPA: 8.0'), findsOneWidget);
    expect(find.text('Intermediate (MPC - Maths, Physics, Chemistry)'), findsOneWidget);
    expect(find.text('CGPA: 9.2'), findsOneWidget);

    // Switch back to About Tab (Index 0)
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.text('Professional Summary'), findsOneWidget);
  });

  testWidgets('PaymentInvoiceScreen renders milestones and triggers checkout receipt',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const MaterialApp(
        home: PaymentInvoiceScreen(initialSimulatedMode: true),
      ),
    );
    await tester.pumpAndSettle();

    // Check title and milestones
    expect(find.text('Milestone Payments'), findsOneWidget);
    expect(find.text('Select Project Milestone'), findsOneWidget);
    expect(find.textContaining('Sprint 1'), findsOneWidget);
    expect(find.textContaining('Sprint 2'), findsOneWidget);
    expect(find.text('Razorpay'), findsWidgets);

    // Tap Pay button (runs in simulated mode in test environment)
    final payBtn = find.textContaining('via Razorpay');
    expect(payBtn, findsOneWidget);
    await tester.ensureVisible(payBtn);
    await tester.pumpAndSettle();
    await tester.tap(payBtn);
    await tester.pump();

    // Fast-forward simulation timer
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump(const Duration(milliseconds: 500));

    // Verify success receipt dialog opens
    expect(find.text('Payment Successful!'), findsOneWidget);
    expect(find.text('Razorpay Verified Digital Receipt'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    // Tap Done to dismiss
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Payment Successful!'), findsNothing);
  });

  testWidgets('No layout overflow across responsive viewports',
      (WidgetTester tester) async {
    final viewports = [
      const Size(390, 844), // iPhone 13/14
      const Size(412, 915), // Pixel 7
      const Size(768, 1024), // iPad / Tablet
      const Size(1200, 800), // Desktop / Web
    ];

    for (final size in viewports) {
      tester.view.physicalSize = size * 2.0;
      tester.view.devicePixelRatio = 2.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: MainScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no render overflows occurred
      expect(tester.takeException(), isNull);

      // Verify PaymentInvoiceScreen responsive layout
      await tester.pumpWidget(
        const MaterialApp(
          home: PaymentInvoiceScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}
