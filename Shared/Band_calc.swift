//
//  Band_calc.swift
//  Final Project
//
//  Created by Alaina Thompson on 5/5/22.
//




import Foundation
import SwiftUI
import Accelerate
import CorePlot
import ComplexModule
import Numerics


class BandStructures: NSObject,ObservableObject {

    
    
    var plotDataModel: PlotDataClass? = nil
    
    
    var a = 5.43
    var tau:[Double] = []
    @Published var negTau:[Double] = []
    @Published var G:[Double] = []
    @Published var stepSize = 0.01
    let hbarsquareoverm = 7.62 // units of eV A^2
    var H:[__CLPK_doublecomplex] = []
    var u = 0.0
    var v = 0.0
    var W = 0.0
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
    
    var V = __CLPK_doublecomplex(r:0.0, i:0.0)
    var k_array:[Double] = []
 //  var HMatrix: [[__CLPK_doublecomplex]] = Array(repeating: Array(repeating: __CLPK_doublecomplex(r: 0, i: 0), count: 125), count: 125)
    
    
    
//pseudopotential Hailtonian
//
//              2         2
//  H  =   - ( ℏ  / 2m) ∇   +  V(r)

//pseudopotential symmetric and anti-symmetric form
//
//              s      s        A    A   - iG * r
//V(r)  =  Σ ( S  (G) V   +  i S (G)V ) e
//                      G            G

//    override init() {
//
//        super.init()
//        let fcc:[Double] = [0.125, 0.125, 0.125]
//
//        let r1 = fcc.map { $0 * self.a }
//
//
//       print(r1)
//        tau = r1
//
//    }
    
    
    
    
    
    
    
     
      var kz_array:[Double] = []
      var ky_array:[Double] = []
      var kx_array:[Double] = []
     
      
    var E1:[__CLPK_doublecomplex] = []
    var E2:[__CLPK_doublecomplex] = []
    var E3:[__CLPK_doublecomplex] = []
    var E4:[__CLPK_doublecomplex] = []
    var E5:[__CLPK_doublecomplex] = []
    var E6:[__CLPK_doublecomplex] = []
    var E7:[__CLPK_doublecomplex] = []
    var E8:[__CLPK_doublecomplex] = []
    var E9:[__CLPK_doublecomplex] = []
    var E10:[__CLPK_doublecomplex] = []
    
    
    
    
    
    
      
      
    func kPoints(selectedBand: String) async {
          //Need to take the matrix at each k point.
          //Range of k points varying from each symmetry point to the next
          //kPoints() is set up to go through each k point over the specified ranges and calculate the matrix for each point.
          
          //L to Gamma:
          
          var kx = 0.5
          var ky = 0.5
          var kz = 0.5
          
        var k_plot:[Double] = []
        for n in stride(from: 0, to: 0.5, by: 0.05) {
            
            k_plot.append(n)
        }
        for n in stride(from: 0.5, to: 1.5, by: 0.1) {
            k_plot.append(n)
        }
        for n in stride(from: 1.5, to: 1.75, by: 0.025) {
            k_plot.append(n)
        }
        for n in stride(from: 1.75, to: 2.5, by: 0.075) {
            k_plot.append(n)
        }
        
        
        
        
        
        
        
        
          for kx in stride(from: 0.5, to: 0.0, by: -0.05) {
              kx_array.append(kx)
              
                    }
              for ky in stride(from: 0.5, to: 0.0, by: -0.05){
                  ky_array.append(ky)
          }
                  for kz in stride(from: 0.5, to: 0.0, by: -0.05) {
                      kz_array.append(kz)
                    
                      
                  }
              
              
             
          for n in stride(from: 0, through: 9, by: 1) {
              
              k_array = []
        
          k_array.append(kx_array[n])
          k_array.append(ky_array[n])
          k_array.append(kz_array[n])
              
              await makeG(selectedBand: selectedBand)
              print(k_array)
              
            
          }
              
          
          
          //Gamma to X:
          
          kx = 0.0
          
          
          for kx in stride(from: 0.0, to: 1, by: 0.1){
             
              ky = 0.0
              kz = 0.0
              kx_array.append(kx)
              ky_array.append(ky)
              kz_array.append(kz)
             
          }
          
          for n in stride(from: 10, through: 19, by: 1) {
              k_array = []
          k_array.append(kx_array[n])
          k_array.append(ky_array[n])
          k_array.append(kz_array[n])
              
             
              await makeG(selectedBand: selectedBand)
              print(k_array)
              
          }
          
         
          
          
          
          
          
          
          
          //X to K:
          
          kx = 1.0
          ky = 0.0
          
          
          for kx in stride(from: 1.0, to: 0.75, by: -0.025) {
              kx_array.append(kx)
              kz = 0.0
              kz_array.append(kz)
          }
              for ky in stride(from: 0.0, to: 0.75, by: 0.075) {
                   
                  ky_array.append(ky)
          }
          
          for n in stride(from: 20, through: 29, by: 1) {
               k_array = []
          k_array.append(kx_array[n])
          k_array.append(ky_array[n])
          k_array.append(kz_array[n])
              
             
              await makeG(selectedBand: selectedBand)
              print(k_array)
              
          }
          
          
          
          
          
          
          //K to Gamma
          
          kx = 0.75
          ky = 0.75
         
          for kx in stride(from: 0.75, to: 0.0, by: -0.075) {
              kx_array.append(kx)
              kz = 0.0
              kz_array.append(kz)
          }
              for ky in stride(from: 0.75, to: 0.0, by: -0.075) {
                
                  ky_array.append(ky)
              }
          kx = 0.0
          ky = 0.0
          kz = 0.0
          kx_array.append(kx)
          ky_array.append(ky)
          kz_array.append(kz)
          
          for n in stride(from: 30, through: 40, by: 1) {
              k_array = []
          k_array.append(kx_array[n])
          k_array.append(ky_array[n])
          k_array.append(kz_array[n])
              
              await makeG(selectedBand: selectedBand)
              print(k_array)
              
          }

      
      
      
      
      
      
      
      
      
      }
    
    
    
    
    
    
    
    
    
    
    
    
    var count = 0
    
    func makeG(selectedBand: String) async  {
    
    //Reciprocal Lattice Vector G
    //G^2 only has non-zero potential at 3, 4, 8, 11
    //G = b1*u + b2*v + b3*w  with u, v, w in range -2, -1, 0, 1, 2
    //G must permutate over each possible combination of u, v, and, w
    //creates a 125x125 matrix
    //states = 5 --> {-2, -1, 0, 1, 2}
    
        let b1:[Double] = [-1, 1, 1]
    
        let b2:[Double] = [1, -1, 1]
    
        let b3 :[Double] = [1, 1, -1]
    
        let states = 5
    //m is an increment that goes over all possible values of u, v, and w
       
        
        for m in stride(from: -62.0, through: 62.0, by: 1.0) {
            
        var G:[Double] = [] //Reset G through each m iteration after calling on V and appending to H as this allows for all G values in the matrix
        let s = Double(states)
        let n = pow(s, 3.0) - 1.0
        let nHalf = n/2.0
        let mN = m + nHalf
        let flr = floor(s/2.0)
        let statesSqrd = pow(s, 2.0)
        
        u = floor(mN/statesSqrd) - flr
        
        v = floor((mN).truncatingRemainder(dividingBy: statesSqrd)/s) - flr
        W = (mN).truncatingRemainder(dividingBy: s) - flr
       // w = s%(Double(states) - flr)
            let first = b1.map { $0 * u }
            let second = b2.map { $0 * v }
            let third = b3.map { $0 * W }
            let b12 = zip(first, second).map { $0 + $1 }
            let bValues = zip(b12, third).map { $0 + $1 }
        G.append(bValues[0])
        G.append(bValues[1])
        G.append(bValues[2])
            
    
            
            
//            let fcc:[Double] = [0.125, 0.125, 0.125]
//
//            let r1 = fcc.map { $0 * self.a }
//
//
//           print(r1)
//           tau = r1
//
//            let GSquared = zip(G, G).map { $0 * $1 }
//
//            let GG = GSquared.reduce(0, +)
//
//
//            let Gtau = zip(G, tau).map { $0 * $1 } //Multiply x, y, z components
//
//            var GdotTau = Double(Gtau.reduce(0, +)) //add them together (equivalent to dot product)
//
//            GdotTau = GdotTau*2*Double.pi
            
  
            
            switch selectedBand {
                
                //Select the type of structure
                //Must multiply by the rydberg constant 13.6 eV to get the values of potential in eV
                
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
            

        
            
            let fcc:[Double] = [0.125, 0.125, 0.125]
            
            let r1 = fcc.map { $0 * self.a }
            
         
           
           tau = r1
            
            let GSquared = zip(G, G).map { $0 * $1 }
            
            let GG = GSquared.reduce(0, +)
            
            
            let Gtau = zip(G, tau).map { $0 * $1 } //Multiply x, y, z components
            
            var GdotTau = Double(Gtau.reduce(0, +)) //add them together (equivalent to dot product)
            
            GdotTau = GdotTau*2*Double.pi
            
            
            
            
            
            
            
            //pseudopotential symmetric and anti-symmetric form
            //
            //              s      s        A    A   - iG * r
            //V(r)  =  Σ ( S  (G) V   +  i S (G)V ) e
            //         G           G             G
            //
           
        
           
            let SS = cos(GdotTau) // Symmetric structure factor
            let SA = sin(GdotTau) // Anti-symmetric structure factor
            
            //V needs to be a summation over all G values
            //Only non-zero V are at these values
            //For all other G values append V = 0
            
                if GG == 3 {
                    VS = V3S
                    VA = V3A
                    
                    V = __CLPK_doublecomplex(r:SS*VS, i:SA*VA)
                    
                }
                if GG == 4 {
                   VS = 0.0
                   VA = V4A
                    
                    V = __CLPK_doublecomplex(r:SS*VS, i:SA*VA)
                }
                if GG == 8 {
                   VS = V8S
                   VA = 0.0
                    V = __CLPK_doublecomplex(r:SS*VS, i:SA*VA)
                    
                }
                if GG == 11 {
                    VS = V11S
                    VA = V11A
                   
                    V = __CLPK_doublecomplex(r:SS*VS, i:SA*VA)
                    
                }
                else {
                    V = __CLPK_doublecomplex(r:0.0, i:0.0)
                }
           
            
           
          
            
            
            
            
            
            
            
            
            
            
            
            
            let k = k_array
//Hamiltonian:
//                 2
//            hbar           2
//H      =   -------|G  +  k|   +   V
// i, j        2m                    G
            
            
           
            let kPlusG = zip(k, G).map { $0 + $1 }
            let kGscalar = kPlusG.reduce(0, +)
            let kGSquared = pow(kGscalar, 2.0)
            let Hconstants = hbarsquareoverm
            let Hvalues = __CLPK_doublecomplex(r:kGSquared*Hconstants, i:0.0)
            
            var hamiltonian = __CLPK_doublecomplex(r:0.0, i:0.0)
            hamiltonian.r = Hvalues.r + V.r
            hamiltonian.i = V.i
            H.append(hamiltonian)
                
        
    }
       
//Computes H*H to create a 125x125 matrix
        var HMatrix: [[__CLPK_doublecomplex]] = Array(repeating: Array(repeating: __CLPK_doublecomplex(r: 0, i: 0), count: 125), count: 125)
        
            for i in stride(from: 0, through: 124, by: 1) {
                for j in stride(from: 0, through: 124, by: 1) {

                   // (x + yi)(u + vi) = (xu - yv) + (xv + yu)i
                    
                    let rr = H[i].r*H[j].r
                   
                    let ii = H[i].i*H[j].i
                    let first =  rr - ii
                    let ri = H[i].r*H[j].i
                    let ir = H[i].i*H[j].r
                    let second = ri + ir
                    HMatrix[i][j] = __CLPK_doublecomplex(r: first, i: second)
                    
                   


                        
                }
            }
    
      
        
        
        
        
        
        
        
    
        
        
        
        
        
        
        
        
        //Need to diagonalize matrix and take eigenvalues
        //Only want REAL eigenvalues
        //Unsure how to get dgeev FORTRAN function to except complex doubles
        //zgeev? --> used for double precision complex matrices
       
        var Evals = [__CLPK_doublecomplex]()
      
        
        
        
            
            func calculateHamiltonianEigenvalues()  async {
                  
                
               
                let fortranArray = pack2dArray(arr: HMatrix, rows: HMatrix.count, cols: HMatrix[0].count)
                calculateEigenvalues(arrayForDiagonalization: fortranArray)
                 
              }
              
              /// pack2DArray
              /// Converts a 2D array into a linear array in FORTRAN Column Major Format
              /// From code created by Jeff Terry on 1/23/21.
              /// - Parameters:
              ///   - arr: 2D array
              ///   - rows: Number of Rows
              ///   - cols: Number of Columns
              /// - Returns: Column Major Linear Array
        func pack2dArray(arr: [[__CLPK_doublecomplex]], rows: Int, cols: Int) -> [__CLPK_doublecomplex] {
            var resultArray = Array(repeating: __CLPK_doublecomplex(r: 0.0, i: 0.0), count: rows*cols)
                  for Iy in 0...cols-1 {
                      for Ix in 0...rows-1 {
                          let index = Iy * rows + Ix
                          resultArray[index] = arr[Ix][Iy]
                      }
                  }
                  return resultArray
              }
              
              /// calculateEigenvalues
              /// Based on code created by Jeff Terry on 1/23/21.
              /// Calculates the eigenvalues and eigenvectors for an inputted array. Adds these to parameters Evals and eigenvectors
              /// - Parameter arrayForDiagonalization: linear Column Major FORTRAN Array for Diagonalization
              /// - Returns: String consisting of the Eigenvalues and Eigenvectors
              func calculateEigenvalues(arrayForDiagonalization: [__CLPK_doublecomplex]) {
                  /* Integers sent to the FORTRAN routines must be type Int32 instead of Int */
                  //var N = Int32(sqrt(Double(startingArray.count)))
                      
                  _ = ""
                      
                  var N = Int32(sqrt(Double(arrayForDiagonalization.count)))
                  var N2 = Int32(sqrt(Double(arrayForDiagonalization.count)))
                  var N3 = Int32(sqrt(Double(arrayForDiagonalization.count)))
                  var N4 = Int32(sqrt(Double(arrayForDiagonalization.count)))
                      
                  var flatArray = arrayForDiagonalization
                      
                  var error : Int32 = 0
                  var lwork = Int32(-1)
                 
                  var w = [__CLPK_doublecomplex](repeating: __CLPK_doublecomplex(r: 0.0, i: 0.0), count: Int(N))
                 
                  var vl = [__CLPK_doublecomplex](repeating: __CLPK_doublecomplex(r: 0.0, i: 0.0), count: Int(N*N))
                  var vr = [__CLPK_doublecomplex](repeating: __CLPK_doublecomplex(r: 0.0, i: 0.0), count: Int(N*N))
                  var rwork = [Double](repeating: 0.0, count: Int(N))
                      
                  /* Eigenvalue Calculation Uses dgeev */
                  //dgeev diagonolizes the HMatrix
                  /*   int dgeev_(char *jobvl, char *jobvr, Int32 *n, Double * a, Int32 *lda, Double *wr, Double *wi, Double *vl,
                      Int32 *ldvl, Double *vr, Int32 *ldvr, Double *work, Int32 *lwork, Int32 *info);*/
                      
                  /* dgeev_(&calculateLeftEigenvectors, &calculateRightEigenvectors, &c1, AT, &c1, WR, WI, VL, &dummySize, VR, &c2, LWork, &lworkSize, &ok)    */
                  //zgeev -> Same as dgeev but with complex doubles
                  /* parameters in the order as they appear in the function call: */
                  /* order of matrix A, number of right hand sides (b), matrix A, */
                  /* leading dimension of A, array records pivoting, */
                  /* result vector b on entry, x on exit, leading dimension of b */
                  /* return value =0 for success*/
                      
                  /* Calculate size of workspace needed for the calculation */
                  
//                  public func zgeev_(_ __jobvl: UnsafeMutablePointer<CChar>!, _ __jobvr: UnsafeMutablePointer<CChar>!, _ __n: UnsafeMutablePointer<__CLPK_integer>!, _ __a: UnsafeMutablePointer<__CLPK_doublecomplex>!, _ __lda: UnsafeMutablePointer<__CLPK_integer>!, _ __w: UnsafeMutablePointer<__CLPK_doublecomplex>!, _ __vl: UnsafeMutablePointer<__CLPK_doublecomplex>!, _ __ldvl: UnsafeMutablePointer<__CLPK_integer>!, _ __vr: UnsafeMutablePointer<__CLPK_doublecomplex>!, _ __ldvr: UnsafeMutablePointer<__CLPK_integer>!, _ __work: UnsafeMutablePointer<__CLPK_doublecomplex>!, _ __lwork: UnsafeMutablePointer<__CLPK_integer>!, _ __rwork: UnsafeMutablePointer<__CLPK_doublereal>!, _ __info: UnsafeMutablePointer<__CLPK_integer>!) -> Int32
                  
                  
                  
                  
                      
                  var workspaceQuery = __CLPK_doublecomplex(r: 0.0, i: 0.0)
                  zgeev_(UnsafeMutablePointer(mutating: ("N" as NSString).utf8String), UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), &N, &flatArray, &N2, &w, &vl, &N3, &vr, &N4, &workspaceQuery, &lwork, &rwork, &error)
                      
                 
                      
                  /* size workspace per the results of the query */
                      
                  var workspace = [__CLPK_doublecomplex](repeating: __CLPK_doublecomplex(r: 0.0, i: 0.0), count: Int(workspaceQuery.r))
                  lwork = Int32(workspaceQuery.r)
                      
                  /* Calculate the size of the workspace */
                      
                  zgeev_(UnsafeMutablePointer(mutating: ("N" as NSString).utf8String), UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), &N, &flatArray, &N2, &w, &vl, &N3, &vr, &N4, &workspace, &lwork, &rwork, &error)
                      
                      
//                  if (error == 0) {
                     for index in 0..<w.count {     /* transform the returned matrices to eigenvalues and eigenvectors */
//                          if (w[index]>=0.0) {
//                              returnString += "Eigenvalue\n\(rwork[index]) + \(w[index])i\n\n"
//                          }
//                          else {
//                              returnString += "Eigenvalue\n\(rwork[index]) - \(fabs(w[index]))i\n\n"

                         
                         Evals.append(w[index])
                     }
                       
                                      
                         
                                      
                          /* To Save Memory dgeev returns a packed array if complex */
                          /* Must Unpack Properly to Get Correct Result
                                       
                              VR is DOUBLE PRECISION array, dimension (LDVR,N)
                              If JOBVR = 'V', the right eigenvectors v(j) are stored one
                              after another in the columns of VR, in the same order
                              as their eigenvalues.
                              If JOBVR = 'N', VR is not referenced.
                              If the j-th eigenvalue is real, then v(j) = VR(:,j),
                              the j-th column of VR.
                              If the j-th and (j+1)-st eigenvalues form a complex
                              conjugate pair, then v(j) = VR(:,j) + i*VR(:,j+1) and
                              v(j+1) = VR(:,j) - i*VR(:,j+1). */
                          
                
//                  E1.append(Evals[124])
//                  E2.append(Evals[123])
//                  E3.append(Evals[122])
//                  E4.append(Evals[121])
//                  E5.append(Evals[120])
//                  E6.append(Evals[119])
//                  E7.append(Evals[118])
//                  E8.append(Evals[117])
//                  E9.append(Evals[116])
//                  E10.append(Evals[115])
//
                  
                  
                  
                 
                
                  print(Evals)
              }
        //Adjust Evals to the fermi level
        

        
        //Each E value is a line for the band structure plot
        
        
        //Create values for k to be plotted.
        //Over same x step as k_array
        //Makes symmetry point locations now at:
        //L = 0
        //Gamma = 0.5
        //X = 1.5
        //K = 1.75
        //Gamma = 2.5
        
        

        
      
    await calculateHamiltonianEigenvalues()
      
        H = []
        HMatrix = []
        Evals = []
        print("Hi")
    }
    
}
