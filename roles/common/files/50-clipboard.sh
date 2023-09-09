if [ "$XDG_SESSION_TYPE" = "wayland" ]
then
	alias clipinspect='wl-paste | xxd'
	alias clipin='wl-copy'
	alias clipout='wl-paste'
	alias clipqr='qrencode -t utf8 $(clipout)'
else
	alias clipinspect='xclip -out -selection clipboard | xxd'
	alias clipin='xclip -in -selection clipboard'
	alias clipout='xclip -out -selection clipboard'
	alias clipqr='qrencode -t utf8 $(clipout)'
fi
