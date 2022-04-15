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

class BandStructures: NSObject,ObservableObject {
    
    var plotDataModel: PlotDataClass? = nil
    @Published var a = 5.43
    @Published var tau:[Double] = []
    @Published var negTau:[Double] = []
    @Published var G:[Double] = []
    @Published var k:[Double] = []
    @Published var V = 0.0
    @Published var stepSize = 0.01
    let hbarsquareoverm = 7.62 // units of eV A^2
    var u = 0.0
    var v = 0.0
    var w = 0.0
 
    
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
        
        let potential = V
    }
    func makeG() {
    
    //Reciprocal Lattice Vector G
    //G^2 only has non-zero potential at 3, 4, 8, 11
    //G = b1*u + b2*v + b3*w  with u, v, w in range -2, -1, 0, 1, 2
    //creates a 125x125 matrix
    //states = 5 --> {-2, -1, 0, 1, 2}
    
    var b1:[Double] = [-1, 1, 1]
    
    var b2:[Double] = [1, -1, 1]
    
    var b3 :[Double] = [1, 1, -1]
    //How to go through all u, v, w values to get G for matrix?
    var states = 5
    //m is an increment that goes over all possible values of u, v, and w
        
        
    for m in stride(from: -2.0, through: 2.0, by: 0.5) {
        let n = floor(pow(Double(states), 3)/2)
        let s = m + n
        let flr = floor(states/2)
        let statesSqrd = pow(states, 2)
        
        u = floor(s/statesSqrd) - flr
        v = s%floor(statesSqrd/(states - flr))
        w = s%(states - flr)
        G.append(b1*u + b2*v + b3*w)
        return u, v, w
    }
        print(G)
    }

  //How to call upon G for each value i in stride?
   
    
    
    
    
    
    

    let Nvalues = 125
 
    
    
    
    func getHamiltonian(potential: [Double]) {
        var delta = 0.0
        
        //if u == v {
        //    delta = 1.0
        //}
        //else {
        //    delta = 0.0
        //}
        
        
        var kPlusG = zip(k, G).map { $0 + $1 }
        var kGSquared = zip(kPlusG, kPlusG).map { $0 * $1 }
        var H = hbarsquareoverm*kGSquared*delta + potential
    
        var realStartingArray: [[Double]] = []
        
        
        for i in  0...Int(Nvalues)-1{
                  var array = Array(repeating: 0.0, count: Int(Nvalues))
                 
                  if (i == 0){
                      array[i] = -2.0*H + potential[i]
                      array[i+1] = 1.0*H + potential[i]
                  }
                  
                  else if (i == Int(Nvalues)-1){
                      array[i] = -2.0*H + potential[i]
                      array[i-1] = 1.0*H + potential[i]
                  }
                  
                  else {
                      array[i-1] =  1.0*H + potential[i]
                      array[i]   = -2.0*H + potential[i]
                      array[i+1] =  1.0*H + potential[i]
                  }
                  
                  realStartingArray.append(array)
                  

              }
              
              
              let N = Int32(realStartingArray.count)
              
              let flatArray :[Double] = pack2dArray(arr: realStartingArray, rows: Int(N), cols: Int(N))
              
              calculateEigenvalues(arrayForDiagonalization: flatArray)
              
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
                            
            for i in 0..<x_array.count {
            plotDataModel!.calculatedText += "\(x_array[i]), \t\(psi_array[i])\n"
            
                        let dataPoint: plotDataType = [.X: x_array[i], .Y: psi_array[i]]
                        plotDataModel!.appendData(dataPoint: [dataPoint])
                        
                    
            }
        }
        
        
        
        
        
        
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
