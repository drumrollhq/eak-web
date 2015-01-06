const root = '//api.eraseallkittens.com/v1'
function load-kitten-count
  r = new XML-http-request!
  r.open \GET "#root/count/alltime?types=kitten&_v=#{Date.now!}"
  r.onreadystatechange = ->
    if r.ready-state isnt 4 or r.status isnt 200 then return
    count = JSON.parse r.response .alltime.kitten
    document.query-selector '.kitten-count' .inner-HTML = count

  r.send!

load-kitten-count!
