import SwiftUI

struct CardProfil: View {
    var iconName: ImageResource
    var title: String
    var subtitle: String
    var content: String

    var body: some View {
    StandardCard{
        HStack(spacing: 12){
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundStyle(LinearGradient.redGradient)
            VStack(alignment: .leading, spacing: 2) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.cardTitle)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.cardTitle)
                }
                    Text(content)
                }
                .foregroundStyle(Color.Text.primary)
            }
        .padding()
            

           
        }
       
        
       
    }
}
#Preview {
    CardProfil(iconName: .currencyEurFill, title: "Essentiel", subtitle: "Revenus stables", content: "Moyenne par mois (en euros) : 1200 €")
}
