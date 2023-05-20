//
//  ViewController.swift
//  Saper
//
//  Created by Aibatyr on 20.05.2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var winImage: UIImageView!
    var openedCellsCount = 0
    private var isFirstClick = true
    
    private var tableArray: [[String]] = [[]]
    
    @IBOutlet weak var verticalStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startNewGame()
    }
    
    private func drawTable() {
        verticalStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        for i in 0...tableArray.count - 1 {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution = .fillEqually
            for j in 0...tableArray[i].count - 1 {
                let button = UIButton()
                if tableArray[i][j] == "1" ||
                    tableArray[i][j] == "2" ||
                    tableArray[i][j] == "3" ||
                    tableArray[i][j] == "4" ||
                    tableArray[i][j] == "5" {
                    button.setImage(UIImage(named: tableArray[i][j]), for: .normal)
                } else if tableArray[i][j] == "-" {
                    button.setImage(UIImage(named: "empty"), for: .normal)
                } else {
                    button.setImage(UIImage(named: "default"), for: .normal)
                }
                button.tag = (i + 1) * 10 + (j + 1)
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                horizontalStackView.addArrangedSubview(button)
            }
            
            verticalStackView.addArrangedSubview(horizontalStackView)
        }
    }
        
    private func updateCell(i: Int, j: Int) {
        let countBombs = countBombs(i: i, j: j)
        if countBombs != 0 {
            tableArray[i][j] = String(countBombs)
        } else {
            tableArray[i][j] = "-"
            if i != 0 {
                if j != 0 && tableArray[i-1][j-1] == "0" {
                    updateCell(i: i-1, j: j-1)
                }
                if j != 8 && tableArray[i-1][j+1] == "0"{
                    updateCell(i: i-1, j: j+1)
                }
                if tableArray[i-1][j] == "0" {
                    updateCell(i: i-1, j: j)
                }
            }
            
            if i != 8 {
                if j != 0 && tableArray[i+1][j-1] == "0" {
                    updateCell(i: i+1, j: j-1)
                }
                if j != 8 && tableArray[i+1][j+1] == "0" {
                    updateCell(i: i+1, j: j+1)
                }
                if tableArray[i+1][j] == "0" {
                    updateCell(i: i+1, j: j)
                }
            }
            
            if j != 0 && tableArray[i][j-1] == "0" {
                updateCell(i: i, j: j-1)
            }
            if j != 8 && tableArray[i][j+1] == "0" {
                updateCell(i: i, j: j+1)
            }
        }
        
        openedCellsCount+=1
        if openedCellsCount == 81 - 10 {
            winImage.isHidden = false
        }
    }
    
    private func countBombs(i: Int, j: Int) -> Int {
        var count = 0
        if i != 0 {
            count += countOneLine(i: i-1, j: j)
        }
        if i != 8 {
            count += countOneLine(i: i+1, j: j)
        }
        count += countOneLine(i: i, j: j)
        
        return count
    }
    
    private func countOneLine(i: Int, j: Int) -> Int {
        var count = 0
        if j != 0 {
            print("\(i)  \(j)")
            if tableArray[i][j-1] == "x" {
                count+=1
            }
        }
        if j != 8 {
            print("\(i)  \(j)")
            if tableArray[i][j+1] == "x" {
                count+=1
            }
        }
        if tableArray[i][j] == "x" {
            count+=1
        }
        
        return count
    }
    
    @objc func buttonAction(sender: UIButton!) {
        if isFirstClick {
            fillTableWithBomb(tag: sender.tag)
            isFirstClick = false
        } else if tableArray[sender.tag / 10 - 1][sender.tag % 10 - 1] == "x" {
            gameOver()
            return
        }
        let i = sender.tag / 10 - 1
        let j = sender.tag % 10 - 1
        updateCell(i: i, j: j)
        drawTable()
    }
    
    private func fillTableWithBomb(tag: Int) {
        var count = 0
        while count != 10 {
            let randomInt1 = Int.random(in: 0...8)
            let randomInt2 = Int.random(in: 0...8)
            
            if (randomInt1 + 1) * 10 + randomInt2 + 1 != tag && tableArray[randomInt1][randomInt2] != "x" {
                tableArray[randomInt1][randomInt2] = "x"
                count+=1
            }
        }
    }
    
    private func gameOver() {
        verticalStackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        for i in 0...tableArray.count - 1 {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.distribution = .fillEqually
            for j in 0...tableArray[i].count - 1 {
                let button = UIButton()
                if tableArray[i][j] == "x" {
                    button.setImage(UIImage(named: "pit"), for: .normal)
                } else if tableArray[i][j] == "1" ||
                            tableArray[i][j] == "2" ||
                            tableArray[i][j] == "3" ||
                            tableArray[i][j] == "4" ||
                            tableArray[i][j] == "5" {
                    button.setImage(UIImage(named: tableArray[i][j]), for: .normal)
                } else if tableArray[i][j] == "-" {
                    button.setImage(UIImage(named: "empty"), for: .normal)
                } else {
                    button.setImage(UIImage(named: "default"), for: .normal)
                }
                button.isEnabled = false
                horizontalStackView.addArrangedSubview(button)
            }
            
            verticalStackView.addArrangedSubview(horizontalStackView)
        }
    }
    
    @IBAction func newGameButtonClicked(_ sender: Any) {
        startNewGame()
    }
    
    private func startNewGame() {
        winImage.isHidden = true
        isFirstClick = true
        tableArray = [
            ["0","0","0","0","0","0","0","0","0"],
            ["0","0","0","0","0","0","0","0","0"],
            ["0","0","0","0","0","0","0","0","0"],
            ["0","0","0","0","0","0","0","0","0"],
            ["0","0","0","0","0","0","0","0","0"],
            ["0","0","0","0","0","0","0","0","0"],
            ["0","0","0","0","0","0","0","0","0"],
            ["0","0","0","0","0","0","0","0","0"],
            ["0","0","0","0","0","0","0","0","0"]
        ]
        drawTable()
    }
}

