//
//  PlotDataClass.swift
//  Final Project
//
//  Created by Alaina Thompson on 4/8/22.
//

import Foundation
import SwiftUI
import CorePlot

class PlotDataClass: NSObject, ObservableObject {
    
    @Published var plotData = [plotDataType]()
    @Published var changingPlotParameters: ChangingPlotParameters = ChangingPlotParameters()
    @Published var calculatedText = ""
    //In case you want to plot vs point number
    @Published var pointNumber = 1.0
    @Published var selectedBand = "Si"
    
    var HData: BandStructures? = nil
    

    
    
    init(fromLine line: Bool) {
        
        
        //Must call super init before initializing plot
        super.init()
       
        //Intitialize the first plot
        self.plotBlank(selectedBand: selectedBand)
        
       }
    
    
    func plotBlank(selectedBand: String)
    {
        plotData = []
        
        //set the Plot Parameters
        changingPlotParameters.yMax = 25.0
        changingPlotParameters.yMin = -25.0
        changingPlotParameters.xMax = 4.0
        changingPlotParameters.xMin = 0.0
        changingPlotParameters.xLabel = "k"
        changingPlotParameters.yLabel = "E (eV)"
        changingPlotParameters.lineColor = .red()
        changingPlotParameters.title = "\(selectedBand) Band Structure"
        
    }
    
    func zeroData(){
            
            plotData = []
            pointNumber = 1.0
            
        }
        
        func appendData(dataPoint: [plotDataType])
        {
          
            plotData.append(contentsOf: dataPoint)
            pointNumber += 1.0
            
            
            
        }
    
    

}
