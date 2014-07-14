express = require('express')
bodyParser = require('body-parser')
request = require('request')

app = express()

app.use(bodyParser.json());
app.use(bodyParser.urlencoded());

app.post('/', (req, res) ->
  var text = req.body.text.split('-c')
  var gifQuery = text[0]
  // Get gifs from giphy 
  request('http://api.giphy.com/v1/gifs/search?q='+gifQuery+keys.gifme, function(err, response, body) {
    if (err) res.send(err)
    var b = JSON.parse(body), random = Math.floor(Math.random() * (b.data.length - 1)) + 0
    var payload;
    var url = b.data[random].url
      , user = req.body.user_name
      , caption = text[1]
      , gifTitle = text[0];
    if (caption) payload ="Title: "+ gifTitle +'\nSent By '+ user + "\n~'"+caption+"'\n<"+url+">" ;
    else if (!caption) payload = "Title: "+ gifTitle +'\nSent By '+ user + "\n<"+url+">" ;
    var options = {
      url: 'Your web hook integration url token here',
      method: "POST",
      json: {"text":payload, "username":"the bot name", "icon_emoji":":an emoji:"}
    }
    // Send gifs to slack channel
    request(options, function(err) {
      if (err) res.send(err);
    })
    res.send('Gif sent.')
  })
})
