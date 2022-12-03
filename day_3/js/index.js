const mod = require('../index.node')
const { promises: fs } = require('fs')

const getInputLines = async () => {
  const contents = await fs.readFile('./input.txt', 'utf8')
  return contents.trim().split('\n')
}

const processInput = (contents) =>
  contents.map(line => [
    line.slice(0, line.length / 2),
    line.slice(line.length / 2)
  ])

getInputLines().then(processInput).then(mod.solve_1).then(console.log)
getInputLines().then(mod.solve_2).then(console.log)

