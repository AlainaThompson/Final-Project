//
//  Hamiltonian_calculation .swift
//  Final Project
//
//  Created by Alaina Thompson on 4/8/22.
//

import Foundation
import SwiftUI
import Accelerate
import CorePlot
import ComplexModule
import Numerics


class BandStructures: NSObject,ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    var PotentialData: Potential? = nil
    var kData: WaveVector? = nil
    @Published var a = 5.43
    @Published var tau:[Double] = []
    @Published var negTau:[Double] = []
    @Published var G:[Double] = []
    @Published var stepSize = 0.01
    let hbarsquareoverm = 7.62 // units of eV A^2
    var H:[Complex<Double>] = []
    var u = 0.0
    var v = 0.0
    var w = 0.0
    var rydberg = 13.6056980659
    
    var V3S = 0.0
    var V8S = 0.0
    var V11S = 0.0
    var V3A = 0.0
    var V4A = 0.0
    var V11A = 0.0
    var VS = 0.0 //symmetric
    var VA = 0.0 //antisymmetric
    
    @Published var selectedBand = ""
    @Published var V = Complex<Double>(0, 0)
    
    
    
    
    
    
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
        
        super.init()
        let fcc:[Double] = [0.125, 0.125, 0.125]
        
        let r1 = fcc.map { $0 * self.a }
        
        let r2 = r1.map { $0 * -1 }
       
        tau = r1
        negTau = r2
        
    }
    
    
    func makeG(selectedBand: String) {
    
    //Reciprocal Lattice Vector G
    //G^2 only has non-zero potential at 3, 4, 8, 11
    //G = b1*u + b2*v + b3*w  with u, v, w in range -2, -1, 0, 1, 2
    //creates a 125x125 matrix
    //states = 5 --> {-2, -1, 0, 1, 2}
    
        let b1:[Double] = [-1, 1, 1]
    
        let b2:[Double] = [1, -1, 1]
    
        let b3 :[Double] = [1, 1, -1]
    //How to go through all u, v, w values to get G for matrix?
        let states = 5
    //m is an increment that goes over all possible values of u, v, and w
       
        
        for m in stride(from: -62.0, through: 62.0, by: 1.0) {
            
        var G:[Double] = [] //Reset G through each m iteration after calling on V and appending to H
        let s = Double(states)
        let n = pow(s, 3.0) - 1.0
        let nHalf = n/2.0
        let mN = m + nHalf
        let flr = floor(s/2.0)
        let statesSqrd = pow(s, 2.0)
        
        u = floor(mN/statesSqrd) - flr
        
        v = floor((mN).truncatingRemainder(dividingBy: statesSqrd)/s) - flr
        w = (mN).truncatingRemainder(dividingBy: s) - flr
       // w = s%(Double(states) - flr)
            let first = b1.map { $0 * u }
            let second = b2.map { $0 * v }
            let third = b3.map { $0 * w }
            let b12 = zip(first, second).map { $0 + $1 }
            let bValues = zip(b12, third).map { $0 + $1 }
        G.append(bValues[0])
        G.append(bValues[1])
        G.append(bValues[2])
            
    
            let GSquared = zip(G, G).map { $0 * $1 }
            
            let GG = GSquared.reduce(0, +)
        
            
            var Gtau = zip(G, tau).map { $0 * $1 } //Multiply x, y, z components
            
            var GdotTau = Double(Gtau.reduce(0, +)) //add them together (equivalent to dot product)
            
            GdotTau = GdotTau*2*Double.pi //Should not be an array
            
   
            
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
                
                default: //default to Si
                a = 5.43
                V3S = -0.21*rydberg
                V8S = 0.04*rydberg
                V11S = 0.08*rydberg
                V3A = 0.0
                V4A = 0.0
                V11A = 0.0
            
            }
            

        
            
            
            
            
            
            
            
            
            
            //pseudopotential symmetric and anti-symmetric form
            //
            //              s      s        A    A   - iG * r
            //V(r)  =  Σ ( S  (G) V   +  i S (G)V ) e
            //         G           G             G
            //
           
        
           
            var SS = cos(GdotTau) // Symmetric structure factor
            var SA = sin(GdotTau) // Anti-symmetric structure factor
            
            //V needs to be a summation over all G values
            //Only non-zero V are at these values
            
                if GG == 3 {
                    VS = V3S
                    VA = V3A
                    V += Complex<Double>(SS*VS, SA*VA)
                    
                }
                if GG == 4 {
                   VS = 0.0
                   VA = V4A
                    V += Complex<Double>(SS*VS, SA*VA)
                }
                if GG == 8 {
                   VS = V8S
                   VA = 0.0
                    V += Complex<Double>(SS*VS, SA*VA)
                    
                }
                if GG == 11 {
                    VS = V11S
                    VA = V11A
                    V += Complex<Double>(SS*VS, SA*VA)
                    
                }
                else {
                    V += Complex<Double>(0, 0)
                }
            
           
            
            
            
        
            
            
            
            
            
            
            
            
            
            
            
            var k = kData!.k
            
            
            
            
            
           
            let kPlusG = zip(k, G).map { $0 + $1 }
            let kGscalar = kPlusG.reduce(0, +)
            let kGSquared = pow(kGscalar, 2.0)
            let Hconstants = hbarsquareoverm
            let Hvalues = kGSquared*Hconstants
            
           
            let hamiltonian = Complex<Double>(Hvalues + V.real, V.imaginary)
              H.append(hamiltonian)
            
                
                
                
                
                
            
        
    }

        
        
        var HMatrix = [[Complex<Double>]](repeating: [Complex<Double>](repeating: Complex<Double>(0,0), count: 125), count: 125)
        
            for i in stride(from: 0, through: 124, by: 1) {
                for j in stride(from: 0, through: 124, by: 1) {

                    let ij = H[i]*H[j]
                    HMatrix[i][j] = ij





                }
            }
        
        
       
        
        
        
        
        
  
    }
  
    
   
    
    
    
    
    
    

   
    
    
    
    func getHamiltonian(potential: [Double]) {
        var delta = 0.0
        let NValues = 125
        let HMatrix = [[Double]](repeating: [Double](repeating: 0.0, count: NValues), count: NValues)
        //if u == v {
        //    delta = 1.0
        //}
        //else {
        //    delta = 0.0
        //}
        
        
      //  let kPlusG = zip(k, G).map { $0 + $1 }
     //   let kGSquared = zip(kPlusG, kPlusG).map { $0 * $1 }
      //  let Hconstants = hbarsquareoverm
       // let Hvalues = kGSquared.map { $0 * Hconstants }
       // let H = zip(Hvalues, potential).map { $0 + $1 }
    
        
           
              
              
            //  let N = Int32(H.count)
              
              //let flatArray :[Double] = pack2dArray(arr: H, rows: Int(N), cols: Int(N))
              
           //   calculateEigenvalues(arrayForDiagonalization: flatArray)
              
          }

          
          /// calculateEigenvalues
          ///
          /// - Parameter arrayForDiagonalization: linear Column Major FORTRAN Array for Diagonalization
          /// - Returns: String consisting of the Eigenvalues and Eigenvectors
          func calculateEigenvalues(arrayForDiagonalization: [Double]) {
              /* Integers sent to the FORTRAN routines must be type Int32 instead of Int */
              //var N = Int32(sqrt(Double(startingArray.count)))
              
              
              var N  = Int32(sqrt(Double(arrayForDiagonalization.count)))
              var N2 = Int32(sqrt(Double(arrayForDiagonalization.count)))
              var N3 = Int32(sqrt(Double(arrayForDiagonalization.count)))
              var N4 = Int32(sqrt(Double(arrayForDiagonalization.count)))

              var flatArray = arrayForDiagonalization
              
              var error : Int32 = 0
              var lwork = Int32(-1)
              // Real parts of eigenvalues
              var wr = [Double](repeating: 0.0, count: Int(N))
              // Imaginary parts of eigenvalues
              var wi = [Double](repeating: 0.0, count: Int(N))
              // Left eigenvectors
              var vl = [Double](repeating: 0.0, count: Int(N*N))
              // Right eigenvectors
              var vr = [Double](repeating: 0.0, count: Int(N*N))
              
              
              /* Eigenvalue Calculation Uses dgeev */
              /*   int dgeev_(char *jobvl, char *jobvr, Int32 *n, Double * a, Int32 *lda, Double *wr, Double *wi, Double *vl,
               Int32 *ldvl, Double *vr, Int32 *ldvr, Double *work, Int32 *lwork, Int32 *info);*/
              
              /* dgeev_(&calculateLeftEigenvectors, &calculateRightEigenvectors, &c1, AT, &c1, WR, WI, VL, &dummySize, VR, &c2, LWork, &lworkSize, &ok)    */
              /* parameters in the order as they appear in the function call: */
              /* order of matrix A, number of right hand sides (b), matrix A, */
              /* leading dimension of A, array records pivoting, */
              /* result vector b on entry, x on exit, leading dimension of b */
              /* return value =0 for success*/
              
              
              /* Calculate size of workspace needed for the calculation */
              
              var workspaceQuery: Double = 0.0
              dgeev_(UnsafeMutablePointer(mutating: ("N" as NSString).utf8String), UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), &N, &flatArray, &N2, &wr, &wi, &vl, &N3, &vr, &N4, &workspaceQuery, &lwork, &error)
              
        
              
              /* size workspace per the results of the query */
              
              var workspace = [Double](repeating: 0.0, count: Int(workspaceQuery))
              lwork = Int32(workspaceQuery)
              
              /* Calculate the size of the workspace */
              
              dgeev_(UnsafeMutablePointer(mutating: ("N" as NSString).utf8String), UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), &N, &flatArray, &N2, &wr, &wi, &vl, &N3, &vr, &N4, &workspace, &lwork, &error)
              
              
           //   energies = wr
          //    psi = unpack2dArray(arr: vr, rows: Int(N), cols: Int(N))
          
          }
          
          
          /// pack2DArray
          /// Converts a 2D array into a linear array in FORTRAN Column Major Format
          ///
          /// - Parameters:
          ///   - arr: 2D array
          ///   - rows: Number of Rows
          ///   - cols: Number of Columns
          /// - Returns: Column Major Linear Array
          func pack2dArray(arr: [[Double]], rows: Int, cols: Int) -> [Double] {
              var resultArray = Array(repeating: 0.0, count: rows*cols)
              for Iy in 0...cols-1 {
                  for Ix in 0...rows-1 {
                      let index = Iy * rows + Ix
                      resultArray[index] = arr[Ix][Iy]
                  }
              }
              return resultArray
          }
          
          /// unpack2DArray
          /// Converts a linear array in FORTRAN Column Major Format to a 2D array in Row Major Format
          ///
          /// - Parameters:
          ///   - arr: Column Major Linear Array
          ///   - rows: Number of Rows
          ///   - cols: Number of Columns
          /// - Returns: 2D array
          func unpack2dArray(arr: [Double], rows: Int, cols: Int) -> [[Double]] {
              var resultArray = [[Double]](repeating:[Double](repeating:0.0 ,count:rows), count:cols)
              for Iy in 0...cols-1 {
                  for Ix in 0...rows-1 {
                      let index = Iy * rows + Ix
                      resultArray[Iy][Ix] = arr[index]
                  }
              }
              return resultArray
          }

        
      
    func makeBandStructurePlot() {
            plotDataModel!.zeroData()

            plotDataModel!.calculatedText = "The Band Structure is: \n"
                    plotDataModel!.calculatedText += "k and E \n"
                    
                  


                    
                        //set the Plot Parameters
                        plotDataModel!.changingPlotParameters.yMax = 18.0
                        plotDataModel!.changingPlotParameters.yMin = -18.1
                        plotDataModel!.changingPlotParameters.xMax = 15.0
                        plotDataModel!.changingPlotParameters.xMin = -1.0
                        plotDataModel!.changingPlotParameters.xLabel = "x"
                        plotDataModel!.changingPlotParameters.yLabel = "E"
                        plotDataModel!.changingPlotParameters.lineColor = .red()
                        plotDataModel!.changingPlotParameters.title = "E vs k"
                            
       //     for i in 0..<x_array.count {
      //      plotDataModel!.calculatedText += "\(x_array[i]), \t\(psi_array[i])\n"
            
       //                 let dataPoint: plotDataType = [.X: x_array[i], .Y: psi_array[i]]
        //                plotDataModel!.appendData(dataPoint: [dataPoint])
                        
                    
            }
    
    
    
    
    
    
    
    
        }
        
        
        
        
        
        

    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

