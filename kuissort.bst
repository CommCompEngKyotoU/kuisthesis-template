% ipsjsort.bst nakasima@kuis.kyoto-u.ac.jp (Hiroshi Nakashima)
% jssst.bst tomura@etl.go.jp (Satoru Tomura)
% BibTeX standard bibliography style `jplain'
	% version 0.10 for JBibTeX versions 0.10 or later, JLaTeX version 2.09.
	% by Shouichi Matsui, matsui@denken.junet

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    volume
    year
    yomi
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block }

INTEGERS { before.year }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  #4 'before.year :=	% year doesn't follows "," nor ".". (H.N.)
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
	{ add.period$ write$
	  newline$
	  "\newblock " write$
	}
	{ output.state before.all =
	    'write$
	    { output.state before.year =
% year doesn't follows "," nor ".". (H.N.)
		{ " " * write$ }
		{ add.period$ " " * write$ }
	      if$
	    }
	  if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {required.argument}
{ 't :=
  empty$
    {"Missing required argument " t * " in " * cite$ * warning$}
    'skip$
  if$
}

FUNCTION {required.exclusive.or.argument}
{ 't :=
  empty$
    { 's := 
      empty$
        { t " or " * s * " is missing in " * cite$ * warning$}
        'skip$
      if$
    }
    { 's :=
      empty$
        'skip$
        { "You can use only one of " t * " and " * s * " in " * cite$ * warning$}
      if$
    }
  if$
}

FUNCTION {required.and.or.argument}
{ 't := empty$
     { 's := empty$
         { "there's no " t * " and/or " * s * cite$ * warning$ }
         'skip$
       if$
     }
     { pop$ pop$ }
  if$
}

FUNCTION {optional.series.volume.number.argument}
{ series empty$
    { volume empty$
        { number empty$
            'skip$
            { "there's a number but no series in " cite$ * warning$ }
          if$
        }
        { number empty$
            { "there's a volume but no series in " cite$ * warning$ }
            { "you can use only one of volume and number in " cite$ * warning$}
          if$
        }
     if$
    }
    { volume empty$
        { number empty$
            { "there's a series but neither volume nor number in " cite$ * warning$ }
            'skip$
          if$
        }
        { number empty$
            'skip$
            { "you can use only one of volume and number in " cite$ * warning$ }
          if$
        }
     if$
   }
   if$
}            

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
	'skip$
	{ after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {is.kanji}
%%%{ #1 text.prefix$ chr.to.int$ #127 > }
%%%{ #1 #1 substring$ chr.to.int$ #127 > }
%%%{ purify$ #1 text.prefix$ chr.to.int$ #127 >}
{ is.kanji.str$ }

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { duplicate$ is.kanji
        'skip$
        { "{\em " swap$ * "\/}" * }
      if$
    }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
        s nameptr "{ll}" format.name$ is.kanji
           { "{ff}{vv}{ll}" }
           { "{vv }{ll}{, jj}{, f.}" }
        if$
      format.name$ 't :=
      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    {
%	      numnames #2 >
%		{ "," * }
%		'skip$
%	      if$
% Don't put "," before "and" (H.N.)
%
%	      numnames #3 <
%		{ t is.kanji
%		    {"," * "" *} 'skip$ if$
%		}
%		'skip$
%    	      if$
% Don't put "," before "ほか" (H.N.)
%
	      t "others" =
		{ s is.kanji
			{"ほか" * }
			{" et al." * }
		      if$
                }
		{ s is.kanji
%			{" " * t * }
			{", " * t * }	% put "," here for Kanji (H.N.)
			{" and " * t * }
	     	      if$
		}
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor format.names
      editor num.names$ #1 >
	{ editor is.kanji
		{"(編)" * } %%{", editors" * } if$
                            {"(eds.)" *} if$
	}
	{ editor is.kanji
		{"(編)" *}  %%{", editor" * } if$
                            {"(ed.)" *} if$
	}
      if$
    }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {format.date}
{ before.year 'output.state :=	% year doesn't follows "," nor ".". (H.N.)
  year empty$
    { month empty$
	{ "" }
	{ "there's a month but no year in " cite$ * warning$
%	  month			% no worth to put month only. (H.N.)
          ""
	}
      if$
    }
%   { month empty$
%	'year
%	{ month " " * year * }
%     if$
%   }
% month is not printed even if it is given. (H.N.)
%
    { "(" year ")" * * }	% year is surrounded by parens. (H.N.)
  if$
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { "\ " }
  if$
  swap$ * *
}

FUNCTION {output.volume}
{ 
  volume empty$
    'skip$
    { "Vol.~" volume * output}
  if$

}

FUNCTION {output.number}
{
  number empty$
    'skip$
    { "No.~" number * output}
  if$
}

FUNCTION {is.kanji.or.empty}
{ duplicate$
  empty$
    { pop$ #1}
    { is.kanji }
  if$
}

FUNCTION {output.series.volume.number}
{ series empty$
    { output.volume
      output.number }
    { series is.kanji
      volume is.kanji.or.empty
      number is.kanji.or.empty
      and and
        { series volume field.or.null * number field.or.null * output}
        { series output
          output.volume
          output.number}
      if$
   }
 if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
	{ edition "l" change.case$ " edition" * }
	{ edition "t" change.case$ " edition" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
%	{ "pp.~" pages n.dashify tie.or.space.connect }
%	{ "pp.~" pages tie.or.space.connect }
% '~' might be add by tie.or.space.connect. (H.N.)
% "p." is probably better for single page reference (H.N.)
	{ "pp." pages n.dashify tie.or.space.connect }
	{ "p." pages tie.or.space.connect }
      if$
    }
  if$
}

% This function is replaced by format.vol.num.pages (H.N.)
%FUNCTION {format.volume.number.year.pages}
%{ volume empty$
%    { number empty$
%        { year empty$
%             { "" }
%             { "(" year * ")" * }
%          if$}
%        { year empty$
%             { "No.~" number * }
%             { "No.~" number * "(" * year * ")" * }
%         if$}
%      if$}
%    { number empty$
%        { year empty$
%             { "Vol.~" volume * }
%             { "Vol.~" volume * "(" * year * ")" * }
%          if$}
%        { year empty$
%             {"Vol.~" volume * "," * "No.~" * number * }
%             {"Vol.~" volume * "," * "No.~" * number * "(" * year * ")" * }
%         if$}
%      if$}
%   if$
%  pages empty$
%    'skip$
%    { duplicate$ empty$
%	{ pop$ format.pages }
%	{ "," * " pp.~" * pages n.dashify * }
%      if$
%    }
%  if$
%}

FUNCTION {format.vol.num.pages}
{ volume empty$
  { ""}
  { " Vol.~" volume * }
  if$ 
  number empty$
    'skip$
    { volume empty$
	{ "there's a number but no volume in " cite$ * warning$ }
	{ "," *}
      if$
      " No.~" number * *
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
	{ pop$ format.pages }
	{ ", " * format.pages * }
% tieing "pp." and the first page will be too hard for a narrow column. (H.N.)
      if$
    }
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ "chapter" chapter tie.or.space.connect }
        { type is.kanji 
             { chapter type tie.or.space.connect }
             { type "l" change.case$ chapter tie.or.space.connect }
          if$
        }
      if$
      pages empty$
	'skip$
	{ ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
	{ booktitle is.kanji
	    { " " booktitle emphasize * }
	    { " " booktitle emphasize * }
	  if$
	}
	{ booktitle is.kanji
%	    { booktitle emphasize "(" * format.editors * ")" *}
%	    { booktitle emphasize "(" * format.editors * ")" *}
% awful without leading space (H.N.)
	    { booktitle emphasize " (" * format.editors * ")" *}
	    { booktitle emphasize " (" * format.editors * ")" *}
	  if$
	}
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { title empty$
        { "Technical Report" }
        { title is.kanji
            { "技術報告" }
            { "Technical Report" }
          if$
        }
      if$
    }
    {type}
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
	{ "In " journal emphasize * }
      if$
    }
    { "In " key * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.crossref.editor}
{ editor #1 "{vv }{ll}" format.name$
  editor num.names$ duplicate$
  #2 >
    { editor is.kanji
	  {pop$ " ほか" *} {pop$ " et al." * } if$
    }
    { #2 <
	'skip$
	{ editor #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
	    { editor is.kanji
		{" ほか" *} {"et al." * } if$
	    }
	    { editor is.kanji
		{" " * editor #2 "{vv }{ll}" format.name$ * }
		{" and " * editor #2 "{vv }{ll}" format.name$ * }
	      if$
	    }
	  if$
	}
      if$
    }
  if$
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      title is.kanji
	{"  "} {"In "} if$
    }
    { "Volume" volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }
	    { series emphasize }
	  if$
	}
	{ key * }
      if$
    }
    { format.crossref.editor * }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ booktitle empty$
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
	    { booktitle is.kanji
		booktitle
		{"In " booktitle emphasize * }
	       if$
	    }
	  if$
	}
	{ "In " key * }
      if$
    }
    { title is.kanji
	{" " format.crossref.editor * }
	{"In " format.crossref.editor * }
      if$
    }
  if$
  " \cite{" * crossref * "}" *
}

FUNCTION {article}
{ 
%%%%
  author  "author"  required.argument
  title   "title"   required.argument
  journal "journal" required.argument
  year    "year"    required.argument
%%%% jssst
  volume  "volume"  
  number  "number"  
     required.and.or.argument
  pages   "pages"   required.argument
%%%%
  output.bibitem 
  format.authors ": " *
  title output
  crossref missing$
    { journal emphasize output
%     format.volume.number.year.pages output
% date is always at the end. (H.N.)
      format.vol.num.pages output
      format.date output
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {book}
{ 
%%%%
  author  "author"
  editor  "editor"
    required.exclusive.or.argument
  title   "title"  required.argument
  publisher "publisher" required.argument
  year    "year" required.argument
  optional.series.volume.number.argument
%%%%
  output.bibitem
  author empty$
    { format.editors}
    { format.authors}
  if$
  ": " *
  title emphasize output
  crossref missing$
    { output.series.volume.number
      publisher output
      address output
    }
    { new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {booklet}
{
%%%%
  title   "title"   required.argument
%%%% jssst
  author  "author"  required.argument
%%%%
  output.bibitem
  format.authors  ": " *
  title output
  howpublished output
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ 
%%%%
  author  "author"
  editor  "editor"
     required.exclusive.or.argument
  title   "title"  required.argument
  chapter "chapter"
  pages   "pages"
     required.and.or.argument
  publisher  "publisher" required.argument
  year       "year"      required.argument

  optional.series.volume.number.argument
%%%%
  output.bibitem 
  author empty$
    { format.editors}
    { format.authors}
  if$
  ": " *
  title emphasize output
  crossref missing$
    { output.series.volume.number
      publisher output
    }
    { format.chapter.pages output
      new.block
      format.book.crossref output.nonnull
    }
  if$
  format.edition output
% format.date output
  format.chapter.pages output
  format.date output		% date is always at the end. (H.N.)
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{
%%%%
  author    "author"    required.argument
  title     "title"     required.argument
  booktitle "booktitle" required.argument
  publisher "publisher" required.argument
  year      "year"      required.argument

  optional.series.volume.number.argument
%%%%
  output.bibitem
  format.authors ": " *
  title output
  crossref missing$
    { format.in.ed.booktitle output
      output.series.volume.number
      publisher output
      address output
      format.edition output
      format.chapter.pages output	% date is always at the end. (H.N.)
      format.date output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
% format.chapter.pages output
  new.block
  note output
  fin.entry
}

FUNCTION {inproceedings}
{
%%%%
  author    "author"    required.argument
  title     "title"     required.argument
  booktitle "booktitle" required.argument
  year      "year"      required.argument

  optional.series.volume.number.argument
%%%%
  output.bibitem 
  format.authors ": " *
  title output
  crossref missing$
    { format.in.ed.booktitle output
      output.series.volume.number
      address output
      organization output
      publisher output
%     format.date output
      format.pages output
      format.date output	% date is always at the end. (H.N.)
    }
    { format.incoll.inproc.crossref output.nonnull
      format.pages output
    }
  if$
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{	
%%%%
  title   "title"    required.argument
%%%% jssst
  author   "author"
  organization "organazaion"
     required.exclusive.or.argument
%%%%
  output.bibitem
  author empty$
    { organization}
    { format.authors}
  if$
  ": " *
  title emphasize output
  author empty$
    'skip$
    { organization output }
  if$
  address output
  format.edition output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{
%%%%
  author   "author"  required.argument
  title    "title"   required.argument
  school   "school"  required.argument
  year     "year"    required.argument
%%%%
  output.bibitem
  format.authors ": " *
  title output
  author empty$
    { "Master's thesis" }
    { author is.kanji
        { "修士論文" }  
        { "Master's thesis" }
      if$
    }
  if$
  format.thesis.type output.nonnull
  school output
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {misc}
{
%%%%
%%%% jssst
  author "author" required.argument
  title  "title"  required.argument
%%%%
  output.bibitem
  format.authors 
  ": " *
  title output
  howpublished output
  format.date output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {phdthesis}
{
%%%%
  author   "author"  required.argument
  title    "title"   required.argument
  school   "school"  required.argument
  year     "year"    required.argument
%%%%
  output.bibitem 
  format.authors ": " *
  title emphasize output
  author empty$
    { "PhD Thesis" }
    { author is.kanji
        { "博士論文" }
        { "PhD Thesis" }
      if$
    }
  if$
  format.thesis.type output.nonnull
  school output
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{
%%%%
  title  "title"  required.argument
  year   "year"   required.argument

  optional.series.volume.number.argument
%%%% jssst
  editor  "editor"
  organization "organization"
      required.exclusive.or.argument 
%%%%
  output.bibitem 
  editor empty$
    { organization }
    { format.editors }
  if$
  ": " *
  title emphasize output
  output.series.volume.number
  address output
  editor empty$
    'skip$
    { organization output }
  if$
  publisher output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {techreport}
{
%%%%
  author   "author"   required.argument
  title    "title"    required.argument
  institution "institution" required.argument
  year     "year"     required.argument
%%%%
  output.bibitem
  format.authors  ": " *
  title output
  format.tr.number output.nonnull
  institution output
  address output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {unpublished}
{
%%%%
  author   "author"   required.argument
  title    "title"    required.argument
  note     "note"     required.argument
%%%%
  output.bibitem
  format.authors ": " *
  title output
  format.date output
  new.block
  note output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {sort.format.names}
{ 's :=
  yomi empty$
     'skip$
     { yomi 's := }
  if$

  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
	{ "   " * }
	'skip$
      if$
      s nameptr "{vv{ } }{ll{ }}{  ff{ }}{  jj{ }}" format.name$ 't :=
      nameptr numnames = t "others" = and
	{ "et al" * }
	{ t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
	{ "to sort, need author or key in " cite$ * warning$
	  ""
	}
	{ key sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.editor.sort}
{ author empty$
    { editor empty$
	{ key empty$
	    { "to sort, need author, editor, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ editor sort.format.names }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {author.organization.sort}
{ author empty$
    { organization empty$
	{ key empty$
	    { "to sort, need author, organization, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ "The " #4 organization chop.word sortify }
      if$
    }
    { author sort.format.names }
  if$
}

FUNCTION {editor.organization.sort}
{ editor empty$
    { organization empty$
	{ key empty$
	    { "to sort, need editor, organization, or key in " cite$ * warning$
	      ""
	    }
	    { key sortify }
	  if$
	}
	{ "The " #4 organization chop.word sortify }
      if$
    }
    { editor sort.format.names }
  if$
}

FUNCTION {presort}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.sort
    { type$ "proceedings" =
	'editor.organization.sort
	{ type$ "manual" =
	    'author.organization.sort
	    'author.sort
	  if$
	}
      if$
    }
  if$
  "    "
  *
  year field.or.null sortify
  *
  "    "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}


