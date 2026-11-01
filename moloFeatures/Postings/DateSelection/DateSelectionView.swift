//
//  DateSelectionView.swift
//  Postings
//

import Assets
import Atoms
import Dimensions
import Foundation
import Molecules
import Organisms
import Strings
import SwiftUI

public struct DateSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: DateSelectionViewModel

    public init(viewModel: DateSelectionViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                LoadingView()
            case let .success(start, end):
                DateSelection(startDate: start, endDate: end, execute: viewModel.executeIntent(_:))
            }
        }
        .task {
            viewModel.executeIntent(.willAppear)
        }
        .navigationBarBackButtonHidden(true)
        .padding(0)
    }
}

private struct DateSelection: View {
    @State private var startDate: Date
    @State private var endDate: Date

    private let execute: (DateSelectionIntent) -> Void

    init(startDate: Date?, endDate: Date?, execute: @escaping (DateSelectionIntent) -> Void) {
        self.startDate = startDate ?? Date()
        self.endDate = endDate ?? Date().addingTimeInterval(60 * 60)
        self.execute = execute
    }

    var body: some View {
        VStack(spacing: .verticalDefault) {
            Text(L10n.News.Molo.Event.Calendar.select)
                .padding(.verticalDefault)
            GeometryReader { geometry in
                Form {
                    Section(header: Text(L10n.News.Molo.Event.Calendar.startDate)) {
                        DatePicker(L10n.News.Molo.Event.Calendar.start, selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                            .onChange(of: startDate) { _, newStart in
                                if endDate <= newStart {
                                    if let newEndDate = Calendar.current.date(byAdding: .hour, value: 1, to: newStart) {
                                        endDate = newEndDate
                                    }
                                }
                            }
                    }

                    Section(header: Text(L10n.News.Molo.Event.Calendar.endDate)) {
                        DatePicker(L10n.News.Molo.Event.Calendar.end, selection: $endDate,
                                   in: startDate...,
                                   displayedComponents: [.date, .hourAndMinute])
                    }
                }
                .frame(maxHeight: geometry.size.height * 0.6)
            }

            HStack(spacing: .horizontalDefault) {
                Spacer()
                Button(L10n.News.Molo.Event.Calendar.cancel) {
                    execute(.onDateSelectionCancel)
                }
                .padding(.all, .verticalDefault)
                .foregroundStyle(Colors.Text.default.swiftUIColor)
                .background(
                    RoundedRectangle(cornerRadius: .cornerRadiusMedium)
                        .stroke(Colors.Text.default.swiftUIColor, lineWidth: 1)
                )

                Button(L10n.News.Molo.Event.Calendar.ok) {
                    execute(.onDateSelectionSubmit(start: startDate, end: endDate))
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
