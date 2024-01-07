# Changelog

<a name="0.11.0"></a>
## [0.11.0] (2024-01-07)
### Added
- New target `pretty` to run code prettifiers on the source files in
  the current directory.
  Currently, only
  [`latexindent`](https://www.ctan.org/pkg/latexindent)
  has built-in support.
  By default, `make pretty` runs
  `latexindent -l -wd -s` for each `.tex` file.
  Target files of the prettifier can be configurable by setting
  `LATEXINDENT_TARGET`, for example,
  `LATEXINDENT_TARGET = *.tex *.sty`.
  Note that probably the user wants to customize `latexindent`
  local settings (in `localSettings.yaml` or `latexindent.yaml`),
  like `defaultIndent` and `onlyOneBackUp`.
  ([#22](https://github.com/tueda/makefile4latex/issues/22))
- Configurable target files for linters, by `CHKTEX_TARGET` etc.
  ([20f7bc9](https://github.com/tueda/makefile4latex/commit/20f7bc928c9ab67e2b73f7ce880752f9ff3a7f3f))
### Changed
- Updated `.gitignore`, which is now based on
  [`TeX.gitignore` (2021-12-11)](https://github.com/github/gitignore/blob/362abacebe59448407e47a014e09288d8cddb7a7/TeX.gitignore).
  ([a3e4eae](https://github.com/tueda/makefile4latex/commit/a3e4eae2e2528745a97ee141d6ba3afc4b33988f))


<a name="0.10.0"></a>
## [0.10.0] (2023-07-23)
### Added
- Colorize `dvipdfmx` warnings ([#42](https://github.com/tueda/makefile4latex/issues/42)).


<a name="0.9.1"></a>
## [0.9.1] (2022-09-23)
### Fixed
- Removed a superfluous message printed when `POSTPROCESS` is not given
  ([#39](https://github.com/tueda/makefile4latex/issues/39)).


<a name="0.9.0"></a>
## [0.9.0] (2022-04-22)
### Added
- `POSTPROCESS` to specify post-processing targets
  ([#38](https://github.com/tueda/makefile4latex/issues/38)).
- The following variables are now officially public
  ([2cffd85](https://github.com/tueda/makefile4latex/commit/2cffd85ca486d5ac954fefa55f6df5499d5f3623)):
  - `MOSTLYCLEANFILES`
  - `CLEANFILES`
  - `PREREQUISITE`
  - `PREREQUISITE_SUBDIRS`
  - `POSTPROCESS`


<a name="0.8.0"></a>
## [0.8.0] (2021-08-09)
### Added
- `MAKEFILE4LATEX_WAIT_COMMAND` (default: `sleep 1`) to change the command to
  wait some time in `make watch`
  ([#30](https://github.com/tueda/makefile4latex/issues/30)).


<a name="0.7.0"></a>
## [0.7.0] (2021-05-26)
### Added
- Placing `*-eps-converted-to.pdf` files generated during `pdflatex` into
  `BUILDDIR` (for TeX Live)
  ([#29](https://github.com/tueda/makefile4latex/issues/29)).
  This behaviour can be controlled by `USE_BUILDDIR_FOR_EPSTOPDF`
  (= `always`, `never` or `auto`).
  The default value `auto` indicates that the feature is enabled for TeX Live.


<a name="0.6.0"></a>
## [0.6.0] (2021-04-20)
### Added
- Built-in support for [Hunspell](https://hunspell.github.io/)
  ([#26](https://github.com/tueda/makefile4latex/issues/26)).
  Enabled by adding `hunspell` to `LINTS`.


<a name="0.5.2"></a>
## [0.5.2] (2021-04-20)
### Fixed
- `make LINTS=aspell lint` uses the GNU grep's `-w` option if available
  ([#27](https://github.com/tueda/makefile4latex/issues/27)).


<a name="0.5.1"></a>
## [0.5.1] (2021-04-20)
### Fixed
- `make lint` should fail if GNU Aspell is needed but missing
  ([#25](https://github.com/tueda/makefile4latex/issues/25)).


<a name="0.5.0"></a>
## [0.5.0] (2020-12-06)
### Added
- The `lint` target, which runs linters for LaTeX source files, is now
  officially available
  ([#15](https://github.com/tueda/makefile4latex/issues/15)).
  [ChkTeX](https://www.ctan.org/pkg/chktex) (`chktex`),
  [GNU Aspell](http://aspell.net/) (`aspell`),
  [textlint](https://textlint.github.io/) (`textlint`)
  and [RedPen](https://redpen.cc/) (`redpen`) have built-in support.
  One can specify the linters by the `LINTS` variable.
  The default value is `LINTS = chktex`.
- The `COLOR` variable controls colors in the output
  ([5f83a9f](https://github.com/tueda/makefile4latex/commit/5f83a9f784f21ce86a1d7966933d52091e56700a)):
  - always
  - never
  - auto (default)


<a name="0.4.1"></a>
## [0.4.1] (2020-11-23)
### Fixed
- Fix a regression in dependency tracking
  ([#20](https://github.com/tueda/makefile4latex/issues/20)).
### Changed
- `get/Makefile` now also refers to configuration files in the directory
  containing the Makefile after resolving symbolic links for
  `MAKEFILE4LATEX_REVISION` and `MAKEFILE4LATEX_CACHE`
  ([2575449](https://github.com/tueda/makefile4latex/commit/2575449d00af9c6920082e3353ef2eb79aca2718)).


<a name="0.4.0"></a>
## [0.4.0] (2020-11-21)
### Added
- Basic BibLaTeX support
  ([#11](https://github.com/tueda/makefile4latex/issues/11)).
  There are following limitations in the `DIFF` mode:
  - The `DIFF` mode with `biber` requires `latexpand` 1.6 or later (`--biber` option).
  - The `DIFF` mode with `biber` may not work with a hidden `BUILDDIR` (e.g., `.build`).
  - The `DIFF` mode does not work with the BibTeX backend.
- Partial `bib2gls` support
  ([#12](https://github.com/tueda/makefile4latex/issues/12)).
  There are following limitations:
  - Dependency tracking on .bib files that are processed by `bib2gls` does not work.
  - The `DIFF` mode does not work with `bib2gls`.


<a name="0.3.6"></a>
## [0.3.6] (2020-11-07)
### Fixed
- Fix a BibTeX issue in the `DIFF` mode with `BUILDDIR`
  ([#19](https://github.com/tueda/makefile4latex/issues/19)).


<a name="0.3.5"></a>
## [0.3.5] (2020-10-23)
### Fixed
- The target document file should be always updated even when LaTeX doesn't
  run, otherwise an unnecessary run occurs in the next time
  ([00207ed](https://github.com/tueda/makefile4latex/commit/00207ed199ef1bb8b179fdfb71d6464167b49715)).
- Move `.ilg` files to `BUILDDIR` when it is defined
  ([a0c2720](https://github.com/tueda/makefile4latex/commit/a0c2720143c7407a4e2769219f3315ec5ac1fcc8)).


<a name="0.3.4"></a>
## [0.3.4] (2020-10-17)
### Fixed
- Resolve problems of BibTeX/Makeindex with `BUILDDIR`
  ([#16](https://github.com/tueda/makefile4latex/issues/16), [#18](https://github.com/tueda/makefile4latex/issues/18)).
### Changed
- BibTeX error message `I couldn't open file name ...` is now colorized
  ([45d9344](https://github.com/tueda/makefile4latex/commit/45d9344a05ad93c77d65b86aed32d85273105e09)).


<a name="0.3.3"></a>
## [0.3.3] (2020-10-03)
### Fixed
- Avoid changing versioned Makefiles in `make upgrade`
  ([#17](https://github.com/tueda/makefile4latex/issues/17)).


<a name="0.3.2"></a>
## [0.3.2] (2020-09-27)
### Changed
- Print the version in `make help`
  ([a8ef0f9](https://github.com/tueda/makefile4latex/commit/a8ef0f952006f864123c8add459b559680dcbee4)).


<a name="0.3.1"></a>
## [0.3.1] (2020-09-23)
### Changed
- Improve the messages during `make watch`
  ([3e3dcd3](https://github.com/tueda/makefile4latex/commit/3e3dcd302ac745c86704da4f950f06830a4ace2a)).


<a name="0.3.0"></a>
## [0.3.0] (2020-09-15)
### Added
- When the `BUILDDIR` variable is defined on the command line or in the user
  configuration files, LaTeX intermediate files are put into `BUILDDIR`.
  This is implemented by using the `-output-directory` option available in
  TeX Live
  ([#13](https://github.com/tueda/makefile4latex/issues/13)).


<a name="0.2.0"></a>
## [0.2.0] (2020-09-12)
### Added
- `make clean` now deletes directories named `.cache`, `_cache` and `cache`,
  which are considered as cache directories
  ([fe2dd15](https://github.com/tueda/makefile4latex/commit/fe2dd1578379a5c0cda8513438c92c63b56c04fd)).


<a name="0.1.0"></a>
## [0.1.0] (2020-09-05)
- We have added `get/Makefile` for on-demand downloading and introduced
  `MAKEFILE4LATEX_REVISION` to specify the revision.
  Now it is time for us to make the first release so that this tag can be used
  for specifying the revision to be downloaded, for example, in `latex.mk`:
  ```make
  MAKEFILE4LATEX_REVISION = v0.1.0
  ```


[0.11.0]: https://github.com/tueda/makefile4latex/compare/v0.10.0...v0.11.0
[0.10.0]: https://github.com/tueda/makefile4latex/compare/v0.9.1...v0.10.0
[0.9.1]: https://github.com/tueda/makefile4latex/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/tueda/makefile4latex/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/tueda/makefile4latex/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/tueda/makefile4latex/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/tueda/makefile4latex/compare/v0.5.2...v0.6.0
[0.5.2]: https://github.com/tueda/makefile4latex/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/tueda/makefile4latex/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/tueda/makefile4latex/compare/v0.4.1...v0.5.0
[0.4.1]: https://github.com/tueda/makefile4latex/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/tueda/makefile4latex/compare/v0.3.6...v0.4.0
[0.3.6]: https://github.com/tueda/makefile4latex/compare/v0.3.5...v0.3.6
[0.3.5]: https://github.com/tueda/makefile4latex/compare/v0.3.4...v0.3.5
[0.3.4]: https://github.com/tueda/makefile4latex/compare/v0.3.3...v0.3.4
[0.3.3]: https://github.com/tueda/makefile4latex/compare/v0.3.2...v0.3.3
[0.3.2]: https://github.com/tueda/makefile4latex/compare/v0.3.1...v0.3.2
[0.3.1]: https://github.com/tueda/makefile4latex/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/tueda/makefile4latex/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/tueda/makefile4latex/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/tueda/makefile4latex/tree/v0.1.0
