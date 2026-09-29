Synthetic web pages served by the harness's fake Internet (mgba_trace --net fake --web-map ...).
Written for this project (they are not Nintendo/DION content). run_trace.py converts them to Shift-JIS (cp932)
into .cache/trace/web/ before serving. They only exist to make the ROM's HTTP client / HTML renderer run.
Any request whose path contains "index.html" gets index.html; any other ".html" gets page.html; everything else is a 404.
