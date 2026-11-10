# Ansible package setup

Installs the explicitly installed pacman packages listed in `vars/packages.yml`.

## Run

```sh
ansible-playbook playbook.yml -K
```

## Update the package list

```sh
./update-packages.sh
```

Regenerates `vars/packages.yml` from `pacman -Qqen`. AUR packages are not included.
