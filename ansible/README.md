# (Partial) ansible repository

**Important:** Not everything is currently managed by ansible. This is a humble
attempt at making management of the infrastructure less opaque.

## Usage

- Run `make production` to do a full rollout.
- Pass `AFLAGS` to `make` (e.g. `make AFLAGS="--check --diff" production`) to
  pass arguments to ansible.
- Install and set up direnv and install ansible via requirements.txt for less
  pain.
