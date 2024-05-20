//
//  ContentView.swift
//  CustomPicker
//
//  Created by Colin Harris on 20/5/24.
//

import SwiftUI

struct Item: Hashable, Identifiable {
    var id: String { name }
    var name: String
    var description: String
}

struct ContentView: View {
    
    @State var items: [Item] = [
        Item(name: "Item 1", description: "I'm the first item!"),
        Item(name: "Item 2", description: "I'm the middle item!"),
        Item(name: "Item 3", description: "I'm the last item!")
    ]
    @State var selectedItem: Item?
    
    var body: some View {
        NavigationStack {
            Form {
                
                CustomPicker(
                    selection: $selectedItem,
                    content: {
                        Text("No item").pickerTag(nil as Item?)
                        ForEach(items) { item in
                            ItemView(item: item).pickerTag(item as Item?)
                        }
                        .navigationTitle("Pick an item")
                    },
                    label: {
                        HStack {
                            Text("Pick something")
                            Spacer()
                            Text($selectedItem.wrappedValue?.name ?? "none")
                        }
                    }
                )
                                    
            }
            .navigationTitle("Custom Picker")
        }
    }
}

#Preview {
    ContentView()
}
