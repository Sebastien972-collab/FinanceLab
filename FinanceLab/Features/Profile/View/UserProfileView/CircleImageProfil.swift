//
//  CircleImageProfil.swift
//  FinanceLab
//
//  Created by Dembo on 02/10/2025.
//

import SwiftUI

struct CircleImageProfil: View {
    var urlImage: String?
    var body: some View {
        if let urlString = urlImage, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(maxWidth: 67, maxHeight: 67) // Displays the loaded image.
                } else if phase.error != nil {
                    ImagePersonFill()
                } else {
                    ProgressView()
                }
            }
        } else {
            ImagePersonFill()
        }
    }
}

#Preview {
    VStack {
        CircleImageProfil(urlImage: User.userDatabase[2].profilePictureUrl)
    }
}

struct ImagePersonFill: View {
    var body: some View {
        Image(systemName: "person.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .frame(maxWidth: 67, maxHeight: 67)
    }
}
