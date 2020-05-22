//
//  Boggle.swift
//  FunctionalBoggle
//
//  Created by Robin Douglas on 21/05/2020.
//  Copyright © 2020 Robin Douglas. All rights reserved.
//

import Foundation

typealias Letter = Character

typealias Word = [Character]

/// A 6 sided boggle cube, each face of the cube has a single letter and one of the faces is always visible.
struct Cube {
    let faces: [Letter]
    let visableFace: Int
    var visableLetter: Letter { faces[visableFace] }
    
    func roll() -> Cube {
        return Cube(faces: faces, visableFace: Int.random(in: 0...5))
    }
}

extension Cube: ExpressibleByStringLiteral {

    public init(stringLiteral value: String) {
        guard value.count == 6 else { fatalError() }
        self = Cube(faces: Array(value), visableFace: 0)
    }
    
}

typealias Row = [Cube]

extension Row {
    
    func render() -> String {
        map(\.visableLetter).map(String.init).joined(separator: ", ")
    }
    
}

typealias Grid = [Row]

extension Grid {

    func render() -> String {
        map { $0.render() }.joined(separator: "\n")
    }
    
    func cubesAdjacentToAndIncluding(index: GridIndex) -> [(GridIndex, Cube)] {
        elementsAdjacentToAndIncluding(index: index.row).flatMap { enumeratedRow -> [(GridIndex, Cube)] in
            enumeratedRow.1.elementsAdjacentToAndIncluding(index: index.column).map { enumeratedCube -> (GridIndex, Cube) in
                (GridIndex(row: enumeratedRow.0, column: enumeratedCube.0), enumeratedCube.1)
            }
        }
    }
    
    func lettersAdjacentToAndIncluding(index: GridIndex) -> [(GridIndex, Letter)] {
        cubesAdjacentToAndIncluding(index: index).map { ($0.0, $0.1.visableLetter) }
    }
    
    func searchForWord(remainingWord: ArraySlice<Character>, usedIndices: [GridIndex]) -> Bool {
        guard let index = usedIndices.last else { return false }
        guard let letter = remainingWord.first else { return true }
        let result = lettersAdjacentToAndIncluding(index: index)
            .filter { $0.1 == letter && !usedIndices.contains($0.0) }
            .map { enumeratedLetter -> Bool in
                searchForWord(
                    remainingWord: remainingWord.dropFirst(),
                    usedIndices: usedIndices + [enumeratedLetter.0]
                )
            }
        return !result.isEmpty && !result.contains(false)
    }
    
    func enumeratedGrid() -> [(GridIndex, Cube)] {
        enumerated().flatMap { row -> [(GridIndex, Cube)] in
            row.element.enumerated().map { column -> (GridIndex, Cube) in
                (GridIndex(row: row.offset, column: column.offset), column.element)
            }
        }
    }
    
    func enumeratedGridLetters() -> [(GridIndex, Letter)] {
        enumeratedGrid().map { ($0.0, $0.1.visableLetter) }
    }
    
    func indicesWith(letter: Letter) -> [GridIndex] {
        enumeratedGridLetters()
            .filter { $0.1 == letter }
            .map(\.0)
    }

}

struct GridIndex: Equatable {
    let row: Int
    let column: Int
}

class BoggleEngine: ObservableObject {
    
    @Published var grid: Grid = [
        ["aaeegn", "abbjoo", "achops", "affkps"],
        ["aoottw", "cimotu", "deilrx", "delrvy"],
        ["distty", "eeghnw", "eeinsu", "ehrtvw"],
        ["eiosst", "elrtty", "himnqu", "hlnnrz"]
    ]
    
    func shakeGrid() {
        grid = grid.map { $0.map { $0.roll() } }
    }
    
    func test(word: Word) -> Bool {
        grid.enumeratedGridLetters()
            .filter { $0.1 == word[0] }
            .map { grid.searchForWord(remainingWord: word.dropFirst(), usedIndices: [$0.0]) }
            .contains(true)
    }
    
}
