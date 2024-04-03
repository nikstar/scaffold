# Scaffold

Scaffold SwiftUI component inspired by Jetpack Compose. Works as a more flexible replacement for NavigationStack's navigation bar. 

https://github.com/nikstar/scaffold/assets/1885828/bd8f32d5-3db9-4d26-8c7b-6a08d6aceeaa

Complete example:

```swift

struct TopAppBar: View {
    
    @Environment(\.scaffoldScrollOffset) private var scaffoldScrollOffset: CGFloat
    @Environment(\.scaffoldTopBarMaxHeight) private var scaffoldTopBarMaxHeight: CGFloat?
    
    private var scrolledPastMaxHeight: Bool {
        if let scaffoldTopBarMaxHeight {
            scaffoldScrollOffset < scaffoldTopBarMaxHeight
        } else {
            false
        }
    }
    
    var body: some View {
        Text("Top bar")
            .frame(maxWidth: .infinity)
            .frame(minHeight: 44)
            .background {
                if scrolledPastMaxHeight {
                    Rectangle()
                        .fill(Material.bar)
                        .ignoresSafeArea()
                }
            }
            .overlay(alignment: .bottom) {
                if scrolledPastMaxHeight {
                    Rectangle()
                        .fill(Color(UIColor.separator))
                        .frame(height: 1.0/3.0)
                }
            }
            .animation(.smooth(duration: 0.15), value: scrolledPastMaxHeight)
    }
}

#Preview {
    Scaffold(
        content: {
            ScrollView {
                VStack {
                    ForEach(0..<100) { i in
                        Text("Hello world #\(i)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }
                .scaffoldScrollConnection() // reports scroll offset to the top bar
            }
        },
        topBar: {
            TopAppBar()
        }
    )
}
```
