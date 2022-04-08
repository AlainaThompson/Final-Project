//
//  Pseudopotential.swift
//  Final Project
//
//  Created by Alaina Thompson on 4/6/22.
//

import Foundation
import SwiftUI

class Pseudopotential: NSObject,ObservableObject {
    @Published var k:[Double] = [0.0, 0.0, 0.0]

//Symmetry Points for FCC structure
var L:[Double] = [0.5, 0.5, 0.5]
var Gamma:[Double] = [0, 0, 0]
var X:[Double] = [1, 0, 0]
var W:[Double] = [1, 0.5, 0]
var K:[Double] = [0.75, 0.75, 0]

var VS = 0.0 //symmetric
var VA = 0.0 //antisymmetric

@Published var stepSize = 0.01
var k_array:[Double] = []

    
    
    
    
    func kPoints() {
        
        let k = L
        for k in stride(from: L, through: Gamma, by: stepSize) {
            k_array.append(k)
        }
        
        let k = gamma
        for k in stride(from: Gamma, through: X, by: stepSize){
            k_array.append(k)
        }
        
        let k = X
        for k in stride(from: X, through: W, by: stepSize) {
            k_array.append(k)
        }
        
        let k = W
        for k in stride(from: W, through: K, by: stepSize) {
            k_array.append(k)
        }
        
        let k = K
        fro k in stride(from: K, through: Gamma, by: stepSize) {
            k_array.append(k)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
