//
//  Band_types.swift
//  Final Project
//
//  Created by Alaina Thompson on 4/1/22.
//

import Foundation
class BandStructureTypes: NSObject,ObservableObject {
    
 var rydberg = 13.6056980659
    
@Published var selectedBand = ""
    @Published var a = 5.43
    @Published var G:[Double] = [0.0, 0.0, 0.0]
    @Published var tau:[Double] = []
    @Published var V = 0.0
//Band Structures:
//AlSb, CdTe, GaAs, GaP, GaSb, Ge, InAs, InP, InSb, Si, Sn, ZnS, ZnSe, and ZnTe.
  
    override init() {
        var sumG = G.reduce(0, +) //How to take absolute value?
        
        var Gtau = zip(G, tau).map { $0 * $1 }
        
        Gtau = Gtau.map { $0 * Double.pi*2 }
           
    }
    
    
  
    

//symmetric potential (VS) and anti-symmetric potential (VA) for each structure
    func getPotential(sumG: Double, Gtau: Double) {
    //Data Values for each band structure from Table II in Cohen and Bergstresser Paper
    //S and A represent symmetric and anti-symmetric
    //Numbers 3, 4, 8, or 11 represent square of reciprocal lattice vector G
    //Only these G^2 values are allowed to have nonzero potential
    
    
        
    
    var V3S = 0.0
    var V8S = 0.0
    var V11S = 0.0
    var V3A = 0.0
    var V4A = 0.0
    var V11A = 0.0
    var VS = 0.0 //symmetric
    var VA = 0.0 //antisymmetric
    var GG = sumG*sumG //G*G
        
        
            
            
    switch selectedBand {
        case "Si":
        a = 5.43
        V3S = -0.21*rydberg
        V8S = 0.04*rydberg
        V11S = 0.08*rydberg
        V3A = 0.0
        V4A = 0.0
        V11A = 0.0
        
        case "Ge":
        a = 5.66
        V3S = -0.23*rydberg
        V8S = 0.01*rydberg
        V11S = 0.06*rydberg
        V3A = 0.0
        V4A = 0.0
        V11A = 0.0
        
        case "Sn":
        a = 6.49
        V3S = -0.2*rydberg
        V8S = 0.00
        V11S = 0.06*rydberg
        V3A = 0.0
        V4A = 0.0
        V11A = 0.0
        
        case "GaP":
        a = 5.44
        V3S = -0.22*rydberg
        V8S = 0.03*rydberg
        V11S = 0.07*rydberg
        V3A = 0.12*rydberg
        V4A = 0.7*rydberg
        V11A = 0.02*rydberg
        
        case "GaAs":
        a = 5.64
        V3S = -0.23*rydberg
        V8S = 0.01*rydberg
        V11S = 0.06*rydberg
        V3A = 0.07*rydberg
        V4A = 0.05*rydberg
        V11A = 0.01*rydberg
        
        case "AlSb":
        a = 6.13
        V3S = -0.21*rydberg
        V8S = 0.02*rydberg
        V11S = 0.06*rydberg
        V3A = 0.06*rydberg
        V4A = 0.04*rydberg
        V11A = 0.02*rydberg
        
        case "InP":
        a = 5.86
        V3S = -0.23*rydberg
        V8S = 0.01*rydberg
        V11S = 0.06*rydberg
        V3A = 0.07*rydberg
        V4A = 0.05*rydberg
        V11A = 0.01*rydberg
        
        case "GaSb":
        a = 6.12
        V3S = -0.22*rydberg
        V8S = 0.0*rydberg
        V11S = 0.05*rydberg
        V3A = 0.06*rydberg
        V4A = 0.05*rydberg
        V11A = 0.01*rydberg
        
        case "InAs":
        a = 6.04
        V3S = -0.22*rydberg
        V8S = 0.0*rydberg
        V11S = 0.05*rydberg
        V3A = 0.08*rydberg
        V4A = 0.05*rydberg
        V11A = 0.03*rydberg
        
        case "InSb":
        a = 6.48
        V3S = -0.2*rydberg
        V8S = 0.0*rydberg
        V11S = 0.04*rydberg
        V3A = 0.06*rydberg
        V4A = 0.05*rydberg
        V11A = 0.01*rydberg
        
        case "ZnS":
        a = 5.41
        V3S = -0.22*rydberg
        V8S = 0.03*rydberg
        V11S = 0.07*rydberg
        V3A = 0.24*rydberg
        V4A = 0.14*rydberg
        V11A = 0.04*rydberg
        
        case "ZnSe":
        a = 5.65
        V3S = -0.23*rydberg
        V8S = 0.01*rydberg
        V11S = 0.06*rydberg
        V3A = 0.18*rydberg
        V4A = 0.12*rydberg
        V11A = 0.06*rydberg
        
        case "ZnTe":
        a = 6.07
        V3S = -0.22*rydberg
        V8S = 0.0*rydberg
        V11S = 0.05*rydberg
        V3A = 0.13*rydberg
        V4A = 0.1*rydberg
        V11A = 0.01*rydberg
        
        case "CdTe":
        a = 6.41
        V3S = -0.2*rydberg
        V8S = 0.0*rydberg
        V11S = 0.04*rydberg
        V3A = 0.15*rydberg
        V4A = 0.09*rydberg
        V11A = 0.04*rydberg
        
    //default case Si?
        
        
        
    
        //pseudopotential symmetric and anti-symmetric form
        //
        //              s      s        A    A   - iG * r
        //V(r)  =  Σ ( S  (G) V   +  i S (G)V ) e
        //         G           G             G
        //
        //G dependent on the symmetry point?
    
        var i = sqrt(-1)
        var SS = cos(Gtau) // Symmetric structure factor
        var SA = sin(Gtau) // Anti-symmetric structure factor
        
        while GG <= 11 {
        
            if GG == 3 {
                VS = V3S
                VA = V3A
                V += (SS*VS + i*SA*VA)
                
            }
            if GG == 4 {
               VS = 0.0
               VA = V4A
               V += (SS*VS + i*SA*VA)
            }
            if GG == 8 {
               VS = V8S
               VA = 0.0
               V += (SS*VS + i*SA*VA)
                
            }
            if GG == 11 {
                VS = V11S
                VA = V11A
                V += (SS*VS + i*SA*VA)
            }
            
            
            GG += 1
        
        }
    
        
        
        
        
        
    
    }
}







}
