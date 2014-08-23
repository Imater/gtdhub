package main

import (
	"./app/db"
	"./app/router"
	"github.com/go-martini/martini"
	socketio "github.com/googollee/go-socket.io"
	"github.com/martini-contrib/render"
	"log"
	"net/http"
	"time"
)

func main() {
	server, _ := socketio.NewServer(nil)

	server.On("connection", func(so socketio.Socket) {
		log.Println("on connection")
		so.Join("chat")
		so.On("chat message", func(msg string) {
			log.Println("emit:", so.Emit("chat message", msg))
			so.BroadcastTo("chat", "chat message", msg)
		})
		so.On("disconnection", func() {
			log.Println("on disconnect")
		})
	})

	server.On("error", func(so socketio.Socket, err error) {
		log.Println("error:", err)
	})
	m := martini.Classic()

	m.Use(martini.Static("../client/"))
	m.Use(martini.Static("../.tmp/"))
	m.Use(db.DB())
	m.Use(render.Renderer())
	m.Action(router.Router())
	//m.Action(server)

	log.Printf("Started  - %v", time.Now())
	http.Handle("/socket.io/", server)
	http.Handle("/", m)
	http.ListenAndServe(":3000", nil)
	//m.Run()
}
