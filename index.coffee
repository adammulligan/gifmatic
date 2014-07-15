SLACK_ACCOUNT = process.env.SLACK_ACCOUNT || ""
SLACK_TOKEN   = process.env.SLACK_TOKEN || ""

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

post_to_slack = (params, gif) ->
  payload = "#{params.text}\n <#{gif.url}>"

  req_options = {
    url: "https://#{SLACK_ACCOUNT}.slack.com/services/hooks/incoming-webhook?token=#{SLACK_TOKEN}"
    method: 'POST'
    json: {
      channel: "##{params.channel_name}",
      "text":payload,
      "username": params.user_name,
      "icon_emoji":":cubimal_chick:"
    }
  }

  console.log "Sending GIF to Slack"
  request(req_options)

app.post('/', (req, res) ->
  console.log '### REQUEST'

  params = req.body

  console.log "Searching Giphy for #{params.text}"
  url = "http://api.giphy.com/v1/gifs/search?q=#{params.text}&api_key=dc6zaTOxFJmzC"
  request(url, (err, response, body) ->
    return res.send(500) if err?

    gifs = JSON.parse(body)["data"]

    randomIndex = Math.floor(Math.random() * (gifs.length - 1)) + 0
    gif = gifs[randomIndex]

    if gif?
      post_to_slack(params, gif)
    else
      res.send(500, "Couldn't find any matching GIFs, sorry!")
  )
)

http.createServer(app).listen 4567, (err) ->
  if err?
    console.log 'Could not start server:'
    console.log err
  else
    console.log 'Starting server'
