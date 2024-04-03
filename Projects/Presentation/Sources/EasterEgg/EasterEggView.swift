import SwiftUI
import DesignSystem

struct EasterEggView: View {
    @State private var count = 0
    @State private var angle = 0
    @State private var index = 0
    private var colors: [Color] = [
        .yellow,
        .red,
        .blue,
        .green,
        .purple,
        .orange,
        .mint,
        .white
    ]
    var body: some View {
        VStack {
            Button("", action: addAction)
                .buttonStyle(CatButtonStyle())
                .rotationEffect(.degrees(Double(angle)))

            Text("\(count)")
                .padding(.top, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(colors[index])
    }

    private func addAction() {
        count += 1
        angle = (angle + 45) % 360
        index = Int.random(in: 0..<colors.count)
        HapticManager.instance.impact(style: .heavy)
    }
}

private struct CatButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.isPressed ? DesignSystemAsset.Images.EasterEgg.open.swiftUIImage:
        DesignSystemAsset.Images.EasterEgg.close.swiftUIImage
    }
}

final private class HapticManager {
    static let instance = HapticManager()

    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
