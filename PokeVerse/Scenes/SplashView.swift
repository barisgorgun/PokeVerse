//
//  SplashView.swift
//  PokeVerse
//
//  Created by Gorgun, Baris on 29.05.2025.
//

import SwiftUI

struct SplashView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.5

    let onFinish: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.red.opacity(0.8), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            PokeballView()
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(rotation))
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 10.0)) {
                        rotation = 720
                        scale = 1.2
                        opacity = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                        onFinish()
                    }
                }
        }
    }
}

struct PokeballView: View {
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 1)
                .fill(Color.white)
                .rotationEffect(.degrees(180))

            Circle()
                .trim(from: 0, to: 0.5)
                .fill(Color.red)

            Rectangle()
                .fill(Color.black)
                .frame(height: 8)

            Circle()
                .strokeBorder(Color.black, lineWidth: 8)
                .frame(width: 50, height: 50)

            Circle()
                .fill(Color.white)
                .frame(width: 25, height: 25)
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 2)
                )
        }
        .clipShape(Circle())
        .overlay(
            Circle().stroke(Color.black, lineWidth: 4)
        )
    }
}

