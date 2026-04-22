# discord-autoupdate

Auto-atualização do Discord no Linux, usando os pacotes oficiais da distro — sem Flatpak, sem Snap, sem AUR helper.

- **Debian / Ubuntu / derivados:** baixa o `.deb` oficial de `discord.com/api/download` e instala via `apt`.
- **Arch / CachyOS / Manjaro / EndeavourOS:** atualiza o pacote oficial `extra/discord` via `pacman` (que é o mesmo binário oficial do Discord, só empacotado).

Roda como um `systemd` timer: 5 min após o boot e depois 1x por dia. `Persistent=true` recupera execuções perdidas enquanto a máquina estava desligada.

## Instalação

```bash
git clone https://github.com/<seu-user>/discord-autoupdate.git
cd discord-autoupdate

sudo install -m 755 discord-autoupdate.sh       /usr/local/bin/
sudo install -m 644 discord-autoupdate.service  /etc/systemd/system/
sudo install -m 644 discord-autoupdate.timer    /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable --now discord-autoupdate.timer
```

## Verificação

```bash
# rodar agora e ver o log
sudo systemctl start discord-autoupdate.service
journalctl -u discord-autoupdate.service -n 20

# próximo disparo agendado
systemctl list-timers discord-autoupdate.timer
```

## Desinstalação

```bash
sudo systemctl disable --now discord-autoupdate.timer
sudo rm /etc/systemd/system/discord-autoupdate.{service,timer}
sudo rm /usr/local/bin/discord-autoupdate.sh
sudo systemctl daemon-reload
```

## Observações

- O script precisa de root (instala pacote de sistema). O `systemd` já roda como root por padrão.
- No Arch, se você usa versões não-oficiais (`discord_arch_electron`, PTB, Canary via AUR), este script **não** cobre — AUR precisa de helper tipo `yay`/`paru` rodando como usuário normal.
- Requer `curl` (Debian/Ubuntu) ou `pacman` (Arch).

## Licença

MIT
