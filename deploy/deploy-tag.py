#!/usr/bin/env python3

import argparse
import shlex
import shutil
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser("deploy-tag")
    parser.add_argument("docker_tag")
    parser.add_argument("deployment_group")
    parser.add_argument("--description", default=None)
    opts = parser.parse_args()

    description = opts.description if opts.description else f"Deploy {opts.docker_tag}"

    # write the environment file
    with open("deploy/tag.env", "w") as fh:
        fh.write(f"PLANORAMA_DOCKER_TAG={opts.docker_tag}\n")

    cli = shutil.which("aws")
    command = [
        cli,
        "deploy",
        "push",
        "--application-name",
        "Planorama",
        "--s3-location",
        f"s3://deploy.chicon.org/planorama/{opts.docker_tag}.zip",
        "--source",
        ".",
        "--description",
        description,
    ]

    res = subprocess.run(command, cwd="./deploy", capture_output=True)
    if res.returncode != 0:
        print(f"{' '.join(res.args)}:")
        print("--- STDOUT --")
        print(res.stdout)
        print("--- STDERR --")
        print(res.stderr)
        sys.exit(res.returncode)

    lines = [_.decode("utf-8") for _ in res.stdout.splitlines()]
    deploy_command_line = [_ for _ in lines if "aws deploy create-deployment" in _][0]
    command_parts = shlex.split(deploy_command_line)

    def keep(parts):
        skip_next = False
        for part in parts:
            if skip_next:
                skip_next = False
                continue

            if part in (
                "--deployment-group-name",
                "--deployment-config-name",
                "--description",
            ):
                skip_next = True
                continue

            yield part

    command = list(keep(command_parts))
    command += ["--description", description]
    command += ["--deployment-group-name", opts.deployment_group]

    subprocess.run(command).check_returncode()


if __name__ == "__main__":
    main()
