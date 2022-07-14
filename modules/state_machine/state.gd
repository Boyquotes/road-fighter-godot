extends Node
class_name State

### Variable que deriva a la maquina de estados ###
##  la propia maquina se asignara a si mismo	 ##
var state_machine = null

### Referencia al nodo base del personaje 		###
##  solo definimos su clase, se asigna despues	 ##
var character : Car

func _ready() -> void:
	# Espera que el nodo principal termine de cargar #
	yield(owner, "ready")
	
	# Asigna el root node de la escena como el personaje #
	character = owner as Car

### Funciones del engine derivadas de la maquina de estados ###
## handle_input() == _unhandled_input() ##
func handle_input(_event: InputEvent) -> void:
	pass
	
## update() == _process() ##
func update(_delta: float) -> void:
	pass

## physics_update() == _physics_process() ##
func physics_update(_delta: float) -> void:
	pass

### Funcion que se ejecuta solo cuando se inicializa el estado 		 ###
##  es llamado por la maquina de estados, permite mensajes opcionales ##
func enter(_msg := {}) -> void:
	pass

### Funcion que se ejecuta solo cuando se termina el estado			###
##  es llamado por la maquina de estados antes de pasar de estado	 ##
func exit() -> void:
	pass

func move(_dir:Vector2) -> void:
	pass
