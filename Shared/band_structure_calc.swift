//
//  band_structure_calc.swift
//  Final Project
//
//  Created by Alaina Thompson on 4/1/22.
//

import Foundation
import SwiftUI

class BandStructures: NSObject,ObservableObject {
//pseudopotential Hailtonian
//
//              2         2
//  H  =   - ( ℏ  / 2m) ∇   +  V(r)

//pseudopotential symmetric and anti-symmetric form
//
//              s      s        A    A   - iG * r
//V(r)  =  Σ ( S  (G) V   +  i S (G)V ) e
//                      G            G

    var tau:[Double] = [0.125, 0.125, 0.125]
    var a:[Double] = [5.43, 5.43, 5.43] //lattice constant
    var r1:[Double] = zip(a, tau).map { $0 * $1 }
    var r2 = zip(a, tau)
    

    
    
    
    
    
    
}
