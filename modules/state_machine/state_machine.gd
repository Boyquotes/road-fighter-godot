extends Node
class_name StateMachine

### Señal emitida cuando se cambia de estado,	###
##  actualmente no cumple ninguna funcion		 ##
signal transitioned(state_name)

### Estado inicial de la maquina, en nuestro caso es Idle		###
##  pero siempre podria ser otro, como un estado de introduccion ##
export var initial_state := NodePath()

### Estado actual, al principio comienza con el estado inicial ###
onready var state: State = get_node(initial_state)

func _ready() -> void:
	# Espera que el nodo principal termine de cargar #
	yield(owner, "ready")
	
	# Se asigna dentro de la variable "state_machine" que contiene todo hijo
	# de este estado.
	for child in get_children():
		child.state_machine = self
	
	state.enter() # Inicializa el estado

### Delega las funciones del engine al estado actual ###
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

### 					Transiciona a un nuevo estado					###
## Opcionalmente toma un mensaje que puede transmitir al siguente estado ##
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	# Verifica que el nodo al cual se va a transicionar exista #
	if not has_node(target_state_name):
		return
	
	state.exit() # Realiza una ultima funcion antes de pasar de estado
	state = get_node(target_state_name)
	state.enter(msg) # Inicializa el nuevo estado con los mensajes opcionales
	emit_signal("transitioned", state.name)
