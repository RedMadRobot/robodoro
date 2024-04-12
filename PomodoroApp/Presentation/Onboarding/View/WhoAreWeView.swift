//
//  WhoAreWeView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 18.01.2023.
//

import SwiftUI

struct WhoAreWeView: View {
    
    // MARK: - Private Properties
    
    private var onButtonTapped: () -> Void
    
    // MARK: - Init
    
    init(onButtonTapped: @escaping () -> Void) {
        self.onButtonTapped = onButtonTapped
    }
    
    // MARK: - Constants
    
    private enum Constants {
        static let initialY = CGFloat(80)
        static let spacingMultiplyer = CGFloat(1.3)
        static let lineWidth = CGFloat(0.5)
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            backView
            infoView
            buttonView
        }
        .transition(AnyTransition.move(edge: .bottom))
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var backView: some View {
        Colors.averageFocusBlue.swiftUIColor
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .ignoresSafeArea()
        GeometryReader { geometry in
            Path { path in
                let globalFrame = geometry.frame(in: .global)
                let centerX = globalFrame.midX
                let radius = globalFrame.maxX / 2
                let spacing = radius * Constants.spacingMultiplyer
                var y = Constants.initialY
                while y - radius < globalFrame.maxY {
                    path.addArc(
                        center: CGPoint(x: centerX, y: y),
                        radius: radius,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360),
                        clockwise: true)
                    
                    y += spacing
                }
            }
            .stroke(Colors.averageFocusLine.swiftUIColor, lineWidth: Constants.lineWidth)
            .clipShape(RoundedRectangle(cornerRadius: 32))
        }
    }
    
    @ViewBuilder
    private var infoView: some View {
        VStack(spacing: 16) {
            Text(Strings.Onboaring.AboutUs.title)
                .textStyle(.bigTitle)
            Text(Strings.Onboaring.AboutUs.info)
                .textStyle(.regularText)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private var buttonView: some View {
        VStack {
            Spacer()
            Button(Strings.Onboaring.AboutUs.buttonTitle) {
                withAnimation(.linear(duration: 0.3)) {
                    onButtonTapped()
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(16)
        }
    }
}

// MARK: - PreviewProvider

struct WhoAreWeView_Previews: PreviewProvider {
    static var previews: some View {
        WhoAreWeView(onButtonTapped: {})
    }
}
