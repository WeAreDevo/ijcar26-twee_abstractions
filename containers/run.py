"""Load checkout configuration before executing a command inside Apptainer."""
import argparse
import os
from pathlib import Path

from dotenv import load_dotenv


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, required=True)
    parser.add_argument("--preserve", action="append", default=[])
    parser.add_argument("command", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    command = args.command
    if command[:1] == ["--"]:
        command = command[1:]
    if not command:
        parser.error("a command is required")

    # Explicit host settings win over .env, which wins over image defaults.
    overrides = {name: os.environ[name] for name in args.preserve}
    load_dotenv(args.root / ".env", override=True)
    os.environ.update(overrides)
    os.environ.setdefault("KRYMPA_ROOT", "/opt/twitch/third_party/Krympa")
    os.execvpe(command[0], command, os.environ)


if __name__ == "__main__":
    main()
