extends Node2D

@export var move_range: float = 8  # Jarak horizontal (kiri/kanan)
@export var move_time: float = 2  # Durasi untuk sekali gerakan
@export var randomize_params: bool = false  # Apakah ingin mengacak parameternya?

var init_x: float = 0  # Menyimpan posisi X awal

func _ready():
	init_x = position.x  # Menyimpan posisi X awal node
	
	# Menyesuaikan parameter jika randomize_params aktif
	if randomize_params:
		var rng = RandomNumberGenerator.new()
		move_range = rng.randf_range(5, 15)  # Jarak acak horizontal
		move_time = rng.randf_range(0.8, 1.5)  # Durasi acak antara 0.8 hingga 1.5 detik

	# Membuat tween untuk animasi bergerak horizontal
	var tween = create_tween()

	# Tween untuk menggerakkan node ke kanan
	tween.tween_property(self, "position", position + Vector2(move_range, 0), move_time)

	# Tween untuk menggerakkan node kembali ke kiri setelah selesai bergerak ke kanan
	tween.tween_property(self, "position", position - Vector2(move_range, 0), move_time)
	
	# Looping animasi bergerak horizontal
	tween.set_loops(-1)  # Atur jumlah loop ke -1 agar berulang terus menerus
