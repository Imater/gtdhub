package models

import (
)

type Email struct {
	Id         int64
	UserId     int64  // Foreign key for User (belongs to)
	Email      string `sql:"type:varchar(100);"` // Set field's type
	Subscribed bool
	Raw        string `sql:json`
}
