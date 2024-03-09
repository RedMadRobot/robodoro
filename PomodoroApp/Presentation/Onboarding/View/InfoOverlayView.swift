//
//  InfoOverlayView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 18.01.2023.
//

import SwiftUI

struct InfoOverlayView: View {
    
    // MARK: - Private Properties
    
    private var onButtonTapped: () -> Void
    
    // MARK: - Init
    
    init(onButtonTapped: @escaping () -> Void) {
        self.onButtonTapped = onButtonTapped
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Colors.black.swiftUIColor.opacity(0.6)
            bannerView
        }
        .ignoresSafeArea()
        .transition(AnyTransition.opacity.animation(.linear(duration: 0.2)))
    }
    
    // MARK: - Private Properties
    
    @ViewBuilder
    private var bannerView: some View {
        VStack {
            Spacer()
            VStack(spacing: 0) {
                Images.alertCircle.swiftUIImage
                    .padding(40)
                Group {
                    Text(Strings.Onboaring.UserTaskStorage.title)
                        .textStyle(.miniTitle)
                        .padding(.bottom, 16)
                    Text(Strings.Onboaring.UserTaskStorage.info)
                        .textStyle(.regularText)
                }
                .padding(.horizontal, 16)
                Button(Strings.Onboaring.UserTaskStorage.buttonTitle) {
                    onButtonTapped()
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                .padding(.top, 40)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(Colors.white.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 26)
    }
}

// MARK: - PreviewProvider

struct InfoOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        InfoOverlayView(onButtonTapped: {})
            .background(Colors.focusRed.swiftUIColor)
    }
}
