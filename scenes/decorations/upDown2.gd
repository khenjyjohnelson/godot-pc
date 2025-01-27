extends Sprite2D

var init_y: float = 0  # Menyimpan posisi Y awal
@export var move_range: float = 8  # Jarak naik turun yang lebih pendek 2 kali
@export var move_time: float = 2  # Durasi untuk sekali naik turun
@export var randomize_params: bool = false  # Apakah ingin mengacak parameternya?

func _ready():
	init_y = position.y  # Menyimpan posisi Y awal sprite
	
	# Menyesuaikan parameter jika randomize_params aktif
	if randomize_params:
		var rng = RandomNumberGenerator.new()
		move_range = rng.randf_range(3, 20)  # Jarak acak yang lebih pendek
		move_time = rng.randf_range(0.3, 1.9)  # Durasi acak antara 0.8 hingga 1.5 detik

	# Membuat tween untuk animasi naik turun berulang
	var tween = create_tween()

	# Tween untuk menggerakkan sprite naik
	tween.tween_property(self, "position", position + Vector2(0, move_range), move_time)

	# Tween untuk menggerakkan sprite turun setelah selesai naik
	tween.tween_property(self, "position", position - Vector2(0, move_range), move_time)
	
	# Looping animasi naik turun
	tween.set_loops(-1)  # Atur jumlah loop ke -1 agar berulang terus menerus
