Additional CMake Modules
========================

Introduction
------------

This is a collection of additional CMake modules.
Most of them are from Ryan Pavlik (<http://academic.cleardefinition.com>).

How to Integrate
----------------

These modules are probably best placed wholesale into a "cmake" subdirectory
of your project source.

If you use Git, try installing [git-subtree][1],
so you can easily use this repository for subtree merges, updating simply.

For the initial checkout:

	cd projectdir

	git subtree add --squash --prefix=cmake git@github.com:bilke/cmake-modules.git master

For updates:

	cd projectdir

	git subtree pull --squash --prefix=cmake git@github.com:bilke/cmake-modules.git master

For pushing to upstream:

	cd projectdir

	git subtree push --prefix=cmake git@github.com:bilke/cmake-modules.git master


How to Use
----------

At the minimum, all you have to do is add a line like this near the top
of your root CMakeLists.txt file (but not before your project() call):

	list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

You might also want the extra automatic features/fixes included with the
modules, for that, just add another line following the first one:

	include(UseBackportedModules)


Licenses
--------

The modules that are written by Ryan Pavlik are all subject to this license:

> Copyright Iowa State University 2009-2011
>
> Distributed under the Boost Software License, Version 1.0.
>
> (See accompanying file `LICENSE_1_0.txt` or copy at
> <http://www.boost.org/LICENSE_1_0.txt>)

Modules based on those included with CMake as well as modules added by me (Lars
Bilke) are under the OSI-approved **BSD** license, which is included in each of
those modules. A few other modules are modified from other sources - when in
doubt, look at the .cmake.

Important License Note!
-----------------------

If you find this file inside of another project, rather at the top-level
directory, you're in a separate project that is making use of these modules.
That separate project can (and probably does) have its own license specifics.


[1]: http://github.com/apenwarr/git-subtree  "Git Subtree master"
