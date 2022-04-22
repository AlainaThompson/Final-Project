//
//  Pseudopotential.swift
//  Final Project
//
//  Created by Alaina Thompson on 4/6/22.
//

import Foundation
import SwiftUI

class WaveVector: NSObject,ObservableObject {
    @Published var k:[Double] = []

//Symmetry Points for FCC structure
var L:[Double] = [0.5, 0.5, 0.5]
var Gamma:[Double] = [0, 0, 0]
var X:[Double] = [1, 0, 0]
var K:[Double] = [0.75, 0.75, 0]


//k gets 10 data points from each symmetry point to the next
    
  
    //k = kx + ky + kz 
    var kx = 0.5
    var ky = 0.5
    var kz = 0.5
    
    
    func kPoints() {
        
        //L to Gamma:
        for kx in stride(from: 0.5, to: 0.0, by: -0.05) {
            for ky in stride(from: 0.5, to: 0.0, by: -0.05){
                for kz in stride(from: 0.5, to: 0.0, by: -0.05) {
                    k.append(kx + ky + kz)
                  
                }
        }
        }
        
        //Gamma to X:
        kx = 0.0
        ky = 0.0
        kz = 0.0
        
        for kx in stride(from: 0.0, to: 1, by: 0.1){
            k.append(kx + ky + kz)
        }
        
        //X to K:
        kx = 1.0
        ky = 0.0
        kz = 0.0
        
        for kx in stride(from: 1.0, to: 0.75, by: 0.025) {
            for ky in stride(from: 0.0, to: 0.75, by: 0.075) {
                    k.append(kx + ky + kz)
        }
        }
        
        //K to Gamma
        kx = 0.75
        ky = 0.75
        kz = 0.0
        for kx in stride(from: 0.75, to: 0.0, by: -0.075) {
            for ky in stride(from: 0.75, to: 0.0, by: -0.075) {
                k.append(kx + ky + kz)
            }
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
