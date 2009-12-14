AllYourCells
========

Because the airwaves belong to us all!
 
http://allyourcells.com

* The source code is available on Github at [http://github.com/trifecta/allyourcells](http://github.com/trifecta/allyourcells).
* Problems, suggestions, etc can also be sent to contact@allyourcells.com

About
------------

This project was created for the Consumer Electronic Associations Apps for Innovation contest.

When we embarked on the creation of this site in our spare time, less than two weeks before the Apps for Innovation deadline, we knew that the open source software community would be essential to us realizing our dream. We are deeply indebted to all those who toil everyday to create incredible software and freely share it with the world. We are proud to have toiled along side them and thankful for their efforts to enable us to build a new app and tools we can release back into the community. It is our hope that this app continues to celebrate that spirit and gives back to that community, to the people of the US, and the world.

Installation
------------

First, you'll need Ruby, Rails 2.3.5, MySQL, and the ruby MySQL bindings.

    git clone git://github.com/trifecta/allyourcells.git
    cd allyourcells
    git submodule init
    git submodule update
    
Then you'll need to create the config/database.yml and config/api_keys.yml files, based on the examples.

Then:

    [sudo] rake gems:install
    rake db:create
    rake db:migrate

To start up the application, simply run

   script/server

Contact us at contact@allyourcells.com if you run into any trouble; we'll revise these instructions as necessary to make it easy.

License
-------

AllYourCells is released under the Affero GPL v3, which requires that the source code be made available to any network user of the application. So while we encourage you to fork and run your own copies of this application, any changes you make need to be shared with their users.  Note that this does not allow the use of the AllYourCells name or logo.

AllYourCells itself is copyrighted by David Augustine, Robert Burbach, and Andrew Carpenter.

A variety of external libraries are included with this software; they are all open source, and with one exception are suitable for use in any way.