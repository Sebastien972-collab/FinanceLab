//
//  CircleImageProfil.swift
//  FinanceLab
//
//  Created by Dembo on 02/10/2025.
//

import SwiftUI

struct CircleImageProfil: View {
    struct ImagePersonFill: View {
        var body: some View {
            Image(systemName: "person.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
        }
    }
    
    var urlImage: String?
    var body: some View {
        if let urlString = urlImage, let url = URL(string: urlString) {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
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
    ScrollView {
        CircleImageProfil(urlImage: User.userDatabase[2].profilePictureUrl)
        CircleImageProfil(urlImage: nil)
    }
}
