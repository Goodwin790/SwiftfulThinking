//
//  TaskBootcamp.swift
//  SwiftConcurrency
//
//  Created by Сергей Киров on 31.03.2023.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
//        for x in array {
//            //work...
//            try Task.checkCancellation()
//        }
        
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print("Image returned successfully!")
            })
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image2 = UIImage(data: data)
            })
        } catch  {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("cllick me") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    
    @StateObject private var viewModel = TaskBootcampViewModel()
   // @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
//        .onAppear{
//            fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
            

            
            
            
       //     Task(priority: .high) {
               // try? await Task.sleep(nanoseconds: 2000000000)
//                await Task.yield()
//                print("High : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                        print("User initialized : \(Thread.current) : \(Task.currentPriority)")
//                    }
//            Task(priority: .medium) {
//                        print("Medium : \(Thread.current) : \(Task.currentPriority)")
//                    }
//            Task(priority: .low) {
//                        print("Low : \(Thread.current) : \(Task.currentPriority)")
//                    }
//            Task(priority: .utility) {
//                        print("Utility : \(Thread.current) : \(Task.currentPriority)")
//                    }
//            Task(priority: .background) {
//                print("Background : \(Thread.current) : \(Task.currentPriority)")
//            }
            
            
            
//            Task(priority: .low) {
//                        print("low : \(Thread.current) : \(Task.currentPriority)")
//
//                Task.detached {
//                    print("detached : \(Thread.current) : \(Task.currentPriority)")
//                }
//                    }
            
    //    }
    }
}
    struct TaskBootcamp_Previews: PreviewProvider {
        static var previews: some View {
            TaskBootcamp()
        }
    }
