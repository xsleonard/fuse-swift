//
//  FuseUtilities.swift
//  Pods
//
//  Created by Kirollos Risk on 5/2/17.
//
//

import Foundation

class FuseUtilities {
    /// Computes the score for a match with `e` errors and `x` location.
    ///
    /// - Parameter pattern: Pattern being sought.
    /// - Parameter e: Number of errors in match.
    /// - Parameter x: Location of match.
    /// - Parameter loc: Expected location of match.
    /// - Parameter distance: text's length.
    /// - Returns: Overall score for match (0.0 = good, 1.0 = bad).
    static func calculateScore(_ pattern: String, e: Int, x: Int, loc: Int, distance: String.IndexDistance) -> Double {
        return calculateScore(pattern.count, e: e, x: x, loc: loc, distance: distance)
    }

    /// Computes the score for a match with `e` errors and `x` location.
    ///
    /// - Parameter patternLength: Length of pattern being sought.
    /// - Parameter e: Number of errors in match.
    /// - Parameter x: Location of match.
    /// - Parameter loc: Expected location of match.
    /// - Parameter distance: Coerced version of text's length.
    /// - Returns: Overall score for match (0.0 = good, 1.0 = bad).
    static func calculateScore(_ patternLength: Int, e: Int, x: Int, loc: Int, distance: String.IndexDistance) -> Double {
        let accuracy = Double(e) / Double(patternLength)
        let proximity = abs(x - loc)
        if (distance == 0) {
            return Double(proximity != 0 ? 1 : accuracy)
        }
        return Double(accuracy) + (Double(proximity) / Double(distance))
    }

    /// Initializes the alphabet for the Bitap algorithm
    ///
    /// - Parameter pattern: The text to encode.
    /// - Returns: Hash of character locations.
    static func calculatePatternAlphabet(_ pattern: String) -> [Character: Int] {
        let len = pattern.count
        var mask = [Character: Int]()
        for (i, c) in pattern.enumerated() {
            mask[c] =  (mask[c] ?? 0) | (1 << (len - i - 1))
        }
        return mask
    }

    /// Returns an array of `Range<String.Index>`, where each range represents a consecutive list of `1`s.
    ///
    ///     let arr = [0, 1, 1, 0, 1, 1, 1 ]
    ///     let ranges = findRanges(arr)
    ///     // [{startIndex 1, endIndex 2}, {startIndex 4, endIndex 6}
    ///
    /// - Parameter mask: A string representing the value to search for.
    ///
    /// - Returns: `Range<Int>` array.
    static func findRanges(_ mask: [Int], in aString: String) -> [Range<String.Index>] {
        var ranges = [Range<String.Index>]()
        var start: String.Index? = nil
        var index = aString.startIndex
        
        for bit in mask {
            if start == nil && bit == 1 {
                start = index
            } else if start != nil && bit == 0 {
                ranges.append(start!..<index)
                start = nil
            }
            
            // Advance to the next index in the string
            index = aString.index(index, offsetBy: 1)
        }
        
        if let start = start, mask.last == 1 {
            ranges.append(start..<aString.endIndex)
        }
        
        return ranges
    }
}
