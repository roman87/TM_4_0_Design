TM 4.0 Design
=============

Repo to hold files and designs for the 4.0 version of TeamMentor.


### Auto publish to Azure

This repo is currently configured to autopublish to Azure at http://tm-4-0-design.azurewebsites.net

TeamCity CI is used to pull the changes and push/publish to Azure (for more details see [issue 2](https://github.com/TeamMentor/TM_4_0_Design/issues/2))

### Wiki pages (on this repo)

* [IE CSS resources](https://github.com/TeamMentor/TM_4_0_Design/wiki/IE-CSS-resources)


Build status: [![Build Status](https://travis-ci.org/TeamMentor/TM_4_0_Design.svg?branch=Issue_66_TopNav_Auth)](https://travis-ci.org/TeamMentor/TM_4_0_Design)
Code coverage: [![Coverage Status](https://coveralls.io/repos/TeamMentor/TM_4_0_Design/badge.png?branch=master)](https://coveralls.io/r/TeamMentor/TM_4_0_Design?branch=Issue_68_Library_Rendering)

**to run dev brach**

* clone https://github.com/TeamMentor/TM_4_0_Design
* git checkout Issue_68_Library_Rendering
* npm install
* npm start
* http://localhost:1337/

**MAJOR REFACTORING CURRENTLY HAPPENING**

See the [Issue_80_Jade_Cleanup](https://github.com/TeamMentor/TM_4_0_Design/tree/Issue_80_Jade_Cleanup) branch for the current structure. 

The key objective of that branch is to create a clean and fully unit-tested version of TM Jade
