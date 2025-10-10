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
//
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
    var iconName: ImageResource
    var title: String
    var subtitle: [String]
    
    

    var body: some View {
    StandardCard{
        HStack(spacing: 12){
         
            
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundStyle(LinearGradient.redGradient)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.cardTitle)
                        .foregroundColor(.white)
                    ForEach(subtitle, id:\.self) { sub in
                        Text(sub)
                            .font(.body)
                    }
                }
                .foregroundStyle(Color.Text.primary)
            }
        .padding()
            

           
        }
       
        
       
    }
}

#Preview {
    CardProfil(iconName: .currencyEurFill, title: "Emploi", subtitle: ["Je suis en CDI", "je gagne 1300 € / mois ",])
    
}
