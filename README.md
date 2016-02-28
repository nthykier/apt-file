# DESCRIPTION

apt-file helps you to find in which package a file is included. This
application has the same behaviour as the web version found at
http://packages.debian.org.

Additionally you can list all files included in a package without
installing or downloading it (see dpkg -S and dpkg --contents for more
details about listing a package content).

# GETTING STARTED

With apt-file, you can find files in packages or which packages
contains a given file.  To do this, apt-file needs access to the
Contents files, which are usually available from your mirror.  This
is done with:

  apt update

The apt command downloads the Contents files listed in its
configuration.  Here, apt-file installs
/etc/apt/apt.conf.d/50apt-file.conf to have apt download indices of
binary packages (.deb files).  Once downloaded, you can now search in
these indices by using:

  apt-file search bin/lintian
  (or: apt-file find bin/lintian)

Alternatively, you can list all the files in a given package by using:

  apt-file show lintian
  (or: apt-file list lintian)

NOTE: In apt-file 3, show and list takes an exact package name!  In
earlier versions of apt-file, any substring would do and it could
return multiple results.  If you want to use a substring search in
apt-file 3, please use the "--substring-match" option.

By default, apt-file will analyse the "deb" indices.  You can have it
look at other indices by using the "--index-names" option.

  apt-file --index-names dsc search frontend/lintian

  apt-file --index-names deb,udeb search bin/parted

  apt-file --index-names deb,udeb --substring-match show parted

This of course requires that you have the relevant indices available.
The indices listed in the examples above are all present in the
default /etc/apt/apt.conf.d/50apt-file.conf, although some of them are
disabled.

# OPTIMISING CONTENTS DOWNLOADS

There are a couple of methods to optimise the time / bandwidth used
by fetching new Contents files.

 * Ensure that PDiffs are enabled for Contents files
   - This is the default for apt-file/3, but your local configuration
     might have disabled it.
   - Keep in mind that PDiff cannot be used for the initial download
     or if it has been too long since your last update.
   - NB: Not all suites/distributions provide these.
 * Use apt/1.2 and its LZ4 compression for Contents files (requires
   PDiffs)
   - When fetching PDiffs, apt will recompress the Contents files as
     LZ4, which is vastly faster to decompress/compress than gzip.
   - This also gives a much faster search speed with apt-file.
 * Disable fetching of Contents files you do not need/want.
   - See the "Choosing which Contents files to fetch" section below.

## Choosing which Contents files to fetch

Even if you track multiple suites (or mirrors), you may not want to
download Contents files for all of them.

Here are a couple of suggestions:

 * Contents-dsc (source) has a rather large churn and even its PDiffs
   are large.

 * If you track unstable + testing, you can probably omit the Contents
   files for testing without any issues.

## Configuring APT to fetch fewer Contents files

There are several ways to do this:

 * Disable all Contents files by default and then enable them on a
   per source.list entry basis.

 * Disable Contents files for a given source.list entry

To disable/enable Contents fetching globally, simply set:

    Acquire::IndexTargets::deb::Contents-deb::DefaultEnabled

in your APT config to the desired value.  This works similarly with
other indices (remember to replace "::deb::" with "::deb-src::" for
the "Contents-dsc" target).

Then in your sources.list, you can manually enable/disable them on a
per target basis:

  deb [target+=Contents-deb] $MIRROR/debian unstable main ...
  deb [target-=Contents-deb] $MIRROR/debian unstable main ...

Note that the "Contents-dsc" should be on a "deb-src" entry.

For more information on this, please refer to "man 5 sources.list"
and "man 5 apt.conf"
