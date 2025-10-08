//
//  CardProfil.swift
//  FinanceLab
//
//  Created by Dembo on 07/10/2025.
//

//import SwiftUI
//
//struct CardProfil: View {
//
//    var body: some View {
//        StandardCard {
//            HStack{
//                Image(systemName: "eurosign.ring")
//                Spacer()
//                VStack(alignment: .leading) {
//                  
//                    Text("Emploi")
//                        .font(Font.cardTitle)
//                    Text( "Je suis en CDI")
//                        .font(Font.body)
//                    Text( "Je gagne 1300 € / mois ")
//                        .font(Font.body)
//                }
//                .foregroundStyle(Color.Text.primary)
//                
//                
//            }
//           
//        }
//    }
//}
//
//#Preview {
//    CardProfil()
//}

import SwiftUI

struct CardProfil: View {
    var iconName: String
    var title: String
    var subtitle: [String]
    
    

    var body: some View {
    StandardCard{
        HStack{
         
         
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    ForEach(subtitle, id:\.self) { sub in
                        Text(sub)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                   
                }
            }
            

           
        }
       
        
        .padding(.horizontal)
    }
}

#Preview {
    CardProfil(iconName: "eurosign.ring", title: "Emploi", subtitle: ["Je suis en CDI", "je gagne 1300 € / mois ",])
}
