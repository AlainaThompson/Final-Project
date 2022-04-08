//
//  Hamiltonian_calculation .swift
//  Final Project
//
//  Created by Alaina Thompson on 4/8/22.
//

import Foundation
import SwiftUI

class BandStructures: NSObject,ObservableObject {
    @Published var a = 5.43
    @Published var tau:[Double] = []
    @Published var negTau:[Double] = []
    @Published var G:[Double] = []
    @Published var k:[Double] = []
    @Published var V = 0.0
    @Published var stepSize = 0.01
    let hbarsquareoverm = 7.62 // units of eV A^2
    
    
    
//pseudopotential Hailtonian
//
//              2         2
//  H  =   - ( ℏ  / 2m) ∇   +  V(r)

//pseudopotential symmetric and anti-symmetric form
//
//              s      s        A    A   - iG * r
//V(r)  =  Σ ( S  (G) V   +  i S (G)V ) e
//                      G            G

    override init() {
        let fcc:[Double] = [0.125, 0.125, 0.125]
        
        let r1 = fcc.map { $0 * a }
        
        var r2 = r1.map { $0 * -1 }
       
        tau = r1
        negTau = r2
    }
    
    //Reciprocal Lattice Vector G
    //G^2 only has non-zero potential at 3, 4, 8, 11
    //G = b1*u + b2*v + b3*w  with u, v, w in range -2, -1, 0, 1, 2
    //creates a 124x124 matrix
    
    var b1:[Double] = [-1, 1, 1]
    
    var b2:[Double] = [1, -1, 1]
    
    var b3 :[Double] = [1, 1, -1]
    //How to go through all u, v, w values to get G for matrix
    
    
    
    
    
    
    func getHamiltonian(V: Double) {
        var delta = 0.0
        
        //if u == v {
        //    delta = 1.0
        //}
        //else {
        //    delta = 0.0
        //}
        
        
        var kPlusG = zip(k, G).map { $0 + $1 }
        var kGSquared = zip(kPlusG, kPlusG).map { $0 * $1 }
        var H = hbarsquareoverm*kGSquared*delta + V
    
    
    
    }
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
}
