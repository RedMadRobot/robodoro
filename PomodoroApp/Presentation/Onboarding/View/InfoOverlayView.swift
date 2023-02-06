//
//  InfoOverlayView.swift
//  PomodoroApp
//
//  Created by Петр Тартынских  on 18.01.2023.
//

import SwiftUI

struct InfoOverlayView: View {
    
    // MARK: - Private Properties
    
    private var onButtonClick: () -> Void
    
    // MARK: - Init
    
    init(onButtonClick: @escaping () -> Void) {
        self.onButtonClick = onButtonClick
    }
    
    // MARK: - View
    
    var body: some View {
        ZStack {
            Color(Colors.black).opacity(0.6)
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
                Image(uiImage: Images.alertCircle)
                    .padding(40)
                Group {
                    Text("We store your tasks\nfor a week")
                        .font(.miniTitle)
                        .padding(.bottom, 16)
                    Text("At the start of a week you can check out previous results and then we will delete it")
                        .font(.regularText)
                }
                .padding(.horizontal, 16)
                Button("OKAY, GOT IT") {
                    onButtonClick()
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
                .padding(.top, 40)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(Color(Colors.white))
            .clipShape(RoundedRectangle(cornerRadius: 32))
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 26)
    }
}

// MARK: - PreviewProvider

struct InfoOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        InfoOverlayView(onButtonClick: {})
            .background(Color(Colors.focusRed))
    }
}
