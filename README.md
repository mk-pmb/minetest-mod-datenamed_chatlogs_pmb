
<!--#echo json="package.json" key="name" underline="=" -->
datenamed_chatlogs_pmb
======================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Create logfiles in the world directory, with paths based on message time.
<!--/#echo -->



Time format templates
---------------------

We use LUA's `os.date()`, which is described to behave like `strftime`.
However, in LUA, this means a very minimal POSIX `strftime`,
which especially [does not support extensions like `%s`][no-s-in-strftime].


  [no-s-in-strftime]: https://bugzilla.redhat.com/show_bug.cgi?id=1199987#c7





Known issues
------------

* Needs more/better tests and docs.




&nbsp;


License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
