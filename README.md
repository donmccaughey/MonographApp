MonographApp
============

MacOS and iOS apps for creating diagrams for fixed-width character output.


Building MonographApp
---------------------
Clone the repository and initialize submodules, then generate the
`configure` script, configure and build.

    git clone https://github.com/donmccaughey/MonographApp.git
    cd MonographApp
    git submodule init
    git submodule update --init --recursive
    cd libmonograph
    autoreconf -i
    cd ..
    open MonographApp.xcodeproj


License
-------
_MonographApp_ is made available under a BSD-style license; see the LICENSE
file for details.
