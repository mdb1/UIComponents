//
//  CarouselCardView.swift
//  
//
//  Created by Manu on 28/05/2023.
//

import Foundation
import SwiftUI

/// Carousel Card View.
extension CarouselView {
    struct CardView: View {
        private let model: CarouselCardViewModel
        @State private var isAnimating: Bool = false

        init(model: CarouselCardViewModel) {
            self.model = model
        }

        var body: some View {
            VStack(alignment: .center, spacing: .zero) {
                Image(systemName: model.image)
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding(.bottom, .Spacing.large)
                    .scaleEffect(isAnimating ? 1 : 0.95)
                    .animation(.spring().speed(0.5).repeatForever(), value: isAnimating)
                    .foregroundColor(.accentColor)
                Text(model.title)
                    .font(.headline)
                    .padding(.bottom, .Spacing.medium)
                Text(model.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, .Spacing.large)
                LoadingButton(model.callToAction.title, state: .constant(.initial)) {
                    model.callToAction.action()
                }
                .padding(.bottom, .Spacing.large)
            }
            .padding(.Spacing.medium)
            .multilineTextAlignment(.center)
            .onAppear {
                isAnimating = true
            }
        }
    }
}

struct CarouselCardView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView.CardView(
            model: .init(
                image: "star",
                title: "Welcome Aboard!",
                description: "Let's start by setting up your profile",
                callToAction: .init(
                    title: "Get Started",
                    action: {

                    }
                )
            )
        )
        .padding()
    }
}
