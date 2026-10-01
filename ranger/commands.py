# Custom ranger commands. See ranger's bundled commands.py for the defaults
# and API documentation (`pydoc ranger.api.commands`).

import os
import shutil

from ranger.api.commands import Command


class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        if self.quantifier:
            # match only directories
            command="find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
            -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        else:
            # match files and directories
            command="find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
            -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(command, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.decode('utf-8').rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


class rg(Command):
    """
    :rg <args>

    Search the current directory (or the marked files) with ripgrep and show
    the results in the pager. Arguments are passed straight through to rg,
    e.g. `:rg -w TODO` or `:rg -t py 'def \\w+'`.
    """
    def execute(self):
        import shlex
        if not shutil.which('rg'):
            self.fm.notify("ripgrep (rg) is not installed", bad=True)
            return
        if not self.rest(1):
            self.fm.notify("usage: :rg <pattern> [rg options]", bad=True)
            return
        cmd = ['rg', '--smart-case', '--hidden', '--pretty']
        cmd += shlex.split(self.rest(1))
        marked = self.fm.thisdir.marked_items
        if marked:
            cmd += ['--'] + [f.relative_path for f in marked]
        self.fm.execute_command(cmd, flags='p')
