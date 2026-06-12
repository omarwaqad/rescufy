import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rescufy/domain/core/failures.dart';
import 'package:rescufy/domain/entities/request_history.dart';
import 'package:rescufy/domain/repositories/request_history_repository.dart';
import 'package:rescufy/l10n/app_localizations.dart';
import 'package:rescufy/presentation/user/history/cubit/request_history_cubit.dart';
import 'package:rescufy/presentation/user/history/views/request_history_screen.dart';

class _ScreenRepository implements RequestHistoryRepository {
  _ScreenRepository(this._items);

  final List<RequestHistory> _items;

  @override
  Future<Either<Failure, List<RequestHistory>>> getRequestHistory({
    int page = 1,
    int limit = 10,
    String? requestStatus,
    String? sort,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return Right(_items);
  }
}

Future<void> _pumpHistoryScreen(
  WidgetTester tester, {
  required List<RequestHistory> items,
}) async {
  final cubit = RequestHistoryCubit(_ScreenRepository(items));
  await cubit.loadRequestHistory();

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: const RequestHistoryScreen(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('renders empty state when history is empty', (tester) async {
    await _pumpHistoryScreen(tester, items: const []);

    expect(find.text('No Request History'), findsOneWidget);
    expect(find.text('Make Your First Request'), findsOneWidget);
  });

  testWidgets('hides optional rows when values are null', (tester) async {
    await _pumpHistoryScreen(
      tester,
      items: [
        RequestHistory(
          id: 7,
          description: 'Shortness of breath',
          address: '123 Main Street',
          requestStatus: 'Pending',
          createdAt: DateTime.parse('2026-06-10T11:59:39.006Z'),
          patientName: 'John Doe',
        ),
      ],
    );

    expect(find.textContaining('Request ID #7'), findsOneWidget);

    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();

    expect(find.text('Assigned Ambulance Plate'), findsNothing);
    expect(find.text('Driver Name'), findsNothing);
    expect(find.text('Hospital Name'), findsNothing);
  });
}
