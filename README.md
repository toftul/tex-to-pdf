# tex-to-pdf

A Bash script that compiles each standalone `.tex` file in the current folder to PDF. Then it removes the temporary files. Requires `latexmk` to be installed (TeX Live and MiKTeX include it).


## Usage

### In one folder

1. Copy `tex-to_pdf.sh` into the folder with your `.tex` files.
2. Run the script:

   ```sh
   ./tex-to_pdf.sh
   ```

### In all folders

1. Copy the script to your user `bin` folder:

   ```sh
   mkdir -p ~/.local/bin
   cp tex-to_pdf.sh ~/.local/bin/tex-to-pdf
   ```

2. Make sure that `~/.local/bin` is in your `PATH`.
3. In the folder with your `.tex` files, run:

   ```sh
   tex-to-pdf
   ```

### Keep the `.bbl` files

By default, the script removes each `.bbl` file that it can make again from a `.bib` file. To keep the `.bbl` files, add `--keep-bbl`:

```sh
tex-to-pdf --keep-bbl
```

## How it works

The script compiles only the files that contain `\documentclass`. It skips other `.tex` files, because they are inputs for the main files.

`latexmk` runs the LaTeX engine and `biber` or `bibtex` as many times as necessary. The default engine is `lualatex`. To use `pdflatex` or `xelatex`, add this line to the top of the file:

```tex
% !TEX program = xelatex
```

If a compilation fails, the script keeps the log file and shows the first errors. The exit code is 1.

## License

MIT
