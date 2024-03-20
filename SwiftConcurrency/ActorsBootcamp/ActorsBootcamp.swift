//
//  ActorsBootcamp.swift
//  SwiftConcurrency
//
//  Created by Venkata Ajay Sai Nellori on 11/03/24.
//

import SwiftUI
/// `Actors` are thread safe becuase we need to await in order to get into actor. All the actions inside the actor are isolated to itself.
///  If you ever want to do something which does not need to be isolated to the actor we simply mark it as nonisolated
///
/// Actors solve the problem `data race` i.e.  Two different threads are accessing the same object in memory and  at least one of them is performing the write operation.
///
/// Before actors we use `DispatchQueues` which we often called `locks` to solve `data race`
struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            BrowseView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}
struct HomeView: View {
    @State var text: String = ""
    let manager = MyDataManager.instance
    let actorManager = MyActorDataManager.instance
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea(.all)
            Text(text)
                .font(.headline)
        }
        .onReceive(timer, perform: { _ in
            /*DispatchQueue.global(qos: .background).async {
               /* if let data = manager.getRandomData() {
                    DispatchQueue.main.async {
                        self.text = data
                    }
                }*/
                manager.getRandomData1 { title in
                    if let data = manager.getRandomData() {
                        DispatchQueue.main.async {
                            self.text = data
                        }
                    }
                }
            }*/
            Task {
                if let data = await actorManager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        })
    }
}
struct BrowseView: View {
    @State var text: String = ""
    let manager = MyDataManager.instance
    let actorManager = MyActorDataManager.instance
    @State var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea(.all)
            Text(text)
                .font(.headline)
        }
        .onAppear {
            let newData = actorManager.getNewData()
            print(newData)
        }
        .onReceive(timer, perform: { _ in
            /*DispatchQueue.global(qos: .default).async {
                /*if let data = manager.getRandomData() {
                    DispatchQueue.main.async {
                        self.text = data
                    }
                }*/
                manager.getRandomData1 { title in
                    if let data = manager.getRandomData() {
                        DispatchQueue.main.async {
                            self.text = data
                        }
                    }
                }
            }
            */
            Task {
                if let data = await actorManager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
        })
    }
}
#Preview {
    ActorsBootcamp()
}
