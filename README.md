This repository is the code for [Babelium's][] Mobile version.

[Babelium's]: http://babeliumproject.com

Here you will find the latest version of the Babelium Mobile prototype. It it developed using Adobe Flex and Adobe AIR and works for both Android and iOS devices.

This version currently has only a subset of the functionalities of the desktop version and doesn't support subtitle editing.

Cloning the repository
----------------------
To run the development version of Babelium Mobile first clone the repository

	$ git clone git://github.com/babeliumproject/flex-mobile-site.git flex-mobile-site

Now the entire project should be in the `flex-mobile-site/` directory.

Setting up the development environment
--------------------------------------
You need the following tools to start developing code for Babelium's Mobile version.

* Adobe Flex SDK 4.6+
* Adobe AIR 3.0+
* Adobe Flash Player 11.0+
* Adobe Flash Builder 4.5+ (to access the latest features of the Adobe AIR platform Flash Builder 4.6+ is recommended)

Download and unpack Flex SDK 4.6

	$ wget http://download.macromedia.com/pub/flex/sdk/flex_sdk_4.6.zip
	$ unzip flex_sdk_4.6.zip

Make a locale for Basque language (because it is not included by default):

	$ cd <flex_home>/bin
	$ ./copylocale en_US eu_ES

Import the checked out code in Adobe Flash Builder (install the EGit plugin first) to be able to commit and push from the IDE.

