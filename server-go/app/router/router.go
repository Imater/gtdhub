package router

import (
	"../../app/controllers"
	"github.com/go-martini/martini"
)

func Router() martini.Handler {
	r := martini.NewRouter()

	var accountsController *controllers.AccountsController = new(controllers.AccountsController)

	r.Get("/accounts", accountsController.GetAccounts)

	return r.Handle
}
