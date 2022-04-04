class_name Actors
extends KinematicBody2D
#This script is used by the actors

var gravity := 1000
var speed = Vector2(300,500)
var _velocity := Vector2.ZERO
var _direction := Vector2.ZERO
var FLOOR_NORMAL := Vector2.UP
