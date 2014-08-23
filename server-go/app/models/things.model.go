package models

import (
)

type Thing struct {
	Id      int64     `json:"id"`
	Name    string 	`json:"name", sql:"size: 200"`
	Info   string    `json:"info", sql:"size: 500"`
}
