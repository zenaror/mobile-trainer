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
