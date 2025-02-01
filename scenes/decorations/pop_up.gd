extends Node

# Referensi ke animasi ledakan
@export var explosion_scene: PackedScene

# Fungsi untuk menangani tabrakan
func _on_body_entered(body):
	if body.is_in_group("explodable"):  # Menyaring jika objek yang bersentuhan adalah explodable
		explode()

# Fungsi untuk meledakkan objek
func explode():
	# Buat instance dari ledakan
	var explosion = explosion_scene.instantiate()
	
	# Set posisi ledakan sesuai dengan posisi node ini
	explosion.position = self.position  # Akses 'position' dari parent Node2D jika diperlukan
	
	# Menambahkan ledakan ke scene
	get_parent().add_child(explosion)
	
	# Hapus objek ini setelah meledak
	queue_free()
