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
                .frame(width: 55, height: 55)
                .foregroundStyle(LinearGradient.primaryGradient)
            VStack(alignment: .leading, spacing: 4) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.cardTitle)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.cardSubtitle)
                }
                Text(content)
                    .font(.body)
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
