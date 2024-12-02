var fs = require('fs')
var filename = "./input"

var lhs = []
var rhs = []
let count = {}

function populateAndRun() {
    fs.readFile(filename, (_, data) => {
        let list = String(data).trim().split("\n")

        list.forEach((line) => {
            fields = line.split("   ")

            left = Number(fields[0])
            right = Number(fields[1])

            lhs.push(left)
            rhs.push(right)

            count[right] = count[right] == undefined ? 1 : count[right] + 1
        })

        lhs.sort()
        rhs.sort()

        partOne()
        partTwo()
    })
}

function partOne() {
    let result = 0

    for (let i = 0; i < lhs.length; i++) {
        result += Math.abs(lhs[i] - rhs[i])
    }

    console.log(result)
}

function partTwo() {
    let result = 0

    for (let i = 0; i < lhs.length; i++) {
        result += count[lhs[i]] == undefined ? 0 : lhs[i] * count[lhs[i]]
    }

    console.log(result)
}

populateAndRun()
