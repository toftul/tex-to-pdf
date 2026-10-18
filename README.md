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

## How it works

The script compiles only the files that contain `\documentclass`.  If a compilation fails, the script keeps the log file and shows the first errors. The exit code is 1.

## License

MIT
