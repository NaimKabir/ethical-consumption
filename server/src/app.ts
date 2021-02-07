const express = require("express")
const app = express()
const port: number = 4000

// Default endpoint
app.get('/', (req, res) => {
    res.send('Hello World!')
})

// Serve
app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`)
})
