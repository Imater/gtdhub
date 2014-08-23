package router

import (
	"../../app/models"
	"../../app/controllers"
	"github.com/go-martini/martini"
	"net/http"
	"path"
	"github.com/martini-contrib/binding"
)

func Router() martini.Handler {
	r := martini.NewRouter()

	r.NotFound(func(w http.ResponseWriter, r *http.Request) {
		// Only rewrite paths *not* containing filenames
		if path.Ext(r.URL.Path) == "" {
			http.ServeFile(w, r, "../client/index.html")
		} else {
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte("404 page not found..."))
		}
	})

	var articleController *controllers.ArticleController = new(controllers.ArticleController)
	r.Get("/api/articles", articleController.GetArticles)

	var thingController *controllers.ThingController = new(controllers.ThingController)
	r.Get("/api/things", thingController.GetThings)
	r.Post("/api/things", binding.Bind(models.Thing{}), thingController.AddThings)

	return r.Handle
}
