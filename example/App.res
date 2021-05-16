open Express

let app = expressCjs()

app->use(jsonMiddleware())

app->Sync.get("/", (_req, res) => {
  res->status(200)->json({"ok": true})
})

app->get("/delayed", (_req, res) => {
  // this is a rather convoluted looking example...
  // we're just returning a 200 response after 1 sec

  // why can't resolve be called with unit as argument?
  let waitSec = Promise.make((resolve, _) =>
    Js.Global.setTimeout(_ => resolve(. "why can't this be unit"), 1000)->ignore
  )

  waitSec->Promise.then(_ => res->status(200)->json({"ok": true})->Promise.resolve)
})

// We'll be using sync only from here onwards
open! Sync

app->post("/ping", (req, res) => {
  let body = req->body
  switch body["name"]->Js.Nullable.toOption {
  | Some(name) => res->status(200)->json({"message": `Hello ${name}`})
  | None => res->status(400)->json({"error": `Missing name`})
  }
})

app->useWithError((err, _req, res, _next) => {
  Js.Console.error(err)
  res->status(500)->endWithData("An error occured")
})

let port = 8081
let _ = app->listenWithCallback(port, _ => {
  Js.Console.log(`Listening on http://localhost:${port->Belt.Int.toString}`)
})
