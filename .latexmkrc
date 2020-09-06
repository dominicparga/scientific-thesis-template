#------------------------------------------------------------------------------#
# latexmk-manual
# https://man.cx/latexmk
# lualatex infos
# http://www.luatex.org/svn/trunk/manual/luatex.pdf

# cd into core
$do_cd = 1;
@default_files = (
    'core/main.en.tex',
    'core/main.de.tex',
);
# relative to main.tex
$out_dir = 'build';

ensure_path('TEXINPUTS', './styles//');

# replaces main.pdf by jobname.pdf
# May cause, that -pvc won't find pdf (but preview-section below is working).
# $jobname = 'balancing-paper';

#------------------------------------------------------------------------------#
# use lualatex

$lualatex = 'lualatex %O --shell-escape --file-line-error --halt-on-error --interaction=nonstopmode --synctex=-1 %S';

# 0 <-> do not create pdf-file
# 1 <-> pdflatex and $pdflatex
# ...
# 4 <-> lualatex and $lualatex
# ...
$pdf_mode = 4;

#------------------------------------------------------------------------------#
# preview
# You may put this info in ~/.latexmkrc

# >0 <-> equivalent to -pv
#$preview_mode = 0;
# >0 <-> equivalent to -pvc
#$preview_continuous_mode = 1;

#$view = 'pdf';
# 'evince' is 'Document Viewer' (Gnome's default)
#$pdf_previewer = 'evince';

#------------------------------------------------------------------------------#
# bib-files

# todo just for testing -> remove!?
# $biber = "biber --input-directory=$out_dir --output-directory=$out_dir %O %S";

# 2 <-> Run bibtex or biber whenever it appears necessary to update the bbl files,
# without testing for the existence of the bib filesbuild
# Further, always delete .bbl files in a cleanup.
$bibtex_use = 2;

#------------------------------------------------------------------------------#
# glossaries-support
# https://tex.stackexchange.com/a/44316

add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');
add_cus_dep('ntn', 'not', 0, 'run_makeglossaries');
add_cus_dep('stn', 'sot', 0, 'run_makeglossaries');

sub run_makeglossaries {
    # https://ipfs-sec.stackexchange.cloudflare-ipfs.com/tex/A/question/58963.html

    my ($base_name, $path) = fileparse( $_[0] );
    pushd $path;

    if ( $silent ) {
        system 'makeglossaries', '-q', $base_name;
    }
    else {
        system 'makeglossaries', $base_name;
    };

    popd;
}

#------------------------------------------------------------------------------#
# remove more files than in the default configuration

@generated_exts = qw(acn acr alg aux code ist fls glg glo gls glsdefs idx ind lof lot out thm toc tpt wrt);
# push @generated_exts, 'glo', 'gls', 'glg';
# push @generated_exts, 'acn', 'acr', 'alg';
$clean_ext .= ' %R.ist %R.xdy';
