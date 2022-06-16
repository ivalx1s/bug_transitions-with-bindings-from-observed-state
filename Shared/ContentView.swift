import SwiftUI

class AppearanceState: ObservableObject {
    @Published var isMinimized = false
}

struct ContentView: View {
    @StateObject private var appearanceState: AppearanceState = .init()
    @State private var isMinimized: Bool = false
    @State private var isMinimizedProxy: Bool = false

    var body: some View {
        VStack {
            Group {
                Spacer()
                Text("Doesn't work properly from observed object field")
                SomeViewComposition(isMinimized: $appearanceState.isMinimized)
                        .frame(width: 200, height: 200)

            }
            Group {
                Spacer()
                Text("Works fine with local state")
                SomeViewComposition(isMinimized: $isMinimized)
                        .frame(width: 200, height: 200)

            }
            Group {
                Spacer()
                Text("Works fine with proxy for observed object field")
                SomeViewComposition(isMinimized: $isMinimizedProxy)
                        .frame(width: 200, height: 200)

            }.onChange(of: appearanceState.isMinimized, perform: {isMinimizedProxy = $0})
            Group {
                Spacer()
                Button("Toggle appearance", action: toggleAppearance)
                        .padding()
            }
        }.padding()
    }

    private func toggleAppearance() {
        appearanceState.isMinimized.toggle()
        isMinimized.toggle()
    }
}

struct SomeViewComposition: View {
    @Binding var isMinimized: Bool

    var body: some View {
        if !isMinimized {
            SomeView(isMinimized: $isMinimized)
                    .transition(
                            .asymmetric(
                                    insertion: .scale.animation(.linear(duration: 3)),
                                    removal: .scale.animation(.linear(duration: 3))
                            )
                    )

        } else {
            Color.clear
        }
    }
}

struct SomeView: View {
    @Binding var isMinimized: Bool

    var body: some View {
        Rectangle()
                .rotationEffect(.degrees(isMinimized ? 360 : 0))
                .animation(.easeInOut(duration: 3), value: isMinimized)
    }
}