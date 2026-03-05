# Virtualización con KVM - Documentación Completa

**Versión:** 1.0
**Actualización:** Marzo 2026
**Autor:** neoxolotl

---

# Índice

1. Introducción
2. Arquitectura
3. Requisitos
4. Instalación
5. Componentes de KVM
6. Creación de Máquinas Virtuales
7. Administración de Máquinas
8. Redes en KVM
9. Almacenamiento
10. Mantenimiento
11. Solución de Problemas
12. Recursos

---

# 1. Introducción

**KVM (Kernel-based Virtual Machine)** es una tecnología de virtualización integrada en el kernel de Linux que permite ejecutar múltiples máquinas virtuales con diferentes sistemas operativos en un mismo servidor físico.

KVM convierte el kernel de Linux en un **hipervisor tipo 1**, permitiendo que cada máquina virtual funcione como si fuera un sistema independiente.

## Características

* Virtualización completa basada en hardware
* Integrado directamente en el **kernel de Linux**
* Alto rendimiento
* Compatible con múltiples sistemas operativos
* Administración mediante herramientas estándar de Linux
* Integración con **QEMU**
* Soporte para redes virtuales y almacenamiento avanzado

## Ventajas

* Software **libre y open source**
* Alto rendimiento comparado con otros hipervisores
* Amplia compatibilidad con hardware
* Fácil integración con herramientas de automatización

## Limitaciones

* Requiere CPU con soporte de virtualización
* Puede requerir configuración manual avanzada
* Interfaz gráfica opcional

---

# 2. Arquitectura

## Flujo de Virtualización

```
Hardware (CPU / RAM / Disco / Red)
        ↓
Kernel Linux con KVM
        ↓
QEMU (emulación y gestión)
        ↓
Máquinas Virtuales
        ↓
Sistemas Operativos Invitados
```

## Componentes Principales

* **KVM Kernel Module** → Proporciona virtualización en el kernel
* **QEMU** → Emulación de hardware
* **libvirt** → API para administrar máquinas virtuales
* **virt-manager** → Interfaz gráfica de administración

---

# 3. Requisitos

## Hardware

* CPU con soporte de virtualización

Intel:

* **Intel VT-x**

AMD:

* **AMD-V**

## Verificar soporte de virtualización

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```

Si el resultado es mayor que **0**, la CPU soporta virtualización.

---

## Software

Sistema operativo Linux compatible:

* Ubuntu
* Debian
* Fedora
* CentOS
* Arch Linux

Paquetes necesarios:

* qemu-kvm
* libvirt
* virt-manager
* bridge-utils

---

# 4. Instalación

## Ubuntu / Debian

```bash
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients virt-manager bridge-utils
```

---

## Verificar instalación

```bash
kvm-ok
```

---

## Iniciar servicio libvirt

```bash
sudo systemctl enable libvirtd
sudo systemctl start libvirtd
```

---

## Verificar estado

```bash
systemctl status libvirtd
```

---

# 5. Componentes de KVM

## KVM

Módulo del kernel que habilita virtualización usando el hardware del procesador.

---

## QEMU

Encargado de:

* Emulación de hardware
* Creación de máquinas virtuales
* Manejo de discos virtuales

---

## libvirt

Proporciona herramientas para administrar máquinas virtuales mediante API.

Comandos comunes:

```bash
virsh list
virsh start vm
virsh shutdown vm
```

---

## virt-manager

Interfaz gráfica para administrar máquinas virtuales.

Permite:

* Crear VM
* Administrar redes
* Configurar almacenamiento
* Ver consola de la VM

---

# 6. Creación de Máquinas Virtuales

## Crear disco virtual

```bash
qemu-img create -f qcow2 vm1.qcow2 20G
```

---

## Crear VM con virt-install

```bash
virt-install \
--name vm1 \
--ram 2048 \
--disk path=vm1.qcow2,size=20 \
--vcpus 2 \
--os-type linux \
--network bridge=virbr0 \
--graphics spice \
--cdrom ubuntu.iso
```

---

# 7. Administración de Máquinas

## Listar máquinas virtuales

```bash
virsh list --all
```

---

## Iniciar máquina

```bash
virsh start vm1
```

---

## Apagar máquina

```bash
virsh shutdown vm1
```

---

## Forzar apagado

```bash
virsh destroy vm1
```

---

## Eliminar máquina

```bash
virsh undefine vm1
```

---

# 8. Redes en KVM

KVM soporta diferentes tipos de redes virtuales.

## NAT (por defecto)

Las VM acceden a internet pero no son accesibles desde la red externa.

Interfaz típica:

```
virbr0
```

---

## Bridge

Permite que las máquinas virtuales estén en la misma red que el host.

Ejemplo:

```
eth0
br0
```

---

## Crear bridge en Linux

Ejemplo en `/etc/netplan`:

```yaml
network:
  version: 2
  renderer: networkd
  bridges:
    br0:
      interfaces: [eth0]
      dhcp4: yes
```

---

# 9. Almacenamiento

Formatos de disco soportados:

* **qcow2** (recomendado)
* raw
* vmdk
* vdi

## Crear disco qcow2

```bash
qemu-img create -f qcow2 disk.qcow2 40G
```

---

## Ver información del disco

```bash
qemu-img info disk.qcow2
```

---

# 10. Mantenimiento

## Ver uso de recursos

```bash
virsh dominfo vm1
```

---

## Consola de máquina virtual

```bash
virsh console vm1
```

---

## Backup de máquina virtual

```bash
virsh shutdown vm1
cp vm1.qcow2 backup_vm1.qcow2
```

---

# 11. Solución de Problemas

## KVM no disponible

Verificar soporte CPU:

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```

---

## libvirt no inicia

Revisar logs:

```bash
journalctl -u libvirtd
```

---

## Permisos de usuario

Agregar usuario al grupo libvirt:

```bash
sudo usermod -aG libvirt $USER
```

Cerrar sesión y volver a entrar.

---

## VM no inicia

Revisar estado:

```bash
virsh dominfo vm1
```

---

# 12. Recursos

## Documentación Oficial

KVM
https://www.linux-kvm.org

Libvirt
https://libvirt.org

QEMU
https://www.qemu.org

Virt Manager
https://virt-manager.org

---

# Licencia

**Licencia MIT**

Última revisión: **Marzo 2026**
Mantenido por: **neoxolotl**
Versión: **1.0**
