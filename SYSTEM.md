# System

The desktop these dotfiles run on: hardware, disk encryption, and maintenance. As of 2026-11-14.

IDs (UUIDs, PARTUUIDs, serial numbers) are left out on purpose and shown as `<placeholders>`. Find the real ones with `lsblk -o NAME,MODEL,FSTYPE,UUID,PARTUUID`.

## Hardware

| | |
|---|---|
| Board | ASUS ROG STRIX B650E-F GAMING WIFI |
| BIOS | 3881 (AGESA ComboAm5PI 1.3.0.1b), flashed from 3602 with USB BIOS FlashBack |
| CPU | AMD Ryzen 9 9950X3D2: 16 cores / 32 threads on two CCDs, 192 MiB L3 (V-Cache on both CCDs). ASUS validates it from BIOS 3265. |
| Memory | 2 × 32 GB Corsair Vengeance DDR5-6400 CL32 (`CMK64GX5M2B6400C32`), DOCP on, 6400 MT/s |
| Cooler | Arctic Liquid Freezer III Pro 420, radiator on top of the case. One combined cable on `CPU_FAN` runs the pump, the fans and the VRM fan. `AIO_PUMP` is empty. |
| Case | HAVN HS 420. The top mount takes a 420 mm radiator up to 65 mm thick without overlapping the RAM. |
| System drive | Samsung 990 PRO 2TB, PCIe 4.0 x4 |
| Data drive (`extra`) | Samsung 970 EVO Plus 1TB, PCIe 3.0 x4 |
| Backup drive | Sabrent Rocket 4.0 500GB, PCIe 4.0 x4 |

### BIOS flashing

USB BIOS FlashBack needs no OS. Format a USB stick as FAT32, copy the `.CAP` from the ASUS zip to its root as `SB650EF.CAP`, plug it into the rear FlashBack port with the PC off, and hold the FlashBack button until the LED blinks. FlashBack resets BIOS settings, so turn DOCP back on afterwards. Verify the result with `cat /sys/class/dmi/id/bios_version`.

### CPU swap: 9700X to 9950X3D2

| | Ryzen 7 9700X | Ryzen 9 9950X3D2 |
|---|---|---|
| Cores / threads | 8 / 16, one CCD | 16 / 32, two CCDs |
| L2 / L3 | 8 MiB / 32 MiB | 16 MiB / 192 MiB (2 × 96) |
| Max boost | 5582 MHz | 5665 MHz |
| Rated power | 65 W | 200 W |
| Preferred-core ranks | 166–196 | 166–236. CCD 0 ranks above CCD 1. |

### Fan sensors

Fan and pump speeds need the Nuvoton driver. `/etc/modules-load.d/nct6775.conf` contains `nct6775`, so it loads at boot. The chip shows up as `nct6799`.

### CPU tuning

The defaults are right for this chip, and nothing is changed:

- `amd-pstate-epp` in active mode, the `powersave` governor, EPP `balance_performance`, preferred core on.
- `amd_x3d_vcache` is in `frequency` mode. Both CCDs carry V-Cache, so the mode only changes the preferred-core ranking.
- Keeping a game on one CCD (CPUs `0-7,16-23`, the higher-ranked CCD) avoids slow traffic between the CCDs. Use `gamemode`'s core pinning or `taskset -c 0-7,16-23`.

`/etc/makepkg.conf.d/parallel.conf` sets `MAKEFLAGS="-j$(nproc)"`, so AUR builds use all 32 threads.

## Storage layout

| Drive | Partition | Contents |
|---|---|---|
| 990 PRO | 1 GB vfat | ESP at `/efi`. The firmware must read it, so it is not encrypted. |
| 990 PRO | 64 GB | Swap, encrypted with a random key every boot |
| 990 PRO | 1.8 TB | LUKS2 `root` → btrfs, subvolumes `@` (`/`) and `@home` (`/home`) |
| 970 EVO Plus | 1 TB | LUKS2 `extra` → btrfs at `~/extra` |
| Sabrent | 500 GB | ext4 at `/mnt/backup`, the restic repository (restic encrypts it) |

The btrfs mounts use `noatime,compress=zstd:3,ssd,discard=async,space_cache=v2`. The NVMe I/O scheduler is `none`.

## Disk encryption

Root and `extra` are LUKS2. Boot needs the YubiKey's FIDO2 PIN and one touch. With no key, it asks for the LUKS passphrase after 30 seconds.

### Boot chain

- systemd-boot loads unified kernel images (UKIs) from `/efi/EFI/Linux/`. `kernel-install` builds them with mkinitcpio for both `linux` and `linux-lts`:
  ```ini
  # /etc/kernel/install.conf
  layout=uki
  uki_generator=mkinitcpio
  ```
  The mkinitcpio presets and their pacman hooks are not used. The hooks are masked in `/etc/pacman.d/hooks/`. To rebuild: `sudo kernel-install add-all`.
- The initramfs is systemd-based, with `sd-encrypt`:
  ```
  HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block sd-encrypt filesystems fsck)
  ```
- The kernel command line is `root=UUID=<btrfs-uuid> rootflags=subvol=@`. The btrfs UUID did not change when the partition was encrypted, so the command line did not either.

### `/etc/crypttab`

```
root   UUID=<root-luks-uuid>       none                               fido2-device=auto,token-timeout=30s,discard,x-initrd.attach
extra  UUID=<extra-luks-uuid>      /etc/cryptsetup-keys.d/extra.key   discard,nofail
swap   PARTUUID=<swap-partuuid>    /dev/urandom                       swap,cipher=aes-xts-plain64,size=512,sector-size=4096
```

- **`root`** is unlocked in the initramfs. mkinitcpio 42 copies only the crypttab lines marked `x-initrd.attach` into the initramfs. `/etc/crypttab.initramfs` is deprecated.
- **`extra`** is unlocked after switch-root, from a random 512-byte key file kept on the encrypted root (`/etc/cryptsetup-keys.d/`, mode 0400). Its FIDO2 and passphrase slots stay as backups. The key file path has to be written in the third field. With `none`, systemd tries the FIDO2 token in the LUKS header first and asks for a PIN before it reaches the auto-discovered key file.
- **`swap`** gets a new random key at every boot, so its contents do not survive a reboot. This rules out hibernation, which is not used. The GPT "no-auto" bit (63) is set on the swap partition, so `systemd-gpt-auto-generator` does not activate the raw partition: `sfdisk --part-attrs <disk> <partnum> GUID:63`.
- **`discard`** lets TRIM reach the SSDs through dm-crypt. Anyone holding a drive can then see which blocks are empty, but not what was in them.

### `/etc/fstab` additions

```
UUID=<extra-btrfs-uuid>  /home/<user>/extra  btrfs  rw,noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,nofail,x-systemd.device-timeout=90s  0 0
/dev/mapper/swap         none                swap   defaults  0 0
```

### How root was encrypted in place

LUKS2 can encrypt an existing partition without copying the data off.

1. **On the running system:**
   - Shrink btrfs by 32 MiB to make room for the LUKS2 header: `btrfs filesystem resize 1:-32M /`. The `1:` devid prefix stops `-32M` from being read as an option.
   - Add `sd-encrypt` to `HOOKS`, then run `kernel-install add-all`.
   - Reboot once to prove the rebuilt UKIs still boot.
2. **From the Arch live USB**, with the partition unmounted:
   ```bash
   cryptsetup reencrypt --encrypt --type luks2 --reduce-device-size 32M --uuid <chosen-luks-uuid> /dev/disk/by-partuuid/<root-partuuid>
   ```
   Choosing `--uuid` ahead of time means the crypttab line can be written before the encryption runs. It encrypts the whole partition, used or not. An interrupted run resumes with `cryptsetup reencrypt --resume-only <device>`.
3. **Open, mount `@`, `@home` and the ESP, and `arch-chroot`:**
   - Add the `root` line to `/etc/crypttab`.
   - Enroll the key: `systemd-cryptenroll --fido2-device=auto /dev/disk/by-uuid/<root-luks-uuid>`.
   - Rebuild: `kernel-install add-all`.
   - Check the initramfs crypttab: `lsinitcpio -x <uki>` and read `etc/crypttab`.
4. **Then swap**, live:
   - `swapoff`, then `blkdiscard` the old plaintext swap.
   - Set the no-auto bit, add the crypttab and fstab lines.
   - `systemctl start systemd-cryptsetup@swap.service dev-mapper-swap.swap`.

The ISO was checked against Arch's keyring with no network needed:

```bash
gpg --dearmor < /usr/share/pacman/keyrings/archlinux.gpg > archlinux.gpg
gpgv --keyring ./archlinux.gpg archlinux-<version>-x86_64.iso.sig archlinux-<version>-x86_64.iso
```

### Recovery

| Problem | What to do |
|---|---|
| YubiKey missing | Wait 30 seconds at boot, then enter the passphrase. Test a passphrase any time with `cryptsetup open --test-passphrase <device>`. |
| Wrong FIDO2 PIN | Eight wrong PINs lock FIDO2 on the key, and a reset wipes its `-sk` SSH keys. A correct PIN resets the count. Check it with `ykman fido info`. |
| Main kernel will not boot | Pick the `linux-lts` UKI in systemd-boot. |
| Nothing boots | From the live USB: `cryptsetup open <root-device> root`, mount `subvol=@`, `subvol=@home` and the ESP, `arch-chroot`, check `/etc/crypttab`, then `kernel-install add-all`. |
| A password prompt you cannot see | Answer it from a terminal with `sudo systemd-tty-ask-password-agent`. |

### What it protects against

It protects every drive's contents if the PC or a drive is stolen or sent away for RMA. It does not protect against tampering by someone with time alone at the machine. Secure Boot is off, so a modified UKI on the unencrypted ESP could capture the passphrase. Turning on Secure Boot with `sbctl` would close that gap; `91-sbctl.install` is already in the kernel-install chain. Blocks the SSD retired before encryption may still hold old plaintext in its spare area, out of reach of normal reads.

## Maintenance

| What | How | Schedule |
|---|---|---|
| TRIM | `fstrim.timer`. The btrfs mounts also discard continuously (`discard=async`). | Weekly |
| btrfs scrub of `/` | `btrfs-scrub@-.timer` | Monthly |
| Drive health | `smartd` (smartmontools) | Continuous |
| Backup | restic, backing up `/home` and `/etc` to `/mnt/backup` | `restic-backup.timer` |

Before risky disk work, take a fresh backup: `sudo systemctl start restic-backup.service`. Keep the restic repository password off this machine. Without it the backup cannot be read.

### SSD health baseline (2026-11-14)

| | Wear | Spare | Media errors | Written |
|---|---|---|---|---|
| 990 PRO 2TB | 6% | 100% | 0 | 70.9 TB |
| 970 EVO Plus 1TB | 0% | 100% | 0 | 10.6 TB |
| Rocket 4.0 500GB | 12% | 100% | 0 | 50.3 TB |

Check with `sudo smartctl -H -A /dev/nvmeN`. NVMe names (`nvme0`, `nvme1`, `nvme2`) can change between boots, so match drives by model. The 990 PRO's firmware is newer than `1B2QJXD7`, the fix for the early 990 PRO health-drop bug.

## Known issues

- One USB port fails to enumerate at every boot (`usb 6-5 … error -71`). A loose or partly seated front-panel header is the likely cause, after the case was worked on.
