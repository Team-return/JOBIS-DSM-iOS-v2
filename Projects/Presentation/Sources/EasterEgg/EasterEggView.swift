import SwiftUI
import DesignSystem

struct EasterEggView: View {
    @State private var count = 0
    var body: some View {
        ZStack(alignment: .bottom) {
            Button("") {}
                .buttonStyle(CatButtonStyle(count: $count))

            Text("\(count)")
                .padding(.top, 50)
        }
    }
}

struct CatButtonStyle: ButtonStyle {
    @Binding var count: Int
    @State private var angle = 0
    @State private var index = 0

    init(count: Binding<Int>) {
        _count = count
    }
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
    func makeBody(configuration: Configuration) -> some View {
        (configuration.isPressed ? DesignSystemAsset.Images.EasterEgg.open.swiftUIImage:
        DesignSystemAsset.Images.EasterEgg.close.swiftUIImage)
        .rotationEffect(.degrees(Double(angle)))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colors[index])
        .onChange(of: configuration.isPressed) {
            if $0 {
                angle = (angle + 45) % 360
                index = Int.random(in: 0..<colors.count)
                count += 1
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
        }
    }
}
