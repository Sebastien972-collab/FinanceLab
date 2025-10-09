//
//  View.swift
//  FinanceLab
//
//  Created by Anne Ferret on 09/10/2025.
//

import SwiftUI

enum Corner {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
}

extension View {
    func hideQuarter(_ corner: Corner) -> some View {
        self.mask {
            GeometryReader { geometry in
                Path { path in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let midX = width / 2
                    let midY = height / 2
                    
                    switch corner {
                    case .topLeading:
                        path.move(to: CGPoint(x: midX, y: 0))
                        path.addLine(to: CGPoint(x: width, y: 0))
                        path.addLine(to: CGPoint(x: width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                        path.addLine(to: CGPoint(x: 0, y: midY))
                        path.addLine(to: CGPoint(x: midX, y: midY))
                        
                    case .topTrailing:
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: midX, y: 0))
                        path.addLine(to: CGPoint(x: midX, y: midY))
                        path.addLine(to: CGPoint(x: width, y: midY))
                        path.addLine(to: CGPoint(x: width, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                        
                    case .bottomLeading:
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: width, y: 0))
                        path.addLine(to: CGPoint(x: width, y: height))
                        path.addLine(to: CGPoint(x: midX, y: height))
                        path.addLine(to: CGPoint(x: midX, y: midY))
                        path.addLine(to: CGPoint(x: 0, y: midY))
                        
                    case .bottomTrailing:
                        path.move(to: CGPoint(x: 0, y: 0))
                        path.addLine(to: CGPoint(x: width, y: 0))
                        path.addLine(to: CGPoint(x: width, y: midY))
                        path.addLine(to: CGPoint(x: midX, y: midY))
                        path.addLine(to: CGPoint(x: midX, y: height))
                        path.addLine(to: CGPoint(x: 0, y: height))
                    }
                    
                    path.closeSubpath()
                }
            }
        }
    }
}
