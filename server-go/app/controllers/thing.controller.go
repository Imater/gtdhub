package controllers

import (
	"../models"
	"github.com/jinzhu/gorm"
	"github.com/martini-contrib/render"
	"net/http"
	"log"
	"github.com/go-martini/martini"
)

type ThingController struct {
}

func (c ThingController) GetThings(db gorm.DB, res http.ResponseWriter, r render.Render) {
	things := []models.Thing{}
	db.Find(&things)
	r.JSON(200, things)
}

func (c ThingController) AddThings(db gorm.DB, req *http.Request, res http.ResponseWriter, r render.Render, p martini.Params, thing models.Thing) {
	log.Println(thing)
	db.Create(&thing)
	r.JSON(201, thing)
}
