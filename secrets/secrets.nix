let
	meowzy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHEbTdFzG0NILTm05vs72G0uzJYchQLbOXYIOrDk+Ace";
	surf = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIXFgak8o2U0MmwO3LgM5/4j5u5gcW82Yl4DttoVe0JN";
	labrat = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGqE0F8RnKFXvjAoh0zwzVgXerljHpBEc197YWgGnZ4F";
	all = [ meowzy surf labrat ];
in
{
	# "wifi.age".publicKeys = all;
}
