//
//  ContentView.swift
//  Shared
//
//  Created by Alaina Thompson on 4/1/22.
//

import SwiftUI
import CorePlot
import ComplexModule
import Numerics

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    
    @EnvironmentObject var plotDataModel :PlotDataClass
    @State var a = 5.43 //a given in Angstroms
    @State var k:[Double] = []
    @State var G:[Double] = []
    @State var tau:[Double] = []
    @State var negTau:[Double] = []
    @State var V = Complex<Double>(0, 0)
    @State var potential = 0.0
    @ObservedObject var myBands = BandStructures()
    @ObservedObject var myPotential = Potential()
    @ObservedObject var myk = WaveVector()
    
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
            
            Picker("Band Structure:", selection: $selectedBand) {
                            ForEach(bandTypes, id: \.self) {
                                Text($0)
                                
                            }
       
    
        }
            HStack{
                            Button("Calculate G", action: {self.calculateBands()} )
                            .padding()
                            
                        }
            HStack{
                            Button("Clear", action: {self.clear()})
                                .padding(.bottom, 5.0)
                                
                        }
            
            
}
        
    
            
            

}
    
    func calculatePotential(){
        let GG = 0.0
        let Gtau = 0.0
        let sumG = 0.0
        myPotential.getPotential(sumG: sumG, Gtau: Gtau, GG: GG)
    }
    
    
    
    func calculateWaveVector(){
        myk.kPoints()
    }
    
    func calculateBands(){
        
        self.calculatePotential()
        self.calculateWaveVector()
        
        
        myBands.PotentialData = myPotential
        myBands.kData = myk
        myBands.makeG(selectedBand: selectedBand)
        
        //   myBands.getHamiltonian(potential: [Double])
    
    }
    
    
    func clear(){
                
           
            myk.k = []
            myBands.H = []
            myBands.G = []
        myBands.u = 0.0
        myBands.v = 0.0
        myBands.w = 0.0
                
                
            }
    
    
    
    
    
    
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

