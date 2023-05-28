//
//  CarouselCardViewModel.swift
//  
//
//  Created by Manu on 28/05/2023.
//

import Foundation

/// The model to use inside the Carousel Card Views.
public struct CarouselCardViewModel: Identifiable {
    public let id: UUID = UUID()
    let image: String
    let title: String
    let description: String
    let callToAction: CallToAction

    public struct CallToAction {
        let title: String
        let action: () -> Void

        public init(
            title: String,
            action: @escaping () -> Void
        ) {
            self.title = title
            self.action = action
        }
    }

    public init(
        image: String,
        title: String,
        description: String,
        callToAction: CallToAction
    ) {
        self.image = image
        self.title = title
        self.description = description
        self.callToAction = callToAction
    }
}

