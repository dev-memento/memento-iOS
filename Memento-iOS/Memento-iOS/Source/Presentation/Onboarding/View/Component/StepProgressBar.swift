//
//  StepProgressBar.swift
//  Memento-iOS
//
//  Created by 정정욱 on 1/9/25.
//

import SwiftUI

struct StepProgressBar: View {
    var currentStep: Int
    var totalSteps: Int
    
    var body: some View {
        ProgressView(value: Double(currentStep), total: Double(totalSteps))
            .progressViewStyle(LinearProgressViewStyle(tint: Color("Progress_bar")))
            .frame(height: 6)
            .background(Color("Progress_box"))
            .cornerRadius(10)
    }
}


#Preview {
    StepProgressBar(currentStep: 1, totalSteps: 4)
}
