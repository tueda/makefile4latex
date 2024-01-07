Makefile for LaTeX
==================

[![GitHub Actions Status](https://github.com/tueda/makefile4latex/workflows/Test/badge.svg?branch=master)](https://github.com/tueda/makefile4latex/actions?query=branch:master)
[![AppVeyor Status](https://ci.appveyor.com/api/projects/status/fy41hbf7eijhyvx3/branch/master?svg=true)](https://ci.appveyor.com/project/tueda/makefile4latex)

This is a GNU Makefile for typesetting LaTeX2e documents. Expected to work with
[TeX Live](https://www.tug.org/texlive/) on Linux and similar systems, e.g., on
macOS or Cygwin. Just download a single `Makefile` and put it in your directory
containing LaTeX source files. Running `make` will generate PDF files for your
documents.


Features
--------

- Only a single file ([`Makefile`](https://github.com/tueda/makefile4latex/blob/master/Makefile))
  distributed under the MIT License. Just put it into your directory.
- Automatic detection of LaTeX source files. Just type `make` and then
  the Makefile knows what to do.
- Dependency tracking.
- Handling [BibTeX](https://ctan.org/pkg/bibtex),
  [MakeIndex](https://ctan.org/pkg/makeindex),
  [glossaries](https://ctan.org/pkg/glossaries) and
  [axodraw2](https://ctan.org/pkg/axodraw2).
- Partial support for [biber](https://www.ctan.org/pkg/biber),
  [bib2gls](https://www.ctan.org/pkg/bib2gls) and
  [sortref](https://web.physik.rwth-aachen.de/user/harlander/software/index.php).
- Colorized output.
- Highly customizable by optional user configuration files (`latex.mk` files).
- Placing intermediate files into a directory (`BUILDDIR` variable).
- [Latexdiff](https://www.ctan.org/pkg/latexdiff) between Git revisions (`DIFF` variable).
- Running code prettifiers (`make pretty`).
  [latexindent](https://www.ctan.org/pkg/latexindent) has built-in support.
- Linting (`make lint`).
  [ChkTeX](https://www.ctan.org/pkg/chktex),
  [GNU Aspell](http://aspell.net/),
  [Hunspell](https://hunspell.github.io/),
  [textlint](https://textlint.github.io/) and
  [RedPen](https://redpen.cc/) have built-in support.
- Creating tar-gzipped source files for [arXiv](https://arxiv.org/)
  submission (`make dist`).
- Watching source files to automatically typeset documents when they are modified (`make watch`).


Getting started
---------------

Download `Makefile` via
[this link](https://raw.githubusercontent.com/tueda/makefile4latex/v0.11.0/Makefile)
in your browser or by using `curl`:
```shell
curl -O https://raw.githubusercontent.com/tueda/makefile4latex/v0.11.0/Makefile
```
and put it into a directory that contains LaTeX files. Then just type:
```shell
make
```

See also the [Wiki page](https://github.com/tueda/makefile4latex/wiki) for
other ways to start.


Targets
-------

- `all` (default):
  Build all documents in the current directory.
- `all-recursive`:
  Build all documents in the source tree.
- `dvi`, `ps`, `pdf`, `eps`, `svg`, `jpg`, `png`:
  Build all documents with the specified file format in the current directory.
- `help`:
  Show help message.
- `clean`:
  Delete all files created by running `make`.
- `mostlyclean`:
  Delete only intermediate files created by running `make`.
- `pretty`:
  Run code prettifiers for source files in the current directory.
- `lint`:
  Run linters for source files in the current directory.
- `dist`:
  Create tar-gzipped archives for [arXiv](https://arxiv.org/) submission.
- `watch`:
  Watch the changes and automatically rebuild documents in the current
  directory.
- `upgrade`:
  Upgrade the setup. For a Git repository, if there is no `.gitignore` file, it
  installs the default [`.gitignore`](https://github.com/tueda/makefile4latex/blob/master/.gitignore).
  (Be careful not to overwrite any local changes!)

It is also possible to make each target file. For example, `make foo.pdf` tries
to generate the pdf file from `foo.tex`.


Variables
---------

- `TOOLCHAIN`:
  Control how PDF files are generated from LaTeX files.
  Given on the command line or in the user configuration files.
    - `latex`:
      Alias to `latex_dvips`.
    - `latex_dvips`:
      Use `latex` --> `dvips` --> `ps2pdf`.
    - `latex_dvipdf`:
      Use `latex` --> `dvipdf`.
    - `platex`:
      Alias to `platex_dvips`.
    - `platex_dvips`:
      Use `platex` --> `dvips` --> `ps2pdf`.
    - `platex_dvipdfmx`:
      Use `platex` --> `dvipdfmx`.
    - `uplatex`:
      Alias to `uplatex_dvips`.
    - `uplatex_dvips`:
      Use `uplatex` --> `dvips` --> `ps2pdf`.
    - `uplatex_dvipdfmx`:
      Use `uplatex` --> `dvipdfmx`.
    - `pdflatex` (default):
      Use `pdflatex`.
    - `xelatex`:
      Use `xelatex`.
    - `lualatex`:
      Use `lualatex`.
    - `luajitlatex`:
      Use `luajitlatex`.

- `BUILDDIR`:
  Place intermediate files into `BUILDDIR`.
  Given on the command line or in the user configuration files.
  It is assumed that the `-output-directory=DIR` option is available in the
  LaTeX distribution you are using (which is true in TeX Live.)
  Note that some (La)TeX packages may not follow this option and may generate
  some files in the working directory, or may not correctly work in the worst
  case.

- `DIFF`:
  Enable the Git-latexdiff mode. Given on the command line only.
  Requires `latexdiff` and `latexpand`.
  The `DIFF` variable specifies a Git revision for which
  a latexdiff with the working tree is performed, e.g., `make DIFF=HEAD^`.
  The resultant document has a postfix `-diff` like `foo-diff.pdf`.
  It is also possible to make a latexdiff between two revisions, e.g.,
  `make DIFF=HEAD~3..HEAD` provided both revisions contain the source file.

- `COLOR`:
  Control how colors are used in the output.
  Given on the command line or in the user configuration files.
    - `always`:
      Use colors.
    - `never`:
      Do not use colors.
    - `auto` (default):
      Use colors unless the output is piped.

- `PRETTIFIERS`:
  List prettifiers to be used by `make pretty`.
  Given on the command line or in the user configuration files.
  The default value is `PRETTIFIERS = latexindent`, so it runs
  [latexindent](https://www.ctan.org/pkg/latexindent).

- `LINTS`:
  List linters to be used by `make lint`.
  Given on the command line or in the user configuration files.
  The default value is `LINTS = chktex`, so it runs
  [ChkTeX](https://www.ctan.org/pkg/chktex).
  One can add or overwrite the list, for example,
  `LINTS += aspell` or `LINTS = hunspell textlint redpen`.

- `NODISTFILES`, `EXTRADISTFILES`, `ANCILLARYFILES`:
  Control which files are included in tar-gzipped source files.
  Given on the command line or in the user configuration files.
  A tar-gzipped source file, `foo.tar.gz` for example, is created from the
  corresponding source file, `foo.tex`, and the dependent files.
  One can set `NODISTFILES` to exclude some of the dependent files from the
  resultant file.
  On the other hand, `EXTRADISTFILES` represents additional files to be
  included.
  The [`00README.XXX` file](https://arxiv.org/help/00README) is also examined to
  determine additionally included files.
  Moreover, files listed in `ANCILLARYFILES` are copied to
  the [`anc` directory](https://arxiv.org/help/ancillary_files) inside
  the resultant file.

- `MOSTLYCLEANFILES`, `CLEANFILES`:
  Specify files to be deleted for `make mostlyclean` and `make clean`, respectively.
  Given on the command line or in the user configuration files.

- `PREREQUISITE`, `PREREQUISITE_SUBDIRS`, `POSTPROCESS`:
  Specify prerequisite and postprocessing tasks for documents
  in the current directory.
  Given on the command line or in the user configuration files.
  `PREREQUISITE` is a list of targets to be built before building
  documents in the current directory.
  `PREREQUISITE_SUBDIRS` is a list of targets in all the *subdirectories*
  required to build documents in the current directory.
  `POSTPROCESS` is a list of targets to be built after the completion of
  the building documents in the current directory.


Customization
-------------

The Makefile includes `latex.mk` (as well as `.latex.mk`) at the very end if
exists. This file can be put in the user's home directory and/or the current
working directory.  It can be used for customizing the behaviour of the
Makefile, for example, by setting `TOOLCHAIN`. For example, if you want to use
the `latex` -> `dvips` -> `ps2pdf` toolchain instead of the default one
`pdflatex`, then run the following command:
```shell
echo 'TOOLCHAIN = latex_dvips' >>latex.mk
```
See also the [Wiki page](https://github.com/tueda/makefile4latex/wiki) for
more customizations.
