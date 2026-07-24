# kuisthesis-template

## Supported Engines

- upLaTeX (with dvipdfmx)
- LuaLaTeX
- pdfLaTeX

The bundled bibliography styles are selected automatically. Keep using
`\bibliographystyle{kuissort}` or `\bibliographystyle{kuisunsrt}` with every
engine. LuaLaTeX and pdfLaTeX use the standard-BibTeX-compatible `-bibtex`
variants, while (u)pLaTeX continues to use the original (u)pBibTeX styles.

### Note for pdfLaTeX users

Use `~` (tilde) between Japanese and English text to insert proper spacing:
```latex
日本語~\LaTeX~を使う
```
For upLaTeX and LuaLaTeX, tildes work as usual (non-breaking space), since spacing is inserted automatically.
