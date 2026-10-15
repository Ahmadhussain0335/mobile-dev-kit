import Shared
import SwiftUI

final class FlowCollector: Kotlinx_coroutines_coreFlowCollector {
    let onValue: (Any?) -> Void
    init(onValue: @escaping (Any?) -> Void) { self.onValue = onValue }
    func emit(value: Any?, completionHandler: @escaping (Error?) -> Void) {
        onValue(value)
        completionHandler(nil)
    }
}

struct CounterScreen: View {
    let viewModel = CounterViewModel()
    @State private var count: Int32 = 0

    var body: some View {
        Button("Count: \(count)") { viewModel.increment() }
            .onAppear {
                viewModel.count.collect(collector: FlowCollector { value in
                    count = (value as! KotlinInt).int32Value
                }) { _ in }
            }
    }
}
