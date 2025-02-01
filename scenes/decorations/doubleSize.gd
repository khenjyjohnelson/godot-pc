extends Sprite2D

@export var scale_factor: float = 1.0  # Faktor pembesaran (2X ukuran asli)
@export var shrink_factor: float = 0.5  # Faktor penyusutan (1/2 ukuran asli)
@export var move_time: float = 3  # Durasi untuk sekali animasi (dalam detik)
@export var randomize_params: bool = false  # Apakah ingin mengacak durasi?

func _ready():
	# Menyesuaikan parameter jika randomize_params aktif
	if randomize_params:
		var rng = RandomNumberGenerator.new()
		move_time = rng.randf_range(0.1, 0.3)  # Acak durasi animasi antara 0.1 hingga 0.3 detik

	# Membuat tween untuk animasi memperbesar dan menyusutkan sprite
	var tween = create_tween()
	
	# Animasi memperbesar sprite
	tween.tween_property(self, "scale", Vector2(scale_factor, scale_factor), move_time)

	# Animasi menyusutkan sprite setelah selesai memperbesar
	tween.tween_property(self, "scale", Vector2(shrink_factor, shrink_factor), move_time)
	
	# Looping animasi naik turun
	tween.set_loops(0)  # Mengatur animasi untuk berulang terus-menerus
