# (Partial) ansible repository

**Important:** Not everything is currently managed by ansible. This is a humble
attempt at making management of the infrastructure less opaque.

## Usage

- Run `make production` to do a full rollout.
- Pass `AFLAGS` to `make` (e.g. `make AFLAGS="--check --diff" production`) to
  pass arguments to ansible.
- Install and set up direnv and install ansible via requirements.txt for less
  pain.

## DNS primary

The DNS primary runs on atlas and is configured using the `pdns` role.
Interacting with zone data is done using the `pdnsutil` on the shell on atlas.

**Important**: `pdnsutil` MUST be run as the pdns user, since it accesses the
LMDB files directly. Running it as root can cause issues with pdns because it
might create temporary LMDB files with the wrong permissions.

### Adding a zone

Creating zones is done via ansible. Add the zone to the `pdns_zones_v2` list in
`host_vars/atlas.xmpp.org/pdns.yml` and start an ansible run (you can use
`-t pdns-zones-v2` to limit it to zone creations).

All zones are created with DNSSEC enabled. This does not cause harm.

### List all zones

```console
$ sudo -u pdns pdnsutil list-all-zones
```

### Editing zone contents

```console
$ sudo -u pdns pdnsutil edit-zone $zone
$ sudo systemctl restart pdns
$ sudo pdnsutil notify $zone
```

When editing zone contents, make sure to increase the SOA serial number. If
you forget to do that manually, `pdnsutil` will ask you if it shall do it for
you. You should accept that offer.

The serial format across all zones is `YYYYMMDDNN`, where `NN` is a counter
incremented in **steps of two**, and reset to zero when `YYYYMMDD` changes.

#### Checking propagation to secondaries

This should print a SOA with a serial matching the one of your edit. You can
also substitute the `dig` call inside the loop with something more specific
(e.g. a question for the record you actually changed):

```
$ for secondary in $(dig +short @atlas.xmpp.org NS $zone); do dig +short @$secondary SOA $zone; done
```

This command should work "immediately" (1-2 seconds) after the
`pdnsutil notify` above has completed. If does not print the up-to-date
results even after a minute or so, check `pdns` logs for AXFR-related or
notify-related errors.
