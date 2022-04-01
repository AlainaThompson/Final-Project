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
//Band Structures:
//AlSb, CdTe, GaAs, GaP, GaSb, Ge, InAs, InP, InSb, Si, Sn, ZnS, ZnSe, and ZnTe.

//symmetric potential (VS) and anti-symmetric potential (VA) for each structure
func getPotential() {
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
    
    switch selectedBand {
        case "Si":
        V3S = -0.21*rydberg
        V8S = 0.04*rydberg
        V11S = 0.08*rydberg
        V3A = 0.0
        V4A = 0.0
        V11A = 0.0
        
        case "Ge":
        V3S = -0.23*rydberg
        V8S = 0.01*rydberg
        V11S = 0.06*rydberg
        V3A = 0.0
        V4A = 0.0
        V11A = 0.0
        
        case "Sn":
        V3S = -0.2*rydberg
        V8S = 0.00
        V11S = 0.06*rydberg
        V3A = 0.0
        V4A = 0.0
        V11A = 0.0
        
        case "GaP":
        V3S = -0.22*rydberg
        V8S = 0.03*rydberg
        V11S = 0.07*rydberg
        V3A = 0.12*rydberg
        V4A = 0.7*rydberg
        V11A = 0.02*rydberg
        
        case "GaAs":
        V3S = -0.23*rydberg
        V8S = 0.01*rydberg
        V11S = 0.06*rydberg
        V3A = 0.07*rydberg
        V4A = 0.05*rydberg
        V11A = 0.01*rydberg
        
        case "AlSb":
        V3S = -0.21*rydberg
        V8S = 0.02*rydberg
        V11S = 0.06*rydberg
        V3A = 0.06*rydberg
        V4A = 0.04*rydberg
        V11A = 0.02*rydberg
        
        case "InP":
        V3S = -0.23*rydberg
        V8S = 0.01*rydberg
        V11S = 0.06*rydberg
        V3A = 0.07*rydberg
        V4A = 0.05*rydberg
        V11A = 0.01*rydberg
        
        case "GaSb":
        V3S = -0.22*rydberg
        V8S = 0.0*rydberg
        V11S = 0.05*rydberg
        V3A = 0.06*rydberg
        V4A = 0.05*rydberg
        V11A = 0.01*rydberg
        
        case "InAs":
        V3S = -0.22*rydberg
        V8S = 0.0*rydberg
        V11S = 0.05*rydberg
        V3A = 0.08*rydberg
        V4A = 0.05*rydberg
        V11A = 0.03*rydberg
        
        case "InSb":
        V3S = -0.2*rydberg
        V8S = 0.0*rydberg
        V11S = 0.04*rydberg
        V3A = 0.06*rydberg
        V4A = 0.05*rydberg
        V11A = 0.01*rydberg
        
        case "ZnS":
        V3S = -0.22*rydberg
        V8S = 0.03*rydberg
        V11S = 0.07*rydberg
        V3A = 0.24*rydberg
        V4A = 0.14*rydberg
        V11A = 0.04*rydberg
        
        case "ZnSe":
        V3S = -0.23*rydberg
        V8S = 0.01*rydberg
        V11S = 0.06*rydberg
        V3A = 0.18*rydberg
        V4A = 0.12*rydberg
        V11A = 0.06*rydberg
        
        case "ZnTe":
        V3S = -0.22*rydberg
        V8S = 0.0*rydberg
        V11S = 0.05*rydberg
        V3A = 0.13*rydberg
        V4A = 0.1*rydberg
        V11A = 0.01*rydberg
        
        case "CdTe":
        V3S = -0.2*rydberg
        V8S = 0.0*rydberg
        V11S = 0.04*rydberg
        V3A = 0.15*rydberg
        V4A = 0.09*rydberg
        V11A = 0.04*rydberg
        
    //default case Si?
        
        
        
        
    }
}

//Energy Splits for high symmetry points
func energySplits() {
    
    
    
}





}
