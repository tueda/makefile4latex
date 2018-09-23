Makefile for LaTeX
==================

[![Travis CI Build Status](https://travis-ci.org/tueda/makefile4latex.svg?branch=master)](https://travis-ci.org/tueda/makefile4latex)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/fy41hbf7eijhyvx3/branch/master?svg=true)](https://ci.appveyor.com/project/tueda/makefile4latex)

This is a GNU Makefile for typesetting LaTeX documents. Expected to work with
[TeXLive](https://www.tug.org/texlive/) on Linux and similar systems, e.g., on
macOS or Cygwin. Just download a single `Makefile` and put it in your directory
containing LaTeX source files. Running `make` will generate PDF files for your
documents.

Features
--------

- Only a single file (`Makefile`).
- Automatic detection of LaTeX source files.
- Dependency tracking.
- Handling BibTeX, makeindex, makeglossaries, axohelp etc.
- Colorized output.
- Can watch sources and automatically typeset documents (`make watch`).

Getting started
---------------

Download `Makefile` by using `wget`:
```shell
wget https://raw.githubusercontent.com/tueda/makefile4latex/master/Makefile
```
or `curl`:
```shell
curl -O https://raw.githubusercontent.com/tueda/makefile4latex/master/Makefile
```
or via [this link](https://raw.githubusercontent.com/tueda/makefile4latex/master/Makefile) in your browser.
Put it into a directory that contains LaTeX files. Then just type:
```shell
make
```

Targets
-------

- `all` (default):
  Create all possible documents.
- `help`:
  Show help message.
- `clean`:
  Delete all files created by running `make`.
- `mostlyclean`:
  Delete only intermediate files created by running `make`.
- `dist`:
  Create tar-gzipped archives for [arXiv](https://arxiv.org/) submission.
- `watch`:
  Watch the changes and automatically recreate documents.
- `upgrade`:
  Upgrade the setup. (Be careful not to overwrite any local changes!)

Variables
---------

- `TOOLCHAIN`:
  Control how PDF files are generated from LaTeX files.
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

Customization
-------------

The Makefile includes `.latex.mk` at the very end if exists. This file can be
put in the user's home directory and/or the current working directory.
It can be used for customizing the behaviour of the Makefile, for example,
by setting `TOOLCHAIN`.
