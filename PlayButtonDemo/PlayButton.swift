//
//  PlayButton.swift
//  PlayButtonDemo
//
//  Created by Hayder Al-Husseini on 30/07/2020.
//  Copyright © 2020 kodeba•se ltd.
//
//  See LICENSE.md for licensing information.
//

import SwiftUI

struct PlayButton: View {
    @State private var isPlaying = false
    
    var action: () -> Void
    
    var body: some View {
        PlayPauseShape(isPlaying: isPlaying)
            .accessibility(label: isPlaying ? Text("Pause") : Text("Play"))
            .accessibility(addTraits: .isButton)
            .accessibilityAction { self.performTap() }
            .animation(.easeInOut(duration: 0.3))
            .contentShape(Rectangle())
            .onTapGesture { self.performTap() }
    }
    
    private func performTap() {
        isPlaying.toggle()
        action()
    }
}

private struct PlayPauseShape: Shape {
    private var isPlaying: Bool
    private var shift: CGFloat
    private let barWidthFraction = CGFloat(11.0/34.0)
    
    var animatableData: CGFloat {
        get { return shift }
        set { shift = newValue }
    }
    
    init(isPlaying: Bool) {
        self.isPlaying = isPlaying
        shift = isPlaying ? 1 : 0
    }
    
    private func pathPoints(width: CGFloat, height: CGFloat) -> [[CGPoint]] {
        var points: [[CGPoint]] = [[]]
        var left: [CGPoint] = []
        var right: [CGPoint] = []
        let pauseBarWidth = width * barWidthFraction
        
        // Slope for top play line
        let m = (height * 0.5)/width
        
        // Y at the center of the play line
        let centerY = (width * 0.5 * m) - (height * 0.5)

        // Left side
        // Top left
        let leftPauseTopLeft = CGPoint(x: ((width * 0.5) - pauseBarWidth) * 0.5, y: 0.0)
        let leftPlayTopLeft = CGPoint.zero
        let leftDeltaTopLeft = leftPauseTopLeft - leftPlayTopLeft
        left.append(leftPlayTopLeft + (leftDeltaTopLeft * shift))
        
        // Top Right
        let leftPauseTopRight = CGPoint(x:leftPauseTopLeft.x + pauseBarWidth, y: 0.0)
        let leftPlayTopRight = CGPoint(x: width * 0.5, y: -centerY)
        let leftDeltaTopRight = leftPlayTopRight - leftPauseTopRight
        left.append(leftPlayTopRight - (leftDeltaTopRight * shift))

        // Bottom Right
        let leftPauseBottomRight = CGPoint(x: leftPauseTopRight.x, y: height)
        let leftPlayBottomRight = CGPoint(x: width * 0.5, y: height + centerY)
        let leftDeltaBottomRight = leftPlayBottomRight - leftPauseBottomRight
        left.append(leftPlayBottomRight - (leftDeltaBottomRight * shift))
        
        // Bottom Left
        let leftPauseBottomLeft = CGPoint(x: (width * 0.5 - pauseBarWidth) * 0.5, y: height)
        let leftPlayBottomLeft = CGPoint(x: 0.0, y: height)
        let leftDeltaBottomLeft = leftPlayBottomLeft - leftPauseBottomLeft
        left.append(leftPlayBottomLeft - (leftDeltaBottomLeft * shift))
            
        points.append(left)
        
        // Right side
        // Top Left
        let rightPauseTopLeft = CGPoint(x: leftPauseTopLeft.x + width * 0.5, y: leftPauseTopLeft.y)
        let rightPlayTopLeft = CGPoint(x: width * 0.5, y: -centerY)
        let rightDeltaTopLeft = rightPlayTopLeft - rightPauseTopLeft
        right.append( rightPlayTopLeft - (rightDeltaTopLeft * shift))
        
        // Top Right
        let rightPauseTopRight = CGPoint(x: rightPauseTopLeft.x + pauseBarWidth, y: rightPauseTopLeft.y)
        let rightPlayTopRight = CGPoint(x: width, y: height * 0.5)
        let rightDeltaTopRight = rightPlayTopRight - rightPauseTopRight
        right.append( rightPlayTopRight - (rightDeltaTopRight * shift))
        
        // Bottom Right
        let rightPauseBottomRight = CGPoint(x: rightPauseTopRight.x, y: height)
        let rightPlayBottomRight = rightPlayTopRight
        let rightDeltaBottomRight = rightPlayBottomRight - rightPauseBottomRight
        right.append( rightPlayBottomRight - (rightDeltaBottomRight * shift))
        
        // Bottom Left
        let rightPauseBottomLeft = CGPoint(x: rightPauseTopLeft.x, y: height)
        let rightPlayBottomLeft = CGPoint(x: rightPlayTopLeft.x, y: height + centerY)
        let rightDeltaBottomLeft = rightPlayBottomLeft - rightPauseBottomLeft
        right.append(rightPlayBottomLeft - (rightDeltaBottomLeft * shift))
        
        points.append(right)
        
        return points
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let allPoints = self.pathPoints(width: rect.size.width,
                                        height: rect.size.height)
                
        for points in allPoints {
            guard let startPoint = points.first else {
                continue
            }
            path.move(to: startPoint)
            
            for i in 1..<points.count {
                let point = points[i]
                path.addLine(to: point)
            }
            
            path.closeSubpath()
        }
        return path
    }
}

extension CGPoint {
    static func * (left: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: left.x * scalar, y: left.y * scalar)
    }
    
    static func * (scalar: CGFloat, right: CGPoint) -> CGPoint {
        return CGPoint(x: right.x * scalar, y: right.y * scalar)
    }
    
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
}


struct PlayButton_Previews: PreviewProvider {
    static var previews: some View {
        PlayButton {
            print("Hello World!")
        }
        .frame(width: 128, height: 128)
    }
}
