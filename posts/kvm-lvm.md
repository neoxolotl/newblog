# KVM con LVM - Gestión y Expansión de Discos

**Versión:** 1.0
**Actualización:** Marzo 2026
**Autor:** neoxolotl

---

# Índice

1. Introducción
2. Arquitectura
3. Requisitos
4. Tipos de Almacenamiento en KVM
5. Uso de LVM en el Host
6. Expandir Disco desde el Host
7. Detectar Nuevo Tamaño dentro de la VM
8. Expandir Particiones dentro de la VM
9. Expandir LVM dentro de la VM
10. Redimensionar Sistema de Archivos
11. Expansión Online
12. Solución de Problemas
13. Recursos

---

# 1. Introducción

KVM permite utilizar múltiples métodos de almacenamiento para máquinas virtuales.
Uno de los más utilizados en entornos de producción es **LVM (Logical Volume Manager)**.

LVM permite:

* ampliar discos sin apagar el sistema
* gestionar almacenamiento dinámicamente
* mejorar snapshots y backups
* administrar múltiples discos físicos

Este documento explica cómo **expandir discos de máquinas virtuales KVM usando LVM**, tanto desde el **host** como desde el **sistema invitado**.

---

# 2. Arquitectura

## Flujo de almacenamiento

```id="y8rx9b"
Disco físico
    ↓
Volume Group (LVM)
    ↓
Logical Volume
    ↓
Disco virtual de la VM
    ↓
Partición dentro de la VM
    ↓
Filesystem (ext4 / xfs)
```

---

# 3. Requisitos

## Host

* Linux con soporte **KVM**
* **LVM2 instalado**
* **libvirt**
* **qemu-kvm**

Instalar herramientas necesarias:

```bash id="8xthm3"
sudo apt install lvm2 qemu-utils
```

---

## Máquina virtual

Debe usar alguno de estos sistemas de archivos:

* ext4
* xfs
* btrfs

---

# 4. Tipos de Almacenamiento en KVM

KVM soporta varios métodos para discos virtuales.

## Archivo de disco

```id="4g7g2y"
vm1.qcow2
vm1.raw
```

Ventajas:

* fácil de mover
* snapshots

---

## Disco basado en LVM

```id="lgh9gk"
 /dev/vg_kvm/vm1_disk
```

Ventajas:

* mayor rendimiento
* mejor integración con almacenamiento físico
* expansión más rápida

---

# 5. Uso de LVM en el Host

## Crear Physical Volume

```bash id="ixg63n"
pvcreate /dev/sdb
```

---

## Crear Volume Group

```bash id="o9j81p"
vgcreate vg_kvm /dev/sdb
```

---

## Crear Logical Volume

```bash id="mjlwm3"
lvcreate -L 40G -n vm1_disk vg_kvm
```

---

## Usar el disco en KVM

```bash id="n5h3g9"
virt-install \
--name vm1 \
--ram 4096 \
--disk path=/dev/vg_kvm/vm1_disk \
--vcpus 2 \
--cdrom ubuntu.iso
```

---

# 6. Expandir Disco desde el Host

Primero expandimos el **logical volume**.

Ejemplo: agregar **20GB** al disco.

```bash id="4xq6pu"
lvextend -L +20G /dev/vg_kvm/vm1_disk
```

---

Verificar tamaño nuevo:

```bash id="45fxf9"
lvdisplay
```

---

Si se usa **archivo qcow2**:

```bash id="v8phin"
qemu-img resize vm1.qcow2 +20G
```

---

# 7. Detectar Nuevo Tamaño dentro de la VM

Dentro de la máquina virtual debemos detectar el nuevo tamaño del disco.

```bash id="wzn0hg"
lsblk
```

---

Actualizar información del disco:

```bash id="vgbp1r"
sudo partprobe
```

---

También puede usarse:

```bash id="3kqg2l"
echo 1 > /sys/class/block/sda/device/rescan
```

---

# 8. Expandir Particiones dentro de la VM

Ver particiones:

```bash id="02h9m1"
fdisk -l
```

---

Expandir partición con **growpart**:

```bash id="axt4r0"
growpart /dev/sda 1
```

---

Instalar growpart si no existe:

```bash id="3x68e7"
sudo apt install cloud-guest-utils
```

---

# 9. Expandir LVM dentro de la VM

Si la VM también usa LVM.

## Ver discos

```bash id="4w0qxm"
lsblk
```

---

## Expandir Physical Volume

```bash id="iv43mw"
pvresize /dev/sda1
```

---

## Expandir Logical Volume

```bash id="szib9q"
lvextend -l +100%FREE /dev/vgroot/root
```

---

# 10. Redimensionar Sistema de Archivos

## Para EXT4

```bash id="j0qjtf"
resize2fs /dev/vgroot/root
```

---

## Para XFS

```bash id="9ju1so"
xfs_growfs /
```

---

Verificar tamaño final:

```bash id="8ohxtk"
df -h
```

---

# 11. Expansión Online

Una ventaja de **KVM + LVM** es que muchos cambios pueden hacerse **sin apagar la VM**.

Flujo típico:

```id="5k1d95"
Host:
lvextend

VM:
partprobe
pvresize
lvextend
resize filesystem
```

Todo puede hacerse **en caliente (online)**.

---

# 12. Solución de Problemas

## La VM no detecta el nuevo tamaño

Ejecutar:

```bash id="3ht7fs"
partprobe
```

o

```bash id="b5q1g7"
echo 1 > /sys/class/block/sda/device/rescan
```

---

## Error al extender filesystem

Verificar tipo:

```bash id="2a2uh9"
lsblk -f
```

---

## LVM no detecta espacio

Actualizar PV:

```bash id="e2fbtr"
pvresize /dev/sda1
```

---

## Ver estado de LVM

```bash id="dmd5kh"
pvs
vgs
lvs
```

---

# 13. Recursos

## Documentación

LVM
https://sourceware.org/lvm2

KVM
https://www.linux-kvm.org

Libvirt
https://libvirt.org

QEMU
https://www.qemu.org

---

# Licencia

**Licencia MIT**

Última revisión: **Marzo 2026**
Mantenido por: **neoxolotl**
Versión: **1.0**
