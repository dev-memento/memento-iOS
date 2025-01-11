//
//  StepProgressBar.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI
import MDSKit

struct StepProgressBar: View {
    var currentStep: Int
    var totalSteps: Int
    
    var body: some View {
        ProgressView(value: Double(currentStep), total: Double(totalSteps))
            .progressViewStyle(LinearProgressViewStyle(
                tint: Color.gray08)
            )
            .frame(height: 6)
            .background(Color.gray10)
            .cornerRadius(10)
    }
}


#Preview {
    StepProgressBar(currentStep: 1, totalSteps: 4)
}
