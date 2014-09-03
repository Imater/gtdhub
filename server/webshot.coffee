Pageres = require("pageres")
console.time "long"
pageres = new Pageres(delay: 0).src("newsland.ru", [
    "480x320"
  ],
  crop: true
  ).src("cash4pay.co", [
    "480x320"
  ],
  crop: true
  ).src("4tree.ru", [
  "480x320"
  ],
  crop: true
  ).dest(__dirname)
pageres.run (err) ->
  throw err  if err
  console.timeEnd "long"
  console.log "done"
  return
