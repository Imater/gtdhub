package controllers

import (
	"../models"
	"github.com/jinzhu/gorm"
	"github.com/martini-contrib/render"
	"net/http"
)

type ArticleController struct {
}

func (c ArticleController) GetArticles(db gorm.DB, res http.ResponseWriter, r render.Render) {
	articles := []models.Article{}
	db.Find(&articles)
	r.JSON(200, articles)
}

func (c ArticleController) InitArticles(db gorm.DB) string {
	db.DropTable(models.Article{})
	db.CreateTable(models.Article{})
	return "db created"
}
