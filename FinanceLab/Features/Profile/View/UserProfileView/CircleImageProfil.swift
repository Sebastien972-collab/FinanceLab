//
//  CircleImageProfil.swift
//  FinanceLab
//
//  Created by Dembo on 02/10/2025.
//

import SwiftUI

struct CircleImageProfil: View {
    var url: URL?
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(maxWidth: 120, maxHeight: 120)
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .frame(maxWidth: 120, maxHeight: 120)
                }
            }
        }
    }
}

#Preview {
    CircleImageProfil(url: User.preview.)
   
}

