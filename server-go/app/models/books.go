package models

type Books struct {
	Id   int64
	Data string `sql:json`
}
