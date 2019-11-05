#!/usr/bin/env python3

"""Manage autofuse configuration via yaml file"""

from pathlib import Path

import yaml

ROOT = Path("/etc/autofs")


class Host:
    _hosts = []

    def __init__(self, name, root, options, timeout=5, ghost=True):
        self.name = name
        self.root = Path(root)
        self.options = options
        self.timeout = str(timeout)
        self.ghost = ghost
        self._hosts.append(self)

    @classmethod
    def resolve_host(cls, name):
        host = next((i for i in cls._hosts if i.name == name))
        return host

    def get_map(self, mount_name, mount_root):
        mnt_path = ROOT / f'auto.{mount_name}'
        _ghost = "--ghost" if self.ghost else ""
        return f"{mount_root} {mnt_path} --time-out={self.timeout} {_ghost}\n"


class Mount:

    def __init__(self, name, host, root, mount, mounts, options=[]):
        self.name = name
        self._host = host
        self._root = root
        self.mount = Path(mount).resolve()
        self._mounts = mounts
        self._options = options

    @property
    def host(self):
        return Host.resolve_host(self._host)

    @property
    def root(self):
        return self.host.root / Path(self._root)

    @property
    def options(self):
        opts = set([*self.host.options, *self._options])
        opts = ",".join(opts)
        opts_str = f"-{opts}"
        return opts_str

    @property
    def map(self):
        return self.host.get_map(self.name)

    @property
    def file_name(self):
        return f"auto.{self.name}"

    def get_remote_path(self, mount):
        _path = self.root / mount
        return f"{self.host.name}:{_path}"

    def iter_mounts(self):
        for m in self._mounts:
            mnt = (
                f"# {m.capitalize()}\n"
                f"{m} {self.options} {self.get_remote_path(m)}\n"
            )
            yield mnt


def load():
    config = Path(__file__).parent / 'autofs.yml'
    data = yaml.load_all(config.read_text())
    hosts = [Host(**h) for h in next(data)]
    mounts = [Mount(**m) for m in next(data)]
    print(hosts, mounts)
    return (hosts, mounts)


def main():
    master = ROOT / 'auto.master'
    hosts, mounts = load()
    for m in mounts:
        lines = master.read_text().splitlines(keepends=True)
        stripped = [l.strip() for l in lines]
        map_line = m.host.get_map(m.name, m.mount)
        if map_line.strip() not in stripped:
            lines.append(f"\n{map_line}")
            master.write_text("".join(lines))
        mount_file = ROOT / m.file_name
        mount_file.write_text("\n".join(m.iter_mounts()))
        mount_file.chmod(0o644)
    master.chmod(0o510)
    print("Done!")


if __name__ == '__main__':
    main()
