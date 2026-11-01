//
//  EventsView.swift
//  Events
//

import Assets
import Atoms
import Dimensions
import Domain
import EventCategoryList
import Molecules
import Strings
import SwiftUI

@MainActor
public struct EventsView: View {
    @AppStorage(L10n.Storage.App.darkMode) private var isDarkMode: Bool?

    @StateObject private var viewModel: EventsViewModel

    @State private var showDatePicker = false
    @State var selectedOption: Int?
    @State private var searchString: String = ""

    @State private var hasLoaded: Bool = false

    @State private var isFilterHidden: Bool = false

    enum dateRangeSelectionIndex: Int {
        case today = 0
        case tomorrow = 1
        case weekend = 2
        case calendar = 3
    }

    private let options: [(icon: Image, label: String)] = [
        (Assets.Icons.Event.segmentedToday.swiftUIImage, L10n.News.Molo.Event.Filter.today),
        (Assets.Icons.Event.segmentedTomorrow.swiftUIImage, L10n.News.Molo.Event.Filter.tomorrow),
        (Assets.Icons.Event.segmentedWeekend.swiftUIImage, L10n.News.Molo.Event.Filter.weekend),
        (Assets.Icons.Event.segmentedCalendar.swiftUIImage, L10n.News.Molo.Event.Filter.calendar)
    ]

    public init(viewModel: EventsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public init() {
        _viewModel = StateObject(wrappedValue: EventsViewModel())
    }

    private var segmentedControlView: some View {
        HStack(alignment: .bottom, spacing: .horizontalSmall) {
            Spacer()

            ForEach(0 ..< options.count, id: \.self) { index in
                VStack(spacing: .verticalSmall) {
                    options[index].icon
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(
                            selectedOption == index ?
                                Colors.Text.eventFilterSelected.swiftUIColor :
                                Colors.Text.eventFilter.swiftUIColor
                        )
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .iconButtonSize, height: .iconButtonSize, alignment: .center)
                        .padding(.top, .verticalSmall)

                    Text(options[index].label)
                        .font(.moloFooterMedium)
                        .foregroundColor(
                            selectedOption == index ?
                                Colors.Text.eventFilterSelected.swiftUIColor :
                                Colors.Text.eventFilter.swiftUIColor
                        )
                        .padding(.bottom, .verticalSmall)
                }
                .padding(.horizontal, .horizontalMedium)
                .contentShape(Rectangle())
                .onTapGesture {
                    checkSegmentedSelectionAndReloadCategories(index: index)
                }
            }

            Spacer()
        }
    }

    public var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .success(categories, searchString):
                EventCategoryListView(
                    categories: categories,
                    searchString: searchString,
                    isOverlayHidden: $isFilterHidden,
                    execute: viewModel.executeIntent
                )
                .zIndex(500)
            }

            if !isFilterHidden {
                VStack {
                    ViewThatFits {
                        if #available(iOS 26.0, *) {
                            segmentedControlView
                                .glassEffect(.regular)
                                .padding(.horizontal, .horizontalNavigationBar)
                            ScrollView(.horizontal, showsIndicators: false) {
                                segmentedControlView
                                    .glassEffect(.regular)
                                    .padding(.horizontal, .horizontalNavigationBar)
                            }
                        } else {
                            segmentedControlView
                            ScrollView(.horizontal, showsIndicators: false) {
                                segmentedControlView
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()
                }
                .zIndex(999)
                .transition(.opacity)
            }
        }
        .task {
            if !hasLoaded {
                hasLoaded = true
                viewModel.executeIntent(.loadEventCategories())
            }
        }
        .onChange(of: isDarkMode) { oldValue, _ in
            if oldValue != nil {
                viewModel.executeIntent(.loadEventCategories())
            }
        }
        .padding(0)
        .sheet(isPresented: $showDatePicker) {
            DatePickerView(viewModel: viewModel, searchString: searchString)
        }
    }

    struct DatePickerView: View {
        @Environment(\.dismiss) private var dismiss
        @ObservedObject private var viewModel: EventsViewModel
        private let searchString: String

        init(viewModel: EventsViewModel, searchString: String) {
            self.viewModel = viewModel
            self.searchString = searchString
        }

        var body: some View {
            VStack(spacing: .verticalDefault) {
                Text(L10n.News.Molo.Event.Calendar.select)
                    .padding(.verticalDefault)

                Form {
                    Section(header: Text(L10n.News.Molo.Event.Calendar.startDate)) {
                        DatePicker(L10n.News.Molo.Event.Calendar.start, selection: Binding<Date>(
                            get: { $viewModel.startDate.wrappedValue ?? Date() },
                            set: { $viewModel.startDate.wrappedValue = $0 }
                        ), displayedComponents: .date)
                            .onChange(of: viewModel.startDate ?? Date()) { _, newStart in
                                if (viewModel.endDate ?? Calendar.current.date(byAdding: .day, value: 1, to: Date())!) < newStart {
                                    viewModel.endDate = Calendar.current.date(byAdding: .day, value: 1, to: newStart)!
                                }
                            }
                    }

                    Section(header: Text(L10n.News.Molo.Event.Calendar.endDate)) {
                        DatePicker(L10n.News.Molo.Event.Calendar.end, selection: Binding<Date>(
                            get: { $viewModel.endDate.wrappedValue ?? Calendar.current.date(byAdding: .day, value: 1, to: Date())! },
                            set: { $viewModel.endDate.wrappedValue = $0 }
                        ), in: (viewModel.startDate ?? Date())..., displayedComponents: .date)
                    }
                }

                HStack(spacing: .horizontalDefault) {
                    Spacer()
                    Button(L10n.News.Molo.Event.Calendar.cancel) {
                        dismiss()
                    }
                    .padding(.all, .verticalDefault)
                    .foregroundStyle(Colors.Text.default.swiftUIColor)
                    .background(
                        RoundedRectangle(cornerRadius: .cornerRadiusMedium)
                            .stroke(Colors.Text.default.swiftUIColor, lineWidth: 1)
                    )

                    Button(L10n.News.Molo.Event.Calendar.ok) {
                        viewModel.executeIntent(.loadEventCategories(searchString: searchString))
                        dismiss()
                    }
                    .padding(.all, .verticalDefault)
                    .foregroundStyle(Colors.Text.default.swiftUIColor)
                    .background(
                        RoundedRectangle(cornerRadius: .cornerRadiusMedium)
                            .stroke(Colors.Text.default.swiftUIColor, lineWidth: 1)
                    )
                }
                .frame(maxWidth: .infinity)

                Spacer()
            }
            .padding(.horizontalDefault)
        }
    }

    func checkSegmentedSelectionAndReloadCategories(index: Int) {
        if selectedOption == index {
            selectedOption = nil
            viewModel.startDate = nil
            viewModel.endDate = nil

            viewModel.executeIntent(.loadEventCategories(searchString: searchString))
        } else {
            if index == dateRangeSelectionIndex.calendar.rawValue {
                showDatePicker = true
            }
            if index == dateRangeSelectionIndex.today.rawValue {
                viewModel.startDate = Date()
                viewModel.endDate = Date()
            } else if index == dateRangeSelectionIndex.tomorrow.rawValue {
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                viewModel.startDate = tomorrow
                viewModel.endDate = tomorrow
            } else if index == dateRangeSelectionIndex.weekend.rawValue {
                if let nextWeekend = Calendar.current.nextWeekend(startingAfter: Date()) {
                    viewModel.startDate = nextWeekend.start
                    viewModel.endDate = nextWeekend.end
                }
            }
            selectedOption = index
            viewModel.executeIntent(.loadEventCategories(searchString: searchString))
        }
    }
}

#Preview("light") {
    EventsView(
        viewModel: EventsViewModel()
    )
    .colorScheme(.light)
}

#Preview("dark") {
    EventsView(
        viewModel: EventsViewModel()
    )
    .colorScheme(.dark)
}
