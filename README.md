# Summary

My dotfiles repository.
Managed dotfiles are configured in file `dotfiles.yaml`

# Install dotfiles from here

```sh
./dotfiles install
```

This will create a bunch of symlinks at the correct locations in your file-
system into this repository. If a file with the same name as the symlink
already exists and is not already a symlink it is backed-up. If it is
already a symlink nothing is done.

# Add another file to dotfiles repository

Let's say you want the repository to manage the file `~/config/important_file`
This can be done by calling

```sh
./dotfiles add "Important file" important_file ~/config/important_file
```

This will copy the file into the repository and replace the original
location with a symlink. It also creates an entry into the YAML config file.

If also works with directories like `~/.config/nvim`
```sh
./dotfiles add "NeoVIM config" nvim ~/config/nvim
```

# Potential future functionality

* Restore backup
* Remove dotfile
* localized dotfiles depending on local machine
* Support for whole directories
    * Mostly supported implictly already
    * But support to properly ignore some files is missing
    * Ignored files should also show up correctly in .gitignore
