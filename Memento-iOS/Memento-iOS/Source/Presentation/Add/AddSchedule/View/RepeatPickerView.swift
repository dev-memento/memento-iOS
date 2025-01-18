//
//  RepeatPickerView.swift
//  Memento-iOS
//
//  Created by RAFA on 1/18/25.
//

import SwiftUI

import MDSKit

struct RepeatPickerView: View {

    // MARK: - Properties

   @ObservedObject var viewModel: PickerButtonViewModel
   @StateObject private var repeatViewModel = PickerButtonViewModel(type: .repeat)
   @StateObject private var endRepeatViewModel = PickerButtonViewModel(type: .endRepeat)

   var body: some View {
       VStack(spacing: 14) {
           HStack {
               Text("Repeat")
                   .applyFont(.body_r_16)
                   .foregroundStyle(Color.gray05)
               Spacer()

               PickerButton(
                   type: .repeat,
                   title: viewModel.repeatType.title,
                   titleColor: .gray02,
                   width: 200,
                   action: { repeatViewModel.togglePresentation() },
                   viewModel: repeatViewModel
               )
               .sheet(
                   isPresented: $repeatViewModel.isPresented,
                   onDismiss: { repeatViewModel.dismiss() }
               ) {
                   SheetContainer(height: 350) {
                       VStack {
                           SheetHeaderView {
                               viewModel.updateRepeatType(repeatViewModel.repeatType)
                               repeatViewModel.confirmSelection()
                           }

                           RepeatTypeListView(viewModel: repeatViewModel)
                       }
                   }
               }
           }

           if viewModel.shouldShowEndRepeat {
               HStack {
                   Text("End Repeat")
                       .applyFont(.body_r_16)
                       .foregroundStyle(Color.gray05)
                   Spacer()

                   PickerButton(
                       type: .endRepeat,
                       title: viewModel.endRepeatDate?.formattedDate(with: "MMM d, yyyy") ?? "Select Date",
                       titleColor: viewModel.endRepeatDate == nil ? .mementoBlue : .gray02,
                       width: 200,
                       action: { endRepeatViewModel.togglePresentation() },
                       viewModel: endRepeatViewModel
                   )
                   .sheet(
                       isPresented: $endRepeatViewModel.isPresented,
                       onDismiss: { endRepeatViewModel.dismiss() }
                   ) {
                       BaseSheetView(
                           selection: Binding(
                               get: { viewModel.endRepeatDate ?? Date() },
                               set: { viewModel.updateEndRepeatDate($0) }
                           ),
                           isPresented: $endRepeatViewModel.isPresented,
                           type: .date,
                           minimumDate: Date(),
                           onDismiss: viewModel.confirmSelection
                       )
                   }
               }
               .transition(.opacity)
               .animation(.easeInOut, value: viewModel.shouldShowEndRepeat)
           }
       }
       .padding(.top)
   }
}

#Preview {
   ZStack {
       Color.gray10
           .ignoresSafeArea()

       RepeatPickerView(viewModel: PickerButtonViewModel())
   }
}
