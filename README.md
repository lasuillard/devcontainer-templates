# devcontainer-templates

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Personal [Dev Container Templates](https://containers.dev/implementors/templates/).

## 📋 Using templates

You can see the list of available templates and its content in the [src](./src) directory.

```bash
$ devcontainer templates apply \
  --template-id ghcr.io/lasuillard/devcontainer-templates/nix:0 \
  --template-args '{"projectName": "lasuillard/my-new-project"}'
```

If using VS Code with [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension, you can create new dev container with `Dev Containers: New Dev Container...` in command palette.

![VS Code - New Dev Container](docs/vscode-new-devcontainer-from-template.png)

## 🧑‍💻 Development

See [CONTRIBUTING.md](./CONTRIBUTING.md) file for development instructions.
