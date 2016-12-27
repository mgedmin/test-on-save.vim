test-on-save.vim
================

Vim plugin to run tests after every ``:w``.  Inspired by Gary Bernhardt's
code kata screencast.

Sets the status line color to red/green to indicate results (be sure to
`:set laststatus=2` so the statusline is visible).


Usage
-----

:RunTests
    run tests now

:EnableTestOnSave
    run tests automatically after every save of a ``.py`` file

:DisableTestOnSave
    stop running the tests automatically


Configuration
-------------

g:test_command
    Default: "nosetests"

    Shell command to run the tests

g:run_in_process
    Default: 0

    If set to 1, attempts to run the testsuite inside the vim process,
    by importing ``nose`` as a Python module.  Ignores ``g:test_command``.

    Risky and not recommended, but could be a bit faster.

g:has_nose
    Default: -1

    If set to -1, attempts to autodetect the availability of ``nose``
    in your Python's site packages.

    Should not be set directly.


You can also tweak the status line colors by adjusting
``StatusLineNeutral``, ``StatusLineSuccess``, and ``StatusLineFailure``
highlight groups.


Bugs
----

- there is no :help
- should maybe try to copy the default StatusLineNeutral color from your
  colorscheme automatically
- should integrate with AsyncRun/NeoMake
- EnableTestOnSave should not hardcode ``*.py``


Copyright
---------

``test-on-save.vim`` was written by Marius Gedminas <marius@gedmin.as>.
Licence: MIT.
