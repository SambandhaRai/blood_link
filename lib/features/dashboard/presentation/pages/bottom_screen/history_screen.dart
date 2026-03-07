import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/history/history_list.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(requestViewModelProvider.notifier).getMyHistory();
    });
  }

  Future<void> _loadHistory() async {
    await ref.watch(requestViewModelProvider.notifier).getMyHistory();
  }

  Future<void> _handleFinishRequest(String requestId) async {
    await ref.read(requestViewModelProvider.notifier).finishRequest(requestId);
    if (!mounted) return;

    final state = ref.read(requestViewModelProvider);
    if (state.status == RequestStatus.error) {
      SnackbarUtils.showError(
        context,
        state.errorMessage ?? "Failed to finish request.",
      );
      return;
    }

    SnackbarUtils.showSuccess(context, "Request finished successfully.");
    await _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(requestViewModelProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 380;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 80,
        titleSpacing: 0,
        title: Text(
          "History",
          style: TextStyle(
            fontFamily: "BricolageGrotesque SemiBold",
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(12, compact ? 12 : 14, 12, 6),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade700,
                  labelStyle: TextStyle(
                    fontFamily: "BricolageGrotesque SemiBold",
                    fontSize: compact ? 12 : 14,
                  ),
                  tabs: const [
                    Tab(child: FittedBox(child: Text("Ongoing"))),
                    Tab(child: FittedBox(child: Text("Received"))),
                    Tab(child: FittedBox(child: Text("Donated"))),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  HistoryList(
                    title: "No ongoing requests.",
                    requestState: requestState,
                    requests: requestState.myOngoingRequests,
                    onRetry: _loadHistory,
                    tabType: HistoryTabType.ongoing,
                    onFinishRequest: _handleFinishRequest,
                  ),
                  HistoryList(
                    title: "No received requests.",
                    requestState: requestState,
                    requests: requestState.myReceivedRequests,
                    onRetry: _loadHistory,
                    tabType: HistoryTabType.received,
                    onFinishRequest: _handleFinishRequest,
                  ),
                  HistoryList(
                    title: "No donated requests.",
                    requestState: requestState,
                    requests: requestState.myDonatedRequests,
                    onRetry: _loadHistory,
                    tabType: HistoryTabType.donated,
                    onFinishRequest: _handleFinishRequest,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
