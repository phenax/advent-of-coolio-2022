const mod = require('../index.node')
const { promises: fs } = require('fs')

const MM = require('../elm/Main.elm')
console.log(MM)

const loadInput = async () => {
  const contents = await fs.readFile('./input.txt', 'utf8')
  return processInput(contents.trim())
}

const processInput = (contents) =>
  contents.split('\n')
    .map(line => [
      line.slice(0, line.length / 2),
      line.slice(line.length / 2)
    ])

loadInput().then(mod.solve).then(console.log)

