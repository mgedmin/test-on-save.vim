import sys
try:
    from cStringIO import StringIO
except ImportError:
    from io import StringIO


def autodetect_nose():
    import vim
    try:
        import nose  # noqa
    except ImportError:
        vim.command('let g:has_nose = 0')
    else:
        vim.command('let g:has_nose = 1')


def run_tests():
    import nose
    old_modules = set(sys.modules)
    old_out, old_err = sys.stdout, sys.stderr
    try:
        sys.stdout = StringIO()
        sys.stderr = StringIO()
        return nose.run()
    finally:
        sys.stdout, sys.stderr = old_out, old_err
        for m in set(sys.modules) - old_modules:
            del sys.modules[m]
