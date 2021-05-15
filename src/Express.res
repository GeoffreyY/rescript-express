type express

// "default" &  seem to conflict a bit right now
// https://github.com/rescript-lang/rescript-compiler/issues/5004
@module external expressCjs: unit => express = "express"
@module("express") external express: unit => express = "default"

type req
type res

type middleware = (req, res, unit => res) => res
type middlewareWithError = (Js.Exn.t, req, res, unit => res) => res
type handler = (req, res) => res

type middlewareAsync = (req, res, unit => Js.Promise.t<res>) => Js.Promise.t<res>
type middlewareWithErrorAsync = (Js.Exn.t, req, res, unit => Js.Promise.t<res>) => Js.Promise.t<res>
type handlerAsync = (req, res) => Js.Promise.t<res>

external asMiddleware: express => middleware = "%identity"

// The *Middleware suffixes aren't really nice but avoids forcing people to disable warning 44
@module("express") external jsonMiddleware: unit => middleware = "json"
@module("express") external jsonMiddlewareWithOptions: {..} => middleware = "json"
@module("express") external rawMiddleware: unit => middleware = "raw"
@module("express") external rawMiddlewareWithOptions: {..} => middleware = "raw"
@module("express") external textMiddleware: unit => middleware = "text"
@module("express") external textMiddlewareWithOptions: {..} => middleware = "text"
@module("express")
external urlencodedMiddleware: unit => middleware = "urlencoded"
@module("express")
external urlencodedMiddlewareWithOptions: {..} => middleware = "urlencoded"
@module("express") external staticMiddleware: string => middleware = "static"
@module("express")
external staticMiddlewareWithOptions: (string, {..}) => middleware = "static"

@send external use: (express, middleware) => unit = "use"
@send external useWithPath: (express, string, middleware) => unit = "use"

@send external useWithError: (express, middlewareWithError) => unit = "use"
@send external useWithPathAndError: (express, string, middlewareWithError) => unit = "use"

@send external get: (express, string, handler) => unit = "get"
@send external post: (express, string, handler) => unit = "post"
@send external delete: (express, string, handler) => unit = "delete"
@deprecated("Express 5.0 deprecates app.del(), use app.delete() instead") @send
external del: (express, string, handler) => unit = "del"
@send external patch: (express, string, handler) => unit = "patch"
@send external put: (express, string, handler) => unit = "put"

@send external getMiddleware: (express, string, middleware) => unit = "get"
@send external postMiddleware: (express, string, middleware) => unit = "post"
@send external deleteMiddleware: (express, string, middleware) => unit = "delete"
@send external patchMiddleware: (express, string, middleware) => unit = "patch"
@send external putMiddleware: (express, string, middleware) => unit = "put"

@send external getAsync: (express, string, handlerAsync) => unit = "get"
@send external postAsync: (express, string, handlerAsync) => unit = "post"
@send external deleteAsync: (express, string, handlerAsync) => unit = "delete"
@send external patchAsync: (express, string, handlerAsync) => unit = "patch"
@send external putAsync: (express, string, handlerAsync) => unit = "put"

@send external getMiddlewareAsync: (express, string, middlewareAsync) => unit = "get"
@send external postMiddlewareAsync: (express, string, middlewareAsync) => unit = "post"
@send external deleteMiddlewareAsync: (express, string, middlewareAsync) => unit = "delete"
@send external patchMiddlewareAsync: (express, string, middlewareAsync) => unit = "patch"
@send external putMiddlewareAsync: (express, string, middlewareAsync) => unit = "put"

@send external enable: (express, string) => unit = "enable"
@send external enabled: (express, string) => bool = "enabled"
@send external disable: (express, string) => unit = "disable"

type server

@send external listen: (express, int) => server = "listen"
@send
external listenWithCallback: (express, int, option<Js.Exn.t> => unit) => server = "listen"
@send
external listenWithHostAndCallback: (
  express,
  ~port: int,
  ~host: string,
  option<Js.Exn.t> => unit,
) => server = "listen"

type method = [#GET | #POST | #PUT | #DELETE | #PATCH]

// req properties
@get external baseUrl: req => string = "baseUrl"
@get external body: req => 'a = "body"
@get external cookies: req => 'a = "cookies"
@get external file: req => 'a = "file"
@get external fresh: req => bool = "fresh"
@get external hostname: req => string = "hostname"
@get external ip: req => string = "ip"
@get external ips: req => array<string> = "ips"
@get external method: req => method = "method"
@get external originalUrl: req => string = "originalUrl"
@get external params: req => 'a = "params"
@get external path: req => string = "path"
@get external protocol: req => string = "protocol"
@get external query: req => 'a = "query"
@get external route: req => 'a = "route"
@get external secure: req => bool = "secure"
@get external signedCookies: req => 'a = "signedCookies"
@get external stale: req => bool = "stale"
@get external subdomains: req => array<string> = "subdomains"
@get external xhr: req => bool = "xhr"

// This is a bit unfortunate, as it breaks the zero-cost philosophy,
// but the `string | false` signature doesn't play well with an ML type-system
external asString: 'a => string = "%identity"
let parseValue = value =>
  switch Js.typeof(value) {
  | "boolean" => None
  | _ => Some(value->asString)
  }

// req methods
@send external accepts: (req, array<string>) => 'a = "accepts"
@send external acceptsCharset: (req, array<string>) => 'a = "acceptsCharset"
@send external acceptsEncodings: (req, array<string>) => 'a = "acceptsEncodings"
@send external acceptsLanguages: (req, array<string>) => 'a = "acceptsLanguages"

let accepts = (req, value) => req->accepts(value)->parseValue
let acceptsCharset = (req, value) => req->acceptsCharset(value)->parseValue
let acceptsEncodings = (req, value) => req->acceptsEncodings(value)->parseValue
let acceptsLanguages = (req, value) => req->acceptsLanguages(value)->parseValue

@send external getRequestHeader: (req, string) => option<string> = "get"
@send external is: (req, string) => 'a = "is"

let is = (req, value) => req->is(value)->parseValue

@send external param: (req, string) => option<string> = "param"

// res properties
@get external headersSent: res => bool = "headersSent"
@get external locals: res => Js.Dict.t<'a> = "locals"

// res methods
@send external append: (res, string, string) => res = "append"
@send external attachment: (res, ~filename: string=?) => res = "attachment"
@send external cookie: (res, ~name: string, ~value: string) => res = "cookie"
@send external cookieWithOptions: (res, ~name: string, ~value: string, {..}) => res = "cookie"
@send external clearCookie: (res, string) => res = "clearCookie"
@send external download: (res, ~path: string) => res = "download"
@send external downloadWithFilename: (res, ~path: string, ~filename: string) => res = "download"
@send external end: res => res = "end"
@send external endWithData: (res, 'a) => res = "end"
@send external endWithDataAndEncoding: (res, 'a, ~encoding: string) => res = "end"
@send external format: (res, {..}) => res = "format"
@send external getResponseHeader: (res, string) => option<string> = "get"
@send external json: (res, 'a) => res = "json"
@send external jsonp: (res, 'a) => res = "jsonp"
@send external links: (res, Js.Dict.t<string>) => res = "links"
@send external location: (res, string) => res = "location"
@send external redirect: (res, string) => res = "redirect"
@send external redirectWithStatusCode: (res, ~statusCode: int, string) => res = "redirect"
@send external send: (res, 'a) => res = "send"
@send external sendFile: (res, string) => res = "sendFile"
@send external sendFileWithOptions: (res, string, {..}) => res = "sendFile"
@send external sendStatus: (res, int) => res = "sendStatus"
@send external set: (res, string, string) => unit = "set"
@send external status: (res, int) => res = "status"
@send external \"type": (res, string) => string = "type"
@send external vary: (res, string) => res = "vary"

@module("express") external router: unit => express = "Router"
@send external withRoute: (express, string) => express = "route"
@send external useRouter: (express, string, express) => unit = "use"
