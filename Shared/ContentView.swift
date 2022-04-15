//
//  ContentView.swift
//  Shared
//
//  Created by Alaina Thompson on 4/1/22.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    
    @EnvironmentObject var plotDataModel :PlotDataClass
    @State var a = 5.43 //a given in Angstroms
    @State var k:[Double] = []
    @State var G:[Double] = []
    @State var tau:[Double] = []
    @State var negTau:[Double] = []
    @State var V = 0.0
    @ObservedObject var myBands = BandStructures()
    
    @State var bandTypes = ["AlSb", "CdTe", "GaAs", "GaP", "GaSb", "Ge", "InAs", "InP", "InSb", "Si", "Sn", "ZnS", "ZnSe", "ZnTe"]
        @State var selectedBand = "Si"
    
    
    
    var body: some View {
        
        VStack{
              
                    CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                        .setPlotPadding(left: 10)
                        .setPlotPadding(right: 10)
                        .setPlotPadding(top: 10)
                        .setPlotPadding(bottom: 10)
                        .padding()
                    
                    Divider()
        
        
        VStack{
        
            Picker("Band Structure:", selection: $selectedBand) {
                            ForEach(bandTypes, id: \.self) {
                                Text($0)
                                
                            }
    }
        
        
            func calculateBands(){
                   
                  
                myBands.makeG = self.makeG
            
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

