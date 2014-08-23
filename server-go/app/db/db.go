package db

import (
	"github.com/go-martini/martini"
	"github.com/jinzhu/gorm"
	_ "github.com/lib/pq"
)

func DB() martini.Handler {
	return func(c martini.Context) {
		session, err := gorm.Open("postgres", "postgres://postgres:990990@localhost:5432/intermoney?sslmode=disable")
		if err != nil {
			panic(err)
		}
		c.Map(session)
		defer session.Close()
		c.Next()
	}
}
