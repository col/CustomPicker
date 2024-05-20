//
//  CustomPicker.swift
//  CustomPicker
//
//  Created by Colin Harris on 20/5/24.
//

import SwiftUI

public struct CustomPicker<SelectionValue: Hashable, Content: View, Label: View>: View {
    private let selection: Binding<SelectionValue>
    private let content: Content
    private let label: Label

    public init(
        selection: Binding<SelectionValue>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder label: () -> Label
    ) {
        self.selection = selection
        self.content = content()
        self.label = label()
    }
    
    public var body: some View {
        NavigationLink {
            List {
                _VariadicView.Tree(CustomPickerOptions(selectedValue: selection)) {
                    content
                }
            }
        } label: {
            label
        }
    }
}

#Preview {
    struct PreviewItem: Hashable, Identifiable {
        var id = UUID()
        var name: String
        var description: String
    }
    
    let items: [PreviewItem] = [
        PreviewItem(name: "Item 1", description: "First item"),
        PreviewItem(name: "Item 2", description: "Second item"),
        PreviewItem(name: "Item 3", description: "Third item")
    ]
    
    @State var selectedItem: PreviewItem?
    
    return NavigationStack {
        List {
            CustomPicker(
                selection: $selectedItem,
                content: {
                    ForEach(items) { item in
                        Text(verbatim: item.name)
                            .pickerTag(item as PreviewItem?)
                    }
                },
                label: {
                    HStack {
                        Text("Select item")
                        Spacer()
                        Text($selectedItem.wrappedValue?.name ?? "none")
                    }
                }
            )
        }
        .navigationTitle("Custom Picker")
    }
}

private struct CustomPickerOptions<Value: Hashable>: _VariadicView.MultiViewRoot {
    private let selectedValue: Binding<Value>

    init(selectedValue: Binding<Value>) {
        self.selectedValue = selectedValue
    }

    @ViewBuilder
    func body(children: _VariadicView.Children) -> some View {
        ForEach(children) { child in
            CustomPickerOption(
                selectedValue: selectedValue,
                value: child[CustomTagValueTraitKey<Value>.self]
            ) {
                child
            }
        }
    }
}

private struct CustomPickerOption<Content: View, Value: Hashable>: View {
    @Environment(\.dismiss) private var dismiss

    private let selectedValue: Binding<Value>
    private let value: Value?
    private let content: Content

    init(
        selectedValue: Binding<Value>,
        value: CustomTagValueTraitKey<Value>.Value,
        @ViewBuilder _ content: () -> Content
    ) {
        self.selectedValue = selectedValue
        self.value = if case .tagged(let tag) = value {
            tag
        } else {
            nil
        }
        self.content = content()
    }

    var body: some View {
        Button(
            action: {
                if let value {
                    selectedValue.wrappedValue = value
                }
                dismiss()
            },
            label: {
                HStack {
                    content
                        .tint(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.tint)
                            .font(.body.weight(.semibold))
                            .accessibilityHidden(true)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(isSelected ? .isSelected : [])
            }
        )
    }

    private var isSelected: Bool {
        selectedValue.wrappedValue == value
    }
}

private struct CustomTagValueTraitKey<V: Hashable>: _ViewTraitKey {
  enum Value {
    case untagged
    case tagged(V)
  }

  static var defaultValue: CustomTagValueTraitKey<V>.Value {
    .untagged
  }
}

extension View {
  public func pickerTag<V: Hashable>(_ tag: V) -> some View {
    _trait(CustomTagValueTraitKey<V>.self, .tagged(tag))
  }
}
