package main

import (
	"./app/controllers"
	"./app/db"
	"github.com/go-martini/martini"
)

func main() {
	m := martini.Classic()
	m.Use(martini.Static("../client/"))
	m.Use(martini.Static("../.tmp/"))
	m.Use(db.DB())

	var accountsController *controllers.AccountsController = new(controllers.AccountsController)

	m.Group("/accounts", func(r martini.Router) {
			r.Get("", accountsController.GetAccounts)
		})

	m.Run()
}
