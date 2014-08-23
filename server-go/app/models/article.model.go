package models

import (
	"time"
)

type Article struct {
	Id      int64     `json:"id"`
	Date    time.Time `json:"time"`
	Title   string    `json:"title", sql:"size: 500"`
	Html    string    `json:"html", sql:text`
	Active  bool      `json:"active"`
	Options string    `json:"options", sql:json`
}
