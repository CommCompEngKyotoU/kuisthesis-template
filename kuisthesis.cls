% kuisthesis.cls  1-Apr-96 by Hiroshi Nakashima (ver 2.00)
% ver 3.00 13-Dec-2025: Added LuaLaTeX support

\ifx\directlua\undefined
  % pLaTeX or upLaTeX or standard LaTeX
  \ifx\pfmtname\undefined
    \NeedsTeXFormat{LaTeX2e}
  \else
    \NeedsTeXFormat{pLaTeX2e}
  \fi
\else
  % LuaLaTeX
  \NeedsTeXFormat{LaTeX2e}
\fi

\ProvidesClass{kuisthesis}[2025/12/13 ver 3.00 with LuaLaTeX support]
\input{kuisthesis.sty}
\endinput
