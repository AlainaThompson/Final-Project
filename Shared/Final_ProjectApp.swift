//
//  Final_ProjectApp.swift
//  Shared
//
//  Created by Alaina Thompson on 4/1/22.
//

import SwiftUI


@main
struct Final_ProjectApp: App {
    @StateObject var plotDataModel = PlotDataClass(fromLine: true)
        
        var body: some Scene {
            WindowGroup {
                TabView {
                    ContentView()
                        .environmentObject(plotDataModel)
                        .tabItem {
                            Text("Plot")
                        }
                    TextView()
                        .environmentObject(plotDataModel)
                        .tabItem {
                            Text("Text")
                        }
                                
                                
                }
                
            }
        }
    }
