//
//  Font.swift
//  FinanceLab
//
//  Created by Anne Ferret on 29/09/2025.
//

import SwiftUI

extension Font {
    
    private static let customFont = "HostGrotesk-Regular"
    private static let customFontMedium = "HostGrotesk-Medium"
    private static let customFontSemiBold = "HostGrotesk-SemiBold"
    private static let customFontBold = "HostGrotesk-Bold"
    private static let customFontExtraBold = "HostGrotesk-ExtraBold"
    
    static var title: Font {
        .custom(customFontBold, size: 24)
    }
    
    static var title2: Font {
        .custom(customFontBold, size: 18)
    }
    
    static var header: Font {
        .custom(customFont, size: 15)
    }
    
    static var body: Font {
        .custom(customFont, size: 13)
    }
    
    static var caption: Font {
        .custom(customFontSemiBold, size: 12)
    }
    
    static var buttonLabel: Font {
        .custom(customFontBold, size: 16)
    }
    
    static var cardTitle: Font {
        .custom(customFontSemiBold, size: 15)
    }
    
    static var cardSubtitle: Font {
        .custom(customFontMedium, size: 12)
    }
    
    static var cardCallout: Font {
        .custom(customFont, size: 10)
    }
    
    static var cardNumber: Font {
        .custom(customFontBold, size: 32)
    }
    
    static var cardCurrency: Font {
        .custom(customFontBold, size: 22)
    }
    
    static var listHeader: Font {
        .custom(customFont, size: 13)
    }
    
    static var listLargeNumber: Font {
        .custom(customFontExtraBold, size: 17)
    }
    
    static var listNumber: Font {
        .custom(customFont, size: 12)
    }
    
    static var demboAdvice: Font {
        .custom(customFontMedium, size: 12)
    }
    
    static var inputFieldNumber: Font {
        .custom(customFontBold, size: 20)
    }
    
    static var inputFieldText: Font {
        .custom(customFont, size: 17)
    }
    
    static var tabBarLabel: Font {
        .custom(customFontSemiBold, size: 11)
    }

}
