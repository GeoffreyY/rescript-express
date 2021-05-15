open Express

let app = expressCjs()

app->use(jsonMiddleware())

app->getSync("/", (_req, res) => {
  res->status(200)->json({"ok": true})
})

app->postSync("/ping", (req, res) => {
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
