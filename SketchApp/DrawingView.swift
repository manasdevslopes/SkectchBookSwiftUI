//
//  DrawingView.swift
//  SketchApp
//
//  Created by MANAS VIJAYWARGIYA on 14/08/21.
//

import SwiftUI

struct DrawingView: View {
    @Environment (\.managedObjectContext) var viewContext
    
    @State var id: UUID?
    @State var data: Data?
    @State var title: String?
    
    var body: some View {
        if title == nil {
            VStack {
                Image(systemName: "scribble.variable")
                    .font(.largeTitle)
                Text("No canvas has been selected")
                    .font(.title)
            }
        } else {
            VStack {
                DrawingCanvasView(data: data ?? Data(), id: id ?? UUID())
                    .environment(\.managedObjectContext, viewContext)
                    .navigationBarTitle(title ?? "Untitled ", displayMode: .inline)
                
            }
        }
        
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
