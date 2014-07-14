express = require('express')
bodyParser = require('body-parser')
request = require('request')
http = require('http')

app = express()

app.use(bodyParser.json())
app.use(bodyParser.urlencoded())

app.get('/', (req, res) ->
  res.send('Up and running')
)

app.post('/', (req, res) ->
  params = req.body

  query = params.text

  url = "http://api.giphy.com/v1/gifs/search?q=#{query}&api_key=dc6zaTOxFJmzC"
  request(url, (err, response, body) ->
    return res.send(500) if err?

    gifs = JSON.parse(body)["data"]

    gif = gifs[0]

    if gif?
      payload = "From: #{params.user_name}\nQuery: #{query}\n <#{gif.url}>"
      slack_options = {
        url: ''
        method: 'POST'
        json: {
          channel: "##{params.channel_name}",
          "text":payload,
          "username":"Gifmatic",
          "icon_emoji":":frowning:"
        }
      }

      request(slack_options, (err) ->
        return res.send(500, err) if err?
      )
  )
)
      console.log 'it worked'

http.createServer(app).listen 4567, (err) ->
  if err?
    console.log 'Could not start server:'
    console.log err
  else
    console.log 'Starting server'
