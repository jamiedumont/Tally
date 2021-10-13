//
//  ContentView.swift
//  Shared
//
//  Created by Jamie Dumont on 13/10/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ItemsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Items")
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        
    }
}
