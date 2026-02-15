extends Actor
class_name BaseNpc

@onready var sprite: Sprite2D = $Sprite2D
@onready var tower_combat: TowerCombatComponent = $TowerCombatComponent

func _ready() -> void:
	super._ready()
	add_to_group("allies")

func setup(npc_data: Dictionary, texture: Texture2D) -> void:
	if texture:
		if is_node_ready() and sprite:
			sprite.texture = texture
		else:
			# Se nao estiver pronto java, aguarda o _ready
			# Mas como sprite e onready, podemos forcar ou guardar em var
			# Melhor abordagem: injetar a dependencia ou aguardar
			# Vamos usar call_deferred ou apenas aguardar se for null?
			# O setup geralmente configura dados. Vamos guardar a textura e aplicar no _ready se precisar.
			pass # Hack rapido:
			
	# FIX: Se o no nao estiver pronto, o @onready sprite sera null.
	# Vamos garantir que a textura seja aplicada mesmo se chamado antes do add_child.
	if texture:
		if sprite:
			sprite.texture = texture
		else:
			# Aguarda o ready para aplicar
			await ready
			if sprite:
				sprite.texture = texture
	
	print_debug("[BaseNpc] Setup concluido: %s" % npc_data.get("name", "Unknown"))
