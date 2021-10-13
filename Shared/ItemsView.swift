//
//  ItemsView.swift
//  Tally
//
//  Created by Jamie Dumont on 13/10/2021.
//

import SwiftUI

struct ItemsView: View {
    let items: FetchRequest<Item>
    
    init() {
        items = FetchRequest<Item>(entity: Item.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Item.dateAdded, ascending: false)
        ])
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items.wrappedValue) { item in
                    Section(header: Text(item.name ?? "")) {
                        ForEach(item.valuations?.allObjects as? [Valuation] ?? []) {
                            val in
                            Text(val.source ?? "")
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Items")
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ItemsView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
