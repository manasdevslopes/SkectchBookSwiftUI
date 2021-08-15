//
//  AppHomeView.swift
//  SketchApp
//
//  Created by MANAS VIJAYWARGIYA on 15/08/21.
//

import SwiftUI
import CoreData
import Combine

struct AppHomeView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: []) var drawings: FetchedResults<Drawing>
    
    @EnvironmentObject var appLockVM: AppLockViewModel
    
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if drawings.count == 0 {
                        NavigationLink(destination: DrawingView()) {
                            Text("Example")
                        }
                    }
                    ForEach(drawings, id: \.self) { drawing in
                        NavigationLink(destination: DrawingView(id: drawing.id, data: drawing.canvasData, title: drawing.title)) {
                            Text(drawing.title ?? "Untitled")
                        }
                    }
                    .onDelete(perform: deleteItem)
                }
                .navigationTitle("Drawing")
                .toolbar {
                    EditButton()
                }
                
                
                Toggle(isOn: $isDarkMode) {
                    Text("Dark Mode")
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding()
                
                Toggle(isOn: $appLockVM.isAppLockEnabled) {
                    Text("App Lock")
                        .font(.system(size: 14, weight: .semibold))
                }
                .onChange(of: appLockVM.isAppLockEnabled, perform: { value in
                    appLockVM.appLockStateChange(appLockState: value)
                })
                .padding()
                
                Button(action: {
                    self.showSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Canvas")
                    }
                }
                .sheet(isPresented: $showSheet) {
                    AddNewCanvasView().environment(\.managedObjectContext, viewContext)
                }
                
            }
            
            
            VStack {
                Image(systemName: "scribble.variable")
                    .font(.largeTitle)
                Text("No canvas has been selected")
                    .font(.title)
            }
            
            
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    func deleteItem(at offset: IndexSet) {
        for index in offset {
            let itemToDelete = drawings[index]
            viewContext.delete(itemToDelete)
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
}

struct AppHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AppHomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
