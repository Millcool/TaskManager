import SwiftUI
import SwiftData

struct GoalsTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = GoalsViewModel()
    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Period segment
                Picker("Период", selection: Binding(
                    get: { viewModel.selectedPeriod },
                    set: { viewModel.selectPeriod($0) }
                )) {
                    ForEach(GoalPeriod.allCases, id: \.self) { period in
                        Text(period.shortTitle).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, AppTheme.horizontalPadding)
                .padding(.top, 8)

                // Period navigator
                PeriodNavigatorView(
                    title: viewModel.periodTitle,
                    onPrevious: { viewModel.navigatePeriod(direction: -1) },
                    onNext: { viewModel.navigatePeriod(direction: 1) },
                    onToday: { viewModel.goToToday() }
                )
                .padding(.vertical, 12)

                // Goals list
                if viewModel.goals.isEmpty {
                    Spacer()
                    EmptyStateView(
                        icon: "target",
                        title: "Нет целей",
                        subtitle: "Нажмите +, чтобы добавить цель на этот период"
                    )
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(Array(viewModel.goals.enumerated()), id: \.element.id) { index, goal in
                                NavigationLink(destination: GoalDetailView(goal: goal, viewModel: viewModel)) {
                                    GoalRowView(
                                        goal: goal,
                                        isTaskOfTheDay: index == 0 && viewModel.selectedPeriod == .day
                                    )
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    if goal.status != .completed {
                                        Button {
                                            viewModel.setStatus(goal, status: .completed)
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        } label: {
                                            Label("Выполнена", systemImage: "checkmark.circle")
                                        }
                                    }

                                    if goal.status != .failed {
                                        Button {
                                            viewModel.setStatus(goal, status: .failed)
                                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                        } label: {
                                            Label("Не выполнена", systemImage: "xmark.circle")
                                        }
                                    }

                                    if goal.status != .new {
                                        Button {
                                            viewModel.setStatus(goal, status: .new)
                                        } label: {
                                            Label("Сбросить", systemImage: "arrow.uturn.backward")
                                        }
                                    }

                                    Divider()

                                    Button {
                                        viewModel.moveGoalUp(goal)
                                    } label: {
                                        Label("Переместить выше", systemImage: "arrow.up")
                                    }
                                    .disabled(index == 0)

                                    Button {
                                        viewModel.moveGoalDown(goal)
                                    } label: {
                                        Label("Переместить ниже", systemImage: "arrow.down")
                                    }
                                    .disabled(index == viewModel.goals.count - 1)

                                    Divider()

                                    Button {
                                        viewModel.moveToPreviousPeriod(goal)
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    } label: {
                                        Label("На предыдущий период", systemImage: "arrow.left.to.line")
                                    }

                                    Button {
                                        viewModel.moveToNextPeriod(goal)
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    } label: {
                                        Label("На следующий период", systemImage: "arrow.right.to.line")
                                    }

                                    Divider()

                                    Button(role: .destructive) {
                                        viewModel.deleteGoal(goal)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        viewModel.deleteGoal(goal)
                                    } label: {
                                        Label("Удалить", systemImage: "trash")
                                    }

                                    Button {
                                        viewModel.moveToNextPeriod(goal)
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    } label: {
                                        Label("Перенести", systemImage: "arrow.right")
                                    }
                                    .tint(AppColors.accent)
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    Button {
                                        let newStatus: GoalStatus = goal.status == .completed ? .new : .completed
                                        viewModel.setStatus(goal, status: newStatus)
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    } label: {
                                        Label(
                                            goal.status == .completed ? "Сбросить" : "Выполнена",
                                            systemImage: goal.status == .completed ? "arrow.uturn.backward" : "checkmark.circle"
                                        )
                                    }
                                    .tint(goal.status == .completed ? AppColors.neutral : AppColors.green)

                                    Button {
                                        viewModel.moveToPreviousPeriod(goal)
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    } label: {
                                        Label("Назад", systemImage: "arrow.left")
                                    }
                                    .tint(AppColors.accent)
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.horizontalPadding)
                        .padding(.bottom, 20)
                    }
                }
            }
            .background(AppColors.background)
            .overlay(alignment: .bottom) {
                if viewModel.showUndoSnackbar {
                    UndoSnackbarView(
                        goalName: viewModel.deletedGoalName,
                        onUndo: {
                            viewModel.undoDelete()
                        }
                    )
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: viewModel.showUndoSnackbar)
            .navigationTitle("Цели")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                            .foregroundStyle(AppColors.accent)
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                GoalFormView(mode: .create, viewModel: viewModel)
            }
            .onAppear {
                viewModel.setup(modelContext: modelContext)
            }
        }
    }
}
