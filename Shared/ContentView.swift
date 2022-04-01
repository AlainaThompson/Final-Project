//
//  ContentView.swift
//  Shared
//
//  Created by Alaina Thompson on 4/1/22.
//

import SwiftUI

struct ContentView: View {
    
    
   
    @State var bandTypes = ["AlSb", "CdTe", "GaAs", "GaP", "GaSb", "Ge", "InAs", "InP", "InSb", "Si", "Sn", "ZnS", "ZnSe", "ZnTe"]
        @State var selectedBand = "Si"
    
    
    
    var body: some View {
        
        VStack{
        
            Picker("Band Structure:", selection: $selectedBand) {
                            ForEach(bandTypes, id: \.self) {
                                Text($0)
                                
                            }
    }
        
        
        
}
}
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

