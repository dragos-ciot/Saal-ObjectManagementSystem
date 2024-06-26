//
//  ObjectDetailView.swift
//  ObjectManagement
//
//  Created by Dragos-Georgian Ciot on 19.04.2024.
//

import SwiftUI

struct ObjectDetailView: View {
    @Environment(ObjectManager.self)
    private var objectManager
    
    @Environment(\.modelContext)
    private var modelContext
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Bindable
    var objectItem: ObjectEntity
    
    @State
    private var shouldPresentAddRelationship = false
    
    var body: some View {
        List {
            Section("Edit object") {
                VStack (alignment: .leading) {
                    Picker("Type", selection: $objectItem.type) {
                        ForEach(ObjectType.allCases, id: \.self) { type in
                            HStack {
                                Text(type.rawValue.capitalized)
                                Image(systemName: type.icon)
                            }
                        }
                    }
                    .font(.headline)
                    .pickerStyle(.menu)
                }
                
                VStack (alignment: .leading) {
                    Text("Object Name")
                        .font(.headline)
                    TextField("Enter the object name here", text: $objectItem.name)
                        .textFieldStyle(.roundedBorder)
                }
                
                VStack (alignment: .leading) {
                    Text("Description")
                        .font(.headline)
                    TextField("Enter the object name here", text: $objectItem.desc, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            Section("Relations") {
                ForEach(objectItem.relations) { relation in
                    NavigationLink(destination: {
                        ObjectDetailView(objectItem: relation)
                    }, label: {
                        ObjectListRowView(objectItem: relation)
                    })
                    .listRowStyle()
                }
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    objectManager.deleteObject(with: modelContext, object: objectItem)
                    dismiss()
                } label: {
                    HStack {
                        Text("Remove")
                        Image(systemName: "xmark.bin.fill")
                    }
                    .foregroundStyle(.red)
                }
            }
            ToolbarItem(placement: .principal) {
                AddButton(title: "Add relation") {
                    shouldPresentAddRelationship.toggle()
                }
            }
        }
        .sheet(isPresented: $shouldPresentAddRelationship) {
            AddRelationsSheet(objectItem: objectItem)
        }
    }
}

#Preview { @MainActor in
    NavigationStack {
        ModelPreview(modelContainer: ObjectEntity.previewContainer) { objectModel in
            ObjectDetailView(objectItem: objectModel)
        }
    }
    .environment(ObjectManager())
}
