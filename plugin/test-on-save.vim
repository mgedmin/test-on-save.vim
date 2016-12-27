" Plugin for run tests and showing a red or green bar (actually, changing
" the active statusline color to red or green).
"
" Inspired by Gary Bernhardt's screencasts.
" Written by Marius Gedminas <marius@gedmin.as> under severe time pressure.
" Consider using vim-makegreen.vim instead of this hack.
"
" Setup:
"   - drop the plugin into ~/.vim/plugin/
"   - make sure the statusline is always visible: set laststatus=2
"   - specify the shell command to run tests: let g:test_command='nosetests'
"   - EXPERIMENTAL: if you use nose, you can run Python tests in-process with
"     :let g:run_in_process=1.  WARNING: if the tests go into an infinite
"     loop, you can't terminate them with Ctrl-C, you'll have to kill vim.
"
" Usage:
"   - use :RunTests to run the tests now
"   - use :EnableTestOnSave to run the tests automatically on every save
"   - use :DisableTestOnSave if you're sick of that
"
if !exists('g:test_command')
    let g:test_command = "nosetests"
endif
if !exists('g:run_in_process')
    let g:run_in_process = 0
endif

let g:has_nose = -1 " autodetect
if has("python") || has("python3")
    let s:python = has('python3') ? 'python3' : 'python'
    exec s:python "import test_on_save"
endif

fun! RunTests()
    hi StatusLine ctermfg=NONE guifg=NONE
    redraw!
    if g:run_in_process && g:has_nose == -1
        exec g:python "test_on_save.autodetect_nose()"
    endif
    if g:run_in_process && g:has_nose
        exec g:python "vim.command('let g:pytestresult = %d' % (not test_on_save.run_tests()))"
    else
        let g:pytestoutput = system(g:test_command)
        let g:pytestresult = v:shell_error
    endif
    if g:pytestresult == 0
        hi link StatusLine StatusLineSuccess
    else
        hi link StatusLine StatusLineFailure
    endif
endf

fun! EnableTestOnSave()
    augroup TestOnSave
        au!
        au BufWritePost *.py call RunTests()
    augroup END
endf

fun! DisableTestOnSave()
    augroup TestOnSave
        au!
    augroup END
    hi link StatusLine StatusLineNeutral
endf

com! EnableTestOnSave call EnableTestOnSave()
com! DisaleTestOnSave call DisableTestOnSave()
com! RunTests call RunTests()

hi default StatusLineNeutral
            \ term=bold,reverse cterm=bold,reverse gui=bold,reverse
hi default StatusLineRunning ctermfg=yellow guifg=yellow
            \ term=bold,reverse cterm=bold,reverse gui=bold,reverse
hi default StatusLineSuccess ctermfg=green guifg=green
            \ term=bold,reverse cterm=bold,reverse gui=bold,reverse
hi default StatusLineFailure ctermfg=red guifg=red
            \ term=bold,reverse cterm=bold,reverse gui=bold,reverse

