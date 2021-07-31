
giftwind@markuslab01:~/devops$ mkdir git1
giftwind@markuslab01:~/devops$ mkdir git2
giftwind@markuslab01:~/devops$ cd git 1
-bash: cd: too many arguments
giftwind@markuslab01:~/devops$ git clone https://github.com/GiftWind/samehash.git
Cloning into 'samehash'...
remote: Enumerating objects: 6, done.
remote: Counting objects: 100% (6/6), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 6 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (6/6), done.
giftwind@markuslab01:~/devops$ sudo rm -r samehash/
giftwind@markuslab01:~/devops$ cd git1
giftwind@markuslab01:~/devops/git1$ git clone https://github.com/GiftWind/samehash.git
Cloning into 'samehash'...
remote: Enumerating objects: 6, done.
remote: Counting objects: 100% (6/6), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 6 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (6/6), done.
giftwind@markuslab01:~/devops/git1$ cd ../git2
giftwind@markuslab01:~/devops/git2$ git clone https://github.com/GiftWind/samehash.git
Cloning into 'samehash'...
remote: Enumerating objects: 6, done.
remote: Counting objects: 100% (6/6), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 6 (delta 0), reused 0 (delta 0), pack-reused 0
Receiving objects: 100% (6/6), done.
giftwind@markuslab01:~/devops/git2$ git show -s HEAD
fatal: not a git repository (or any of the parent directories): .git
giftwind@markuslab01:~/devops/git2$ ll
total 12
drwxrwxr-x 3 giftwind giftwind 4096 Jul 28 19:32 ./
drwxrwxr-x 6 giftwind giftwind 4096 Jul 28 19:32 ../
drwxrwxr-x 3 giftwind giftwind 4096 Jul 28 19:32 samehash/
giftwind@markuslab01:~/devops/git2$ cd samehash/
giftwind@markuslab01:~/devops/git2/samehash$ git show -s HEAD
commit a82f46f4971eb29e141a529d363e16388c29e2a6 (HEAD -> main, origin/main, origin/HEAD)
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 21:29:51 2021 +0300

    create content file
giftwind@markuslab01:~/devops/git2/samehash$ cd ~/devops/git1/samehash

Delete the symbol after:
giftwind@markuslab01:~/devops/git1/samehash$ git show -s HEAD
commit a82f46f4971eb29e141a529d363e16388c29e2a6 (HEAD -> main, origin/main, origin/HEAD)

Delete the symbol after:
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 21:29:51 2021 +0300

    create content file
giftwind@markuslab01:~/devops/git1/samehash$ git show HEAD
commit a82f46f4971eb29e141a529d363e16388c29e2a6 (HEAD -> main, origin/main, origin/HEAD)
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 21:29:51 2021 +0300

    create content file

diff --git a/content b/content
new file mode 100644
index 0000000..0077bdd
--- /dev/null
+++ b/content
@@ -0,0 +1 @@
+Delete the symbol after: S
giftwind@markuslab01:~/devops/git1/samehash$ cd .git/objects/
info/ pack/
giftwind@markuslab01:~/devops/git1/samehash$ cd .git/objects/
info/ pack/
giftwind@markuslab01:~/devops/git1/samehash$ cd .git/objects/
info/ pack/
giftwind@markuslab01:~/devops/git1/samehash$ cd .git/objects/
giftwind@markuslab01:~/devops/git1/samehash/.git/objects$ ll
total 16
drwxrwxr-x 4 giftwind giftwind 4096 Jul 28 19:32 ./
drwxrwxr-x 8 giftwind giftwind 4096 Jul 28 19:32 ../
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:32 info/
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:32 pack/
giftwind@markuslab01:~/devops/git1/samehash/.git/objects$ cd ..
giftwind@markuslab01:~/devops/git1/samehash/.git$ cd ..
giftwind@markuslab01:~/devops/git1/samehash$ vim content
giftwind@markuslab01:~/devops/git1/samehash$ cd ~/devops/git2/samehash
giftwind@markuslab01:~/devops/git2/samehash$ vim content
giftwind@markuslab01:~/devops/git2/samehash$ git commit --date=2021-07-28T22:36:00 -m "delete the symbol"
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   content

no changes added to commit (use "git add" and/or "git commit -a")
giftwind@markuslab01:~/devops/git2/samehash$ git add .
giftwind@markuslab01:~/devops/git2/samehash$ git commit --date=2021-07-28T22:36:00 -m "delete the symbol"
[main a67a445] delete the symbol
 Date: Wed Jul 28 22:36:00 2021 +0000
 1 file changed, 1 insertion(+), 1 deletion(-)
giftwind@markuslab01:~/devops/git2/samehash$ cd ~/devops/git1/samehash
giftwind@markuslab01:~/devops/git1/samehash$ cat content
Delete the symbol after:
giftwind@markuslab01:~/devops/git1/samehash$ git add .
giftwind@markuslab01:~/devops/git1/samehash$ git commit --date=2021-07-28T22:36:00 -m "delete the symbol"
[main f104457] delete the symbol
 Date: Wed Jul 28 22:36:00 2021 +0000
 1 file changed, 1 insertion(+), 1 deletion(-)
giftwind@markuslab01:~/devops/git1/samehash$ git cd .git/objects/
c6/   cd/   f1/   info/ pack/
giftwind@markuslab01:~/devops/git1/samehash$ ll .git/objects/f1
total 12
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:37 ./
drwxrwxr-x 7 giftwind giftwind 4096 Jul 28 19:37 ../
-r--r--r-- 1 giftwind giftwind  170 Jul 28 19:37 04457c9a0a66ab0937a2c9eefc5ffb435157f9
giftwind@markuslab01:~/devops/git1/samehash$ ll ~/devops/git2/samehash/.git/objects/f1
ls: cannot access '/home/giftwind/devops/git2/samehash/.git/objects/f1': No such file or directory
giftwind@markuslab01:~/devops/git1/samehash$ cd ~/devops/git1/samehash
giftwind@markuslab01:~/devops/git1/samehash$ ll
total 20
drwxrwxr-x 3 giftwind giftwind 4096 Jul 28 19:35 ./
drwxrwxr-x 3 giftwind giftwind 4096 Jul 28 19:32 ../
-rw-rw-r-- 1 giftwind giftwind   26 Jul 28 19:35 content
drwxrwxr-x 8 giftwind giftwind 4096 Jul 28 19:37 .git/
-rw-rw-r-- 1 giftwind giftwind   61 Jul 28 19:32 README.md
giftwind@markuslab01:~/devops/git1/samehash$ cd .git
giftwind@markuslab01:~/devops/git1/samehash/.git$ ll
total 56
drwxrwxr-x 8 giftwind giftwind 4096 Jul 28 19:37 ./
drwxrwxr-x 3 giftwind giftwind 4096 Jul 28 19:35 ../
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:32 branches/
-rw-rw-r-- 1 giftwind giftwind   18 Jul 28 19:37 COMMIT_EDITMSG
-rw-rw-r-- 1 giftwind giftwind  261 Jul 28 19:32 config
-rw-rw-r-- 1 giftwind giftwind   73 Jul 28 19:32 description
-rw-rw-r-- 1 giftwind giftwind   21 Jul 28 19:32 HEAD
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:32 hooks/
-rw-rw-r-- 1 giftwind giftwind  209 Jul 28 19:37 index
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:32 info/
drwxrwxr-x 3 giftwind giftwind 4096 Jul 28 19:32 logs/
drwxrwxr-x 7 giftwind giftwind 4096 Jul 28 19:37 objects/
-rw-rw-r-- 1 giftwind giftwind  112 Jul 28 19:32 packed-refs
drwxrwxr-x 5 giftwind giftwind 4096 Jul 28 19:32 refs/
giftwind@markuslab01:~/devops/git1/samehash/.git$ cd objects/
giftwind@markuslab01:~/devops/git1/samehash/.git/objects$ ll
total 28
drwxrwxr-x 7 giftwind giftwind 4096 Jul 28 19:37 ./
drwxrwxr-x 8 giftwind giftwind 4096 Jul 28 19:37 ../
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:37 c6/
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:37 cd/
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:37 f1/
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:32 info/
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:32 pack/
giftwind@markuslab01:~/devops/git1/samehash/.git/objects$ ll f1
total 12
drwxrwxr-x 2 giftwind giftwind 4096 Jul 28 19:37 ./
drwxrwxr-x 7 giftwind giftwind 4096 Jul 28 19:37 ../
-r--r--r-- 1 giftwind giftwind  170 Jul 28 19:37 04457c9a0a66ab0937a2c9eefc5ffb435157f9
giftwind@markuslab01:~/devops/git1/samehash/.git/objects$ cd ..
giftwind@markuslab01:~/devops/git1/samehash/.git$ cd ..
giftwind@markuslab01:~/devops/git1/samehash$ git show HEAD
commit f104457c9a0a66ab0937a2c9eefc5ffb435157f9 (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 22:36:00 2021 +0000

    delete the symbol

diff --git a/content b/content
index 0077bdd..cdf093a 100644
--- a/content
+++ b/content
@@ -1 +1 @@
-Delete the symbol after: S
+Delete the symbol after:
giftwind@markuslab01:~/devops/git1/samehash$ cd ~/devops/git2/samehash
giftwind@markuslab01:~/devops/git2/samehash$ git show HEAD
commit a67a4450013ceb2e9b14f86565cf812f68a1f08f (HEAD -> main)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 22:36:00 2021 +0000

    delete the symbol

diff --git a/content b/content
index 0077bdd..cdf093a 100644
--- a/content
+++ b/content
@@ -1 +1 @@
-Delete the symbol after: S
+Delete the symbol after:
giftwind@markuslab01:~/devops/git2/samehash$ git push
Username for 'https://github.com': ^C
giftwind@markuslab01:~/devops/git2/samehash$ git push
Username for 'https://github.com': GiftWind
Password for 'https://GiftWind@github.com':
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 312 bytes | 312.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0

To https://github.com/GiftWind/samehash.git
   a82f46f..a67a445  main -> main
giftwind@markuslab01:~/devops/git2/samehash$ git pull
Already up to date.
giftwind@markuslab01:~/devops/git2/samehash$ cd ~/devops/git1/samehash
giftwind@markuslab01:~/devops/git1/samehash$ git push
Username for 'https://github.com': GiftWind
Password for 'https://GiftWind@github.com':
To https://github.com/GiftWind/samehash.git
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'https://github.com/GiftWind/samehash.git'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing
hint: to the same ref. You may want to first integrate the remote changes
hint: (e.g., 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
giftwind@markuslab01:~/devops/git1/samehash$ git pull
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 3 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), 292 bytes | 73.00 KiB/s, done.
From https://github.com/GiftWind/samehash
   a82f46f..a67a445  main       -> origin/main
hint: Pulling without specifying how to reconcile divergent branches is
hint: discouraged. You can squelch this message by running one of the following
hint: commands sometime before your next pull:
hint:
hint:   git config pull.rebase false  # merge (the default strategy)
GIT(1)                                                             Git Manual                                                             GIT(1)

NAME
       git - the stupid content tracker

SYNOPSIS
       git [--version] [--help] [-C <path>] [-c <name>=<value>]
           [--exec-path[=<path>]] [--html-path] [--man-path] [--info-path]
           [-p|--paginate|-P|--no-pager] [--no-replace-objects] [--bare]
           [--git-dir=<path>] [--work-tree=<path>] [--namespace=<name>]
           [--super-prefix=<path>]
           <command> [<args>]

DESCRIPTION
       Git is a fast, scalable, distributed revision control system with an unusually rich command set that provides both high-level operations
       and full access to internals.

       See gittutorial(7) to get started, then see giteveryday(7) for a useful minimum set of commands. The Git User’s Manual[1] has a more
       in-depth introduction.

       After you mastered the basic concepts, you can come back to this page to learn what commands Git offers. You can learn more about
       individual Git commands with "git help command". gitcli(7) manual page gives you an overview of the command-line command syntax.

       A formatted and hyperlinked copy of the latest Git documentation can be viewed at https://git.github.io/htmldocs/git.html or
       https://git-scm.com/docs.

OPTIONS
       --version
           Prints the Git suite version that the git program came from.

       --help
           Prints the synopsis and a list of the most commonly used commands. If the option --all or -a is given then all available commands are
           printed. If a Git command is named this option will bring up the manual page for that command.

           Other options are available to control how the manual page is displayed. See git-help(1) for more information, because git --help ...
           is converted internally into git help ....

       -C <path>
           Run as if git was started in <path> instead of the current working directory. When multiple -C options are given, each subsequent
           non-absolute -C <path> is interpreted relative to the preceding -C <path>. If <path> is present but empty, e.g.  -C "", then the
           current working directory is left unchanged.

           This option affects options that expect path name like --git-dir and --work-tree in that their interpretations of the path names
           would be made relative to the working directory caused by the -C option. For example the following invocations are equivalent:

               git --git-dir=a.git --work-tree=b -C c status
               git --git-dir=c/a.git --work-tree=c/b status

       -c <name>=<value>
           Pass a configuration parameter to the command. The value given will override values from configuration files. The <name> is expected
           in the same format as listed by git config (subkeys separated by dots).

           Note that omitting the = in git -c foo.bar ...  is allowed and sets foo.bar to the boolean true value (just like [foo]bar would in a
           config file). Including the equals but with an empty value (like git -c foo.bar= ...) sets foo.bar to the empty string which git
           config --type=bool will convert to false.

       --exec-path[=<path>]
           Path to wherever your core Git programs are installed. This can also be controlled by setting the GIT_EXEC_PATH environment variable.
           If no path is given, git will print the current setting and then exit.

       --html-path
           Print the path, without trailing slash, where Git’s HTML documentation is installed and exit.

       --man-path
           Print the manpath (see man(1)) for the man pages for this version of Git and exit.

       --info-path
           Print the path where the Info files documenting this version of Git are installed and exit.

       -p, --paginate
           Pipe all output into less (or if set, $PAGER) if standard output is a terminal. This overrides the pager.<cmd> configuration options
           (see the "Configuration Mechanism" section below).

       -P, --no-pager
           Do not pipe Git output into a pager.

       --git-dir=<path>
           Set the path to the repository. This can also be controlled by setting the GIT_DIR environment variable. It can be an absolute path
           or relative path to current working directory.

       --work-tree=<path>
           Set the path to the working tree. It can be an absolute path or a path relative to the current working directory. This can also be
           controlled by setting the GIT_WORK_TREE environment variable and the core.worktree configuration variable (see core.worktree in git-
           config(1) for a more detailed discussion).

       --namespace=<path>
           Set the Git namespace. See gitnamespaces(7) for more details. Equivalent to setting the GIT_NAMESPACE environment variable.

       --super-prefix=<path>
           Currently for internal use only. Set a prefix which gives a path from above a repository down to its root. One use is to give
           submodules context about the superproject that invoked it.

       --bare
           Treat the repository as a bare repository. If GIT_DIR environment is not set, it is set to the current working directory.

       --no-replace-objects
           Do not use replacement refs to replace Git objects. See git-replace(1) for more information.

       --literal-pathspecs
           Treat pathspecs literally (i.e. no globbing, no pathspec magic). This is equivalent to setting the GIT_LITERAL_PATHSPECS environment
           variable to 1.

       --glob-pathspecs
           Add "glob" magic to all pathspec. This is equivalent to setting the GIT_GLOB_PATHSPECS environment variable to 1. Disabling globbing
           on individual pathspecs can be done using pathspec magic ":(literal)"

       --noglob-pathspecs
           Add "literal" magic to all pathspec. This is equivalent to setting the GIT_NOGLOB_PATHSPECS environment variable to 1. Enabling
           globbing on individual pathspecs can be done using pathspec magic ":(glob)"

       --icase-pathspecs
           Add "icase" magic to all pathspec. This is equivalent to setting the GIT_ICASE_PATHSPECS environment variable to 1.

       --no-optional-locks
           Do not perform optional operations that require locks. This is equivalent to setting the GIT_OPTIONAL_LOCKS to 0.

       --list-cmds=group[,group...]
           List commands by group. This is an internal/experimental option and may change or be removed in the future. Supported groups are:
           builtins, parseopt (builtin commands that use parse-options), main (all commands in libexec directory), others (all other commands in
           $PATH that have git- prefix), list-<category> (see categories in command-list.txt), nohelpers (exclude helper commands), alias and
           config (retrieve command list from config variable completion.commands)

GIT COMMANDS
       We divide Git into high level ("porcelain") commands and low level ("plumbing") commands.

HIGH-LEVEL COMMANDS (PORCELAIN)
       We separate the porcelain commands into the main commands and some ancillary user utilities.

   Main porcelain commands
       git-add(1)
           Add file contents to the index.

       git-am(1)
           Apply a series of patches from a mailbox.

       git-archive(1)
           Create an archive of files from a named tree.

       git-bisect(1)
           Use binary search to find the commit that introduced a bug.

       git-branch(1)
           List, create, or delete branches.

       git-bundle(1)
           Move objects and refs by archive.

       git-checkout(1)
           Switch branches or restore working tree files.

       git-cherry-pick(1)
           Apply the changes introduced by some existing commits.

       git-citool(1)
           Graphical alternative to git-commit.

       git-clean(1)
           Remove untracked files from the working tree.

       git-clone(1)
           Clone a repository into a new directory.

       git-commit(1)
           Record changes to the repository.

       git-describe(1)
           Give an object a human readable name based on an available ref.

       git-diff(1)
           Show changes between commits, commit and working tree, etc.

       git-fetch(1)
           Download objects and refs from another repository.

       git-format-patch(1)
           Prepare patches for e-mail submission.

       git-gc(1)
           Cleanup unnecessary files and optimize the local repository.

       git-grep(1)
           Print lines matching a pattern.

       git-gui(1)
           A portable graphical interface to Git.

       git-init(1)
           Create an empty Git repository or reinitialize an existing one.

       git-log(1)
           Show commit logs.

       git-merge(1)
           Join two or more development histories together.

       git-mv(1)
           Move or rename a file, a directory, or a symlink.

       git-notes(1)
           Add or inspect object notes.

       git-pull(1)
           Fetch from and integrate with another repository or a local branch.

       git-push(1)
           Update remote refs along with associated objects.

       git-range-diff(1)
           Compare two commit ranges (e.g. two versions of a branch).

       git-rebase(1)
           Reapply commits on top of another base tip.

       git-reset(1)
           Reset current HEAD to the specified state.

hint:   git config pull.rebase true   # rebase
hint:   git config pull.ff only       # fast-forward only
hint:
hint: You can replace "git config" with "git config --global" to set a default
hint: preference for all repositories. You can also pass --rebase, --no-rebase,
hint: or --ff-only on the command line to override the configured default per
hint: invocation.
Merge made by the 'recursive' strategy.
giftwind@markuslab01:~/devops/git1/samehash$ git push
Username for 'https://github.com': GiftWind
Password for 'https://GiftWind@github.com':
remote: Invalid username or password.
fatal: Authentication failed for 'https://github.com/GiftWind/samehash.git/'
giftwind@markuslab01:~/devops/git1/samehash$ git pull
hint: Pulling without specifying how to reconcile divergent branches is
hint: discouraged. You can squelch this message by running one of the following
hint: commands sometime before your next pull:
hint:
hint:   git config pull.rebase false  # merge (the default strategy)
hint:   git config pull.rebase true   # rebase
hint:   git config pull.ff only       # fast-forward only
hint:
hint: You can replace "git config" with "git config --global" to set a default
hint: preference for all repositories. You can also pass --rebase, --no-rebase,
hint: or --ff-only on the command line to override the configured default per
hint: invocation.
Already up to date.
giftwind@markuslab01:~/devops/git1/samehash$ git show
commit f892348d700be3521c8c01b90a5889ee9171685e (HEAD -> main)
Merge: f104457 a67a445
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 19:42:45 2021 +0000

    Merge branch 'main' of https://github.com/GiftWind/samehash

giftwind@markuslab01:~/devops/git1/samehash$ man git
giftwind@markuslab01:~/devops/git1/samehash$ git log
commit f892348d700be3521c8c01b90a5889ee9171685e (HEAD -> main)
Merge: f104457 a67a445
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 19:42:45 2021 +0000

    Merge branch 'main' of https://github.com/GiftWind/samehash

commit f104457c9a0a66ab0937a2c9eefc5ffb435157f9
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 22:36:00 2021 +0000

    delete the symbol

commit a67a4450013ceb2e9b14f86565cf812f68a1f08f (origin/main, origin/HEAD)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 22:36:00 2021 +0000

    delete the symbol

commit a82f46f4971eb29e141a529d363e16388c29e2a6
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 21:29:51 2021 +0300

    create content file

commit 42ddeace6fa0fbf6e121e80ebe03a2be8e5b69ff
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 21:28:58 2021 +0300

    Initial commit
giftwind@markuslab01:~/devops/git1/samehash$ cd ~/devops/git2/samehash
giftwind@markuslab01:~/devops/git2/samehash$ git log
commit a67a4450013ceb2e9b14f86565cf812f68a1f08f (HEAD -> main, origin/main, origin/HEAD)
Author: Mark Okulov <mvokulov@gmail.com>
Date:   Wed Jul 28 22:36:00 2021 +0000

    delete the symbol

commit a82f46f4971eb29e141a529d363e16388c29e2a6
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 21:29:51 2021 +0300

    create content file

commit 42ddeace6fa0fbf6e121e80ebe03a2be8e5b69ff
Author: GiftWind <mvokulov@gmail.com>
Date:   Wed Jul 28 21:28:58 2021 +0300

    Initial commit
giftwind@markuslab01:~/devops/git2/samehash$ git cat-file -p a67
fatal: Not a valid object name a67
giftwind@markuslab01:~/devops/git2/samehash$ git cat-file -p a67a4450013ceb2e9b14f86565cf812f68a1f08f
tree c66d409cc47de05d3493b51e915e6a11528607d4
parent a82f46f4971eb29e141a529d363e16388c29e2a6
author Mark Okulov <mvokulov@gmail.com> 1627511760 +0000
committer Mark Okulov <mvokulov@gmail.com> 1627501008 +0000

delete the symbol
giftwind@markuslab01:~/devops/git2/samehash$ cd ~/devops/git2/samehash
giftwind@markuslab01:~/devops/git2/samehash$ cd ~/devops/git1/samehash
giftwind@markuslab01:~/devops/git1/samehash$ git cat-file -p f104457c9a0a66ab0937a2c9eefc5ffb435157f9
tree c66d409cc47de05d3493b51e915e6a11528607d4
parent a82f46f4971eb29e141a529d363e16388c29e2a6
author Mark Okulov <mvokulov@gmail.com> 1627511760 +0000
committer Mark Okulov <mvokulov@gmail.com> 1627501047 +0000

delete the symbol
giftwind@markuslab01:~/devops/git1/samehash$
