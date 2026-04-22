# discord-autoupdate

Atualiza o Discord sozinho no Linux, usando os pacotes oficiais da sua distro. Sem Flatpak, sem Snap, sem AUR helper.

- **Ubuntu / Debian / derivados:** baixa o `.deb` oficial do site do Discord e instala via `apt`.
- **Arch / CachyOS / Manjaro / EndeavourOS:** atualiza o pacote `extra/discord` via `pacman` (é o mesmo binário oficial, só empacotado pra Arch).

Funciona como um timer do systemd: roda 5 min depois do boot e depois 1x por dia. Se a máquina estava desligada na hora, ele recupera assim que liga.

## Instalação

```bash
git clone https://github.com/lithhhh/discord-autoupdate.git
cd discord-autoupdate

sudo install -m 755 discord-autoupdate.sh       /usr/local/bin/
sudo install -m 644 discord-autoupdate.service  /etc/systemd/system/
sudo install -m 644 discord-autoupdate.timer    /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable --now discord-autoupdate.timer
```

## Testando

```bash
# roda agora e mostra o log
sudo systemctl start discord-autoupdate.service
journalctl -u discord-autoupdate.service -n 20

# próxima execução agendada
systemctl list-timers discord-autoupdate.timer
```

## Desinstalar

```bash
sudo systemctl disable --now discord-autoupdate.timer
sudo rm /etc/systemd/system/discord-autoupdate.{service,timer}
sudo rm /usr/local/bin/discord-autoupdate.sh
sudo systemctl daemon-reload
```

## Avisos

- Precisa de root pra instalar pacote do sistema — o systemd já cuida disso.
- No Arch, versões PTB, Canary ou `discord_arch_electron` do AUR **não** são cobertas. AUR precisa de helper (`yay`/`paru`) rodando como usuário normal.
- Dependências: `curl` (Ubuntu) ou `pacman` (Arch).

## Licença

MIT
