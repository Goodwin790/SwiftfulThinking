//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrency
//
//  Created by Сергей Киров on 06.04.2023.
//

import Combine
import SwiftUI

class AsyncPublisherDataManager {
    
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2000000000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2000000000)
        myData.append("orange")
        try? await Task.sleep(nanoseconds: 2000000000)
        myData.append("watermellon")

    }
    
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {

        Task {
            for await value in manager.$myData.values {
                await MainActor.run(body: {
                  self.dataArray = value
                })
                break
            }
            
        }
        
//        manager.$myData
//            .receive(on: DispatchQueue.main)
//            .sink { dataArray in
//                self.dataArray = dataArray
//            }
//            .store(in: &cancellables)
    }
    
    func start() async {
        await manager.addData()
    }
}

struct AsyncPublisherBootcamp: View {
    @StateObject private var viewModel = AsyncPublisherBootcampViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

struct AsyncPublisherBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncPublisherBootcamp()
    }
}
