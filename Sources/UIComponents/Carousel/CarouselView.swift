//
//  CarouselView.swift
//  
//
//  Created by Manu on 28/05/2023.
//

import Foundation
import SwiftUI

/// Carousel View.
public struct CarouselView: View {
    private let cardModels: [CarouselCardViewModel]

    public init(
        cardModels: [CarouselCardViewModel]
    ) {
        self.cardModels = cardModels
        UIPageControl.appearance().currentPageIndicatorTintColor = .tintColor
        UIPageControl.appearance().pageIndicatorTintColor = .tintColor.withAlphaComponent(0.2)
    }

    public var body: some View {
        TabView {
            ForEach(cardModels) { model in
                CarouselView.CardView(model: model)
            }
        }
        .tabViewStyle(.page)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(30)
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView(
            cardModels: [
                CarouselCardViewModel(
                    image: "star",
                    title: "A Title",
                    description: "A description",
                    callToAction: .init(title: "Start", action: {

                    })
                ),
                CarouselCardViewModel(
                    image: "highlighter",
                    title: "Another Title",
                    description: "Another description",
                    callToAction: .init(title: "Run", action: {

                    })
                )
            ]
        )
        .padding()
    }
}

