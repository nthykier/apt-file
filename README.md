# DESCRIPTION

apt-file helps you to find in which package a file is included. This
application has the same behaviour as the web version found at
https://packages.debian.org.

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
    # (or: apt-file find bin/lintian)

Alternatively, you can list all the files in a given package by using:

    apt-file show lintian
    # (or: apt-file list lintian)

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

## Upgrading from apt-file 2

The upgrade from apt-file 2 to apt-file comes with a number of
important changes.

### Backwards incompatible changes

 * The format of /etc/apt/apt-file.conf is now an APT
   configuration file.
 * The following command line options have been removed:
    * --cache
    * --cdrom-mount / -d
    * --dummy / -y
    * --non-interactive / -N
 * Command line options/commands have changed behaviour/meaning
    - The "-c" option is now "--config" (reads an APT config file)
    - The "show"/"list" command now does an "exact match" (-F)
      by default.  Use "--substring-match" to get the previous
      behaviour.
    - The "-a" option cannot be used with "source" or "udeb-$ARCH".
      Please use the new "--index-names" option.  Remember to
      configure APT to download the extra Contents files.
 * User caches are no longer supported by default.
   - This can be emulated via a user config file to change
     the APT cache location.
 * The "diffindex-download" and "diffindex-rred" tools
   have been removed.
 * apt-file has changed its exit codes.
   - Notably, it returns "non-zero" when there are no
     matches to the queries.
   - Please review the manpage for the different exit
     codes.
 * apt-file now uses "gnu-getopt" option style parsing.
   - If you have been relying on the undocumented feature
     of using "+" instead of "-" when specifying options,
     it will no longer work.

### Improvements due to using APT's acquire system

 * Contents files are now updated when using "apt update".
   - If download sizes or/and speed are a concern, please
     review the "OPTIMISING CONTENTS DOWNLOADS" section
     below.
 * apt-file now supports the Contents files being compressed
   in *any* compression format supported by APT.
 * apt-file now supports any sources.list file and download
   protocol that apt supports.  This includes:
   - The deb822 sources files
   - Protocols like "mirror" or "tor+http(s)"
   - Respecting APT's proxy settings

# OPTIMISING CONTENTS DOWNLOADS

There are a couple of methods to optimise the time / bandwidth used
by fetching new Contents files.

 * Ensure that PDiffs are enabled for Contents files
   - This is the default for apt-file/3, but your local configuration
     might have disabled it.
   - Keep in mind that PDiff cannot be used for the initial download
     or if it has been too long since your last update.
   - NB: Not all suites/distributions provide these.  Notably Ubuntu's
     development suites do ''not'' offer PDiffs.
 * Use apt/1.2 and its LZ4 compression for Contents files (requires
   PDiffs)
   - When fetching PDiffs, apt will recompress the Contents files as
     LZ4, which is vastly faster to decompress/compress than gzip.
   - This also gives a much faster search speed with apt-file.
 * Disable fetching of Contents files you do not need/want.
   - See the "Choosing which Contents files to fetch" section below.

If you are tracking a rapidly updating distribution, which does
''not'' have PDiffs, you probably want to disable fetching Contents by
default for that distribution.

## Choosing which Contents files to fetch

Even if you track multiple suites (or mirrors), you may not want to
download Contents files for all of them.

Here are a couple of suggestions:

 * If you track unstable + testing, you can probably omit the Contents
   files for testing without any issues.
 * Contents-dsc (source) has a rather large churn and even its PDiffs
   are large.
   - It is not enabled by default, but consider if you really need it
     before enabling it.

## Configuring APT to fetch fewer Contents files

There are several ways to do this:

 * Disable all Contents files by default and then enable them on a
   per source.list entry basis.
   - The example config file 60disable-contents-fetching.conf may be
     a useful starting point.  The full path is
     /usr/share/doc/apt-file/examples/60disable-contents-fetching.conf

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


## Download sizes

If you are interested in the download sizes involved, here are a few
numbers from Debian amd64 unstable (only the main component).

 * Full Contents: ~30MB (per download)
   - Measured in Feb 2016.
 * PDiffs: ~1.15MB/day
   - Average of PDiffs over 14 days in Feb 2016.

Accordingly, if you update your Contents files more frequently than
every once every ~26 days, it is (on average) cheaper to use PDiffs.
Of course, if you use a different distribution, your mileage may
vary.

**NOTE**: The "apt update" after installing apt-file 3 (or upgrading
from apt-file 2) *cannot* use PDiffs.  This is because PDiffs
are basically patches to your existing Contents files.


## PDiffs and speed

The original PDiff support in APT unfortunately suffered from a
number of performance issues.  This has lead to the general opinion
that "PDiffs are slow".

However, APT has implemented a number of improvements to the PDiff
performance (note that "rred" is the program applying the PDiffs).

 * Client-side PDiff merging since APT 0.9.14.3~exp2 (2014-01)
   - This greatly reduces the time taken to apply multiple PDiffs
   - Note that apt-file 2 had this feature for a long time.
 * Buffered reads in "rred" since APT 1.1.6 and 1.1.7 (2015-12)
 * Parallel running of "rred" since APT 1.2~exp1 (2016-01)
   - This makes APT apply PDiffs on Packages and Contents files in
     parallel (provided you got multiple CPU cores).
 * Recompression of Contents files to lz4 since APT 1.2~exp1 (2016-01)
   - This removes a major overhead in reading and writing gzipped
     Contents files.
   - This comes at a cost of compression ratio (~x2).
   - Alternatively, if disk space is important, you can use a
     better compressor (e.g. xz) at the cost of more time
     spent compressing.

If you are interested in the details of these improvements in APT,
please have a look at the following blog posts of Julian Andres Klode:

 * [Much faster incremental apt updates][much-faster-incremental-apt-updates]
 * [APT 1.1.8 to 1.1.10 – going “faster”][apt-1-1-8-to-1-1-10-going-faster]

[much-faster-incremental-apt-updates]: https://blog.jak-linux.org/2015/12/26/much-faster-incremental-apt-updates/
[apt-1-1-8-to-1-1-10-going-faster]: https://blog.jak-linux.org/2015/12/30/apt-1-1-8-to-1-1-10-going-faster/
