//
//  IntroPageView.swift
//  SMART
//
//  Created by Aryan Palit on 4/30/25.
//

import SwiftUI

struct IntroPageView: View{
    
    ///View Properties
    @State private var activeCard : Card? = cards.first
    
    
    var body : some View{
        ZStack{
            AmbientBackground()
            
            VStack (spacing: 40){
                
                InfiniteScrollView{
                    ForEach(cards){ card in
                        CarouselView(card)
                    }
                }
                .scrollIndicators(.hidden)
                .containerRelativeFrame(.vertical){value, _ in
                    
                    value * 0.45
                }
                
            }
            
        }
    }
    
    @ViewBuilder
    private func AmbientBackground()-> some View{
        GeometryReader{
            let size = $0.size
            
            ZStack {
                ForEach(cards){card in
                    Image(card.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .ignoresSafeArea()
                        .opacity(activeCard == card ? 1.0 : 0.6)
                }
                
                Rectangle()
                    .fill(.black.opacity(0.45))
                    .ignoresSafeArea()
                
                
            }
            .compositingGroup()
            .blur(radius: 90, opaque: true)
            .ignoresSafeArea()
            
        }
    }
    
    @ViewBuilder
    private func CarouselView(_ card : Card) -> some View{
        GeometryReader{
            let size = $0.size
            
            Image(card.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height : size.height)
                .clipShape(.rect(cornerRadius:20))
                .shadow(color: .black.opacity(0.4), radius: 10, x:1, y:0)
            
        }
        .frame(width: 220)
        .scrollTransition(.interactive.threshold(.centered), axis: .horizontal){content, phase in
            content
                .offset( y : phase == .identity ? -10: 0)
                .rotationEffect(.degrees(phase.value*5), anchor: .bottom)
            
        }
    }
}


#Preview {
    IntroPageView()
}
