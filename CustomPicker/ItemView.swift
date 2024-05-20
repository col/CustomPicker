//
//  ItemView.swift
//  CustomPicker
//
//  Created by Colin Harris on 20/5/24.
//

import SwiftUI

struct ItemView: View {
    @State var item: Item
    
    var body: some View {
        VStack {
            HStack {
                Text(item.name)
                Spacer()
            }
            HStack {
                Text(item.description).font(.caption)
                Spacer()
            }
        }
        .tag(item)
    }
}

#Preview {
    Form {
        ItemView(item: Item(name: "Item 1", description: "Some description"))
    }
}
