
import SwiftUI

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
            .animation(.smooth(duration: 0.2), value: scrolledPastMaxHeight)
    }
}

#Preview {
    Scaffold(
        content: {
            ScrollView {
                VStack {
                    ForEach(0..<100) { i in
                        Button(action: { print("tap") }) {
                            Text("Hello world #\(i)")
                                .padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .scaffoldScrollConnection()
            }
        },
        topBar: {
            TopAppBar()
        }
    )
}


