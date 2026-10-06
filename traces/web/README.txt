Synthetic web pages and images served by the harness's fake Internet (mgba_trace --net fake --web-map ...).
Written for this project (they are not Nintendo/DION content); tools/trace/make_fixtures.py generates the .bmp files.
run_trace.py converts the .html files to Shift-JIS (cp932) into .cache/trace/web/ before serving. They only exist to make
the ROM's HTTP client / HTML renderer / image loader run.

web=1 (scenarios.tsv): any request whose path contains "index.html" gets index.html; any other ".html" gets page.html;
                       everything else is a 404 (the original two-page setup of the first 18 scenarios).
web=all:               a request whose path contains "/<file name>" of a file in this directory gets that file
                       (a.html, b.html, c.html, d.html, img_*.bmp); "index.html" gets index.html; any other ".html" gets page.html;
                       everything else is a 404 (or the status set with the net option http_missing).
Pages: index (3 links + a page link), a (ol/ul/pre/div/img/comment/meta), b (60 lines, scrolling, image), c (links: 404, ../di/*.htm
help pages of the ROM, absolute URL, bmp-only URLs, fragment, mailto, other host), d (body attributes, div/center).

Round 3 additions:
img_w1.bmp .. img_w16.bmp   8-pixel-high 1 bpp images of width 1..16 (tools/trace/make_fixtures.py), used by the r2 site.
web=r2 (scenarios.tsv):     traces/web/r2/* first (its own index.html, t1/t3-t6/t5ng pages, im.html + 27 one-image pages i<w><p|c|r|l|f|g|t>.html, s4200/s12000 = pages of ~4.2 KB / ~12 KB served),
                            then everything of web=all. t6.htm is written with CR LF (the .html files are converted to cp932 with LF only). NAME.meta next to a page holds `status N` /
                            `hdr Header: value` lines. Do NOT put two different images on one page: the ROM crashes in this environment (docs/research/dynamic_tracing.md 11.3, item 3).

Round 4 addition:
web=ul (scenarios.tsv):     traces/web/ul/* first (its own index.html: closed, unclosed, brl_list, bra_list, brl_out, brl_after, brr_list), then everything of web=all: a list that is closed and one that is not,
                            and <br clear=left|all|right> inside and outside a list (docs/research/dynamic_tracing.md section 12).  Any sub-directory of traces/web is a site: `web=<directory name>`.
