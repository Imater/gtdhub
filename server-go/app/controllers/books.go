package controllers

import (
	"../models"
	"fmt"
	"bytes"
	"github.com/jinzhu/gorm"
)

type AccountsController struct {
}

func (c AccountsController) GetAccounts(db gorm.DB) string {
	db.DB().Ping()
	var buffer bytes.Buffer
	books := []models.Books{}
	db.Find(&books)
	fmt.Println("access")
	for i := 0; i < len(books); i++ {
		buffer.WriteString(books[i].Data)
	}

	return "Answer = " + buffer.String()
}
