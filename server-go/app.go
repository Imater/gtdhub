package main

import (
	"./app/db"
	"./app/router"
	"github.com/go-martini/martini"
	"github.com/googollee/go-socket.io"
	"log"
	"net/http"
)

func main() {

	server, err := socketio.NewServer(nil)
	if err != nil {
		log.Fatal(err)
	}
	server.On("connection", func(so socketio.Socket) {
		log.Println("on connection")
	})

	http.Handle("/socket.io/", server)

	if true {
		m := martini.Classic()
		m.Use(martini.Static("../client/"))
		m.Use(martini.Static("../.tmp/"))
		m.Use(db.DB())
		m.Action(router.Router())
		m.Run()
	}
}
