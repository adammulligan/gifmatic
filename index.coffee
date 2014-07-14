express = require('express')
bodyParser = require('body-parser')
request = require('request')
http = require('http')

app = express()

app.use(bodyParser.json())
app.use(bodyParser.urlencoded())

app.post('/', (req, res) ->
  params = req.body

  query = params.text

  url = "http://api.giphy.com/v1/gifs/search?q=#{query}&api_key=dc6zaTOxFJmzC"
  request(url, (err, response, body) ->
    return res.send(500) if err?

    gifs = JSON.parse(body)["data"]

    randomIndex = Math.floor(Math.random() * (gifs.length - 1)) + 0
    gif = gifs[randomIndex]

    payload = "<#{gif.url}>"
    slack_options = {
      url: 'https://wcmc.slack.com/services/hooks/incoming-webhook?token=otypML1dl4nfbJRLZf2kjBd5'
      method: 'POST'
      json: {"text":payload, "username":"Gifmatic", "icon_emoji":":frowning:"}
    }

    request(options, (err) ->
      res.send(500, err) if err?
    )
  )
)

http.createServer(app).listen 4567, (err) ->
  if err?
    console.log 'Could not start server:'
    console.log err
  else
    console.log 'Starting server'
