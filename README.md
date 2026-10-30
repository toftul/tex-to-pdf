# tex-to-pdf

A Bash script that compiles each standalone `.tex` file in the current folder to PDF. Then it removes the temporary files. Requires `latexmk` to be installed (TeX Live and MiKTeX include it).


## Usage


Download the script to your user `bin` folder:

   ```sh
   curl -fsSL https://raw.githubusercontent.com/toftul/tex-to-pdf/main/tex-to-pdf.sh -o ~/.local/bin/tex-to-pdf
   chmod +x ~/.local/bin/tex-to-pdf
   ```

2. Make sure that `~/.local/bin` is in your `PATH`.
3. In the folder with your `.tex` files, run:

   ```sh
   tex-to-pdf
   ```
   If you want to keep `.bbl` files:
   ```sh
   tex-to-pdf --keep-bbl
   ```
   To compile only some files, give their names:
   ```sh
   tex-to-pdf main.tex
   tex-to-pdf main.tex supplement.tex
   tex-to-pdf paper/main.tex
   ```

## How it works

Without file names, the script compiles only the files in the current folder that contain `\documentclass`. With file names, it compiles only these files, in the folder of each file.  If a compilation fails, the script keeps the log file and shows the first errors. The exit code is 1.

## License

MIT
