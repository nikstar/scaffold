
import SwiftUI

struct ScaffoldScrollConnectionPreference: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        // takes first value
    }
}
enum ScaffoldScrollOffsetEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0
}
enum ScaffoldTopBarMaxHeightEnvironmentKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}
extension EnvironmentValues {
    var scaffoldScrollOffset: CGFloat {
        get { self[ScaffoldScrollOffsetEnvironmentKey.self] }
        set { self[ScaffoldScrollOffsetEnvironmentKey.self] = newValue }
    }
    
    var scaffoldTopBarMaxHeight: CGFloat? {
        get { self[ScaffoldTopBarMaxHeightEnvironmentKey.self] }
        set { self[ScaffoldTopBarMaxHeightEnvironmentKey.self] = newValue }
    }
}


struct TopBar2: View {
    
    @Environment(\.scaffoldScrollOffset) var scaffoldScrollOffset: CGFloat
    @Environment(\.scaffoldTopBarMaxHeight) var scaffoldTopBarMaxHeight: CGFloat?
    
    private var scrolledPastMaxHeight: Bool {
        if let scaffoldTopBarMaxHeight {
            scaffoldScrollOffset < scaffoldTopBarMaxHeight
        } else {
            false
        }
    }
    
    private var foldProgress: CGFloat {
        if let scaffoldTopBarMaxHeight {
            return 1 - min(1, max(0, (scaffoldScrollOffset - 44) / (scaffoldTopBarMaxHeight-50)))
        }
        return 0
    }
    
    var body: some View {
      
        let progressRaw = foldProgress
        let progress = easeInOutBezier(progressRaw)
        
        let size1 = linear(progress, from: 34, to: 17)
//        let size2 = linear(progress, from: 17, to: 13)
//        let padding = linear(progressRaw, from: 8, to: 0)

        ViewThatFits {
            if scaffoldTopBarMaxHeight != nil {
                if scaffoldScrollOffset < 44 {
                    Text("Top Bar offset=\(Double(foldProgress).formatted(.number.precision(.fractionLength(2))))")
                        .lineLimit(1)
                        .font(.system(size: size1).bold())
                        .frame(height: 44, alignment: .center)

                } else {
                    Text("Top Bar offset=\(Double(foldProgress).formatted(.number.precision(.fractionLength(2))))")
                        .lineLimit(1)

                        .font(.system(size: size1).bold())
                    //                    .padding(.vertical, 50)
                        .frame(height: scaffoldScrollOffset, alignment: .center)
                        .frame(alignment: .center)
                        .offset(y: min(0, scaffoldScrollOffset))
                }
            } else {
                Text("Top Bar offset=\(Double(foldProgress).formatted(.number.precision(.fractionLength(2))))")
                    .lineLimit(1)
                    .font(.largeTitle.bold())
                    .foregroundStyle(Color.green)
                    .padding(.vertical, 50)
//                    .frame(height: scaffoldScrollOffset, alignment: .center)
                    .offset(y: min(0, scaffoldScrollOffset))
//                    .foregroundStyle(Color.blue)
            }

        }
            .frame(maxWidth: .infinity)
            .background(Material.bar)
    }
}

/// Clamp value to 0...1
func clamp(_ value: CGFloat) -> CGFloat {
    min(1, max(0, value))
}


func easeInOutBezier(_ t: CGFloat) -> CGFloat {
    t * t * (3.0 - 2.0 * t)
}

func linear(_ progress: CGFloat, from: CGFloat, to: CGFloat) -> CGFloat {
    (1.0 - progress) * from + progress * to
}


public struct Scaffold<Content: View, TopBarContent: View>: View {
    
    @ViewBuilder
    public var content: () -> Content
    
    @ViewBuilder
    public var topBar: () -> TopBarContent
    
    @State private var scrollOffset: CGRect = .zero
    @State private var height: CGFloat = 0
    
    public var body: some View {
        content()
            .frame(maxWidth: .infinity)
            .safeAreaInset(edge: .top, spacing: 0) {
                topBarPlaceholder
            }
            .overlay {
                Color.clear.safeAreaInset(edge: .top, spacing: 0) {
                    topBar()
                        .environment(\.scaffoldScrollOffset, scrollOffset.minY)
                        .environment(\.scaffoldTopBarMaxHeight, height)
                }
            }
            .coordinateSpace(name: "scaffold")
            .onPreferenceChange(ScaffoldScrollConnectionPreference.self) { value in
                scrollOffset = value
            }
    }
    
    private var topBarPlaceholder: some View {
        topBar()
            .overlay {
                GeometryReader { geom in
                    Color.clear.onAppear {
                        height = geom.size.height
                    }.onChange(of: geom.size.height) { _, h in height = h }
                }
            }
            .hidden()
    }
}


extension View {
    func scaffoldScrollConnection() -> some View {
        self
            .background {
                GeometryReader { geom in
                    Color.clear
                        .preference(key: ScaffoldScrollConnectionPreference.self, value: geom.frame(in: .named("scaffold")))
                }
            }
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
            TopBar2()
        }
    )
}
