# bash_examples

Some example bash scripts.

I'm writing some bash scripts and I'm using this github repo to backup and share my work.
If you find this helpful, I'm glad.

## lister.sh :

Function and argument parsing. File checking and appending. Parallel execution.

## getName.sh :

Regular console input and output. Exit code underflow.

## readingLoop.sh :

Example of looping and input validation.

## hello.sh :

Customary hello_world.

## test.sh :

Used for testing version control features.

## RenameAndReplace.sh :

Renames a file or directory on a remote host and replaces it with a local one.  Example of getopts, testing files and directories, scp, conditionals, keywords etc.

## ImportOvpnFiles.sh :

A handy little script which checks for existing duplicate connections before importing a bunch of .ovpn files in a directory with nmcli

## testSSHConnection.sh :

Feed it a file with each line being username@hostname or and ip address and it will attempt to ssh into each of them and report the status to the console.  I use this to test that my ssh key authentication is up to date on servers.

## BulkOP.sh :

Feed it a file with each line being username@hostname or ip address and it will attempt to ssh into each of them and execute the string sent in as OP.

## BulkSCP.sh :

Feed it a file with each line being username@hostname or ip address and it will attempt to ssh into each one of them and copy a local file or directory sent in as InputFile to a RemotePath on each host listed in HostsFile.

## BulkScriptExecute.sh :

Feed it a file with each line being a hostname or ip address and it will execute a local script passed to it on each remote host in the HostsFile.
