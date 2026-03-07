import SwiftUI

/// Animated splash screen shown on app launch
struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.6
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var isFinished = false

    var body: some View {
        if isFinished {
            EmptyView()
        } else {
            ZStack {
                Color("LaunchBackground")
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Logo image – uses the LaunchLogo asset when available,
                    // falls back to an SF Symbol placeholder
                    Group {
                        if UIImage(named: "LaunchLogo") != nil {
                            Image("LaunchLogo")
                                .resizable()
                                .scaledToFit()
                        } else {
                            Image(systemName: "water.waves.and.arrow.down")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: 180, height: 180)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                    Text("REEF BUDDY")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(textOpacity)
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    logoScale = 1.0
                    logoOpacity = 1.0
                }
                withAnimation(.easeOut(duration: 0.6).delay(0.4)) {
                    textOpacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeIn(duration: 0.3)) {
                        isFinished = true
                    }
                }
            }
        }
    }
}
