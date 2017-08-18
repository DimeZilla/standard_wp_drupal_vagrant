# About
I created this for me so that I could simply save my ideal vagrant setup for launching wordpress or drupal sites.

# Dependencies
- Requires a Vagrant installation.
- Linux - was written on cygwin in Windows 10
     Note: You might have to install dostounix and convert the line endings of some of these files 
           if you try to run it in mac. not sure. Portability of this program is totally untested.

# Installation
Git clone the project, cd into the directory and run:
```
chmod +x setup.sh
chmod +x craete_dev.sh
./setup.sh
```

# USAGE
Now you can run create_dev anywhere and pass it a project name like so
```
create_dev my-project
cd my-project
vagrant up
```

# Feedback
Always welcome! Feel free to use this project. Just let me know how you like it. Diamond.joshh@gmail.com
