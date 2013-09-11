# ubuntu requires packages git make rubygems libxml2-dev libxslt-dev zlib1g-dev virtualbox

# Most of these targets are pseudotargets, and make will always think
# they are out of date.  Requires GNU Make, since otherwise the logic
# is just too messy and brittle, and we only target Linux hosts, where
# no other make is installed anyway

BASEBOX=opengenera-ubuntu-7.10-server-amd64
vagrant_installed=$(if $(shell which vagrant), ,vagrant)
veewee_installed=$(if $(shell which veewee), ,veewee)


all: have_opengenera

.PHONY: all vagrant veewee clean
# Magic GNU make target to allow have_% targets to work
.SECONDEXPANSION:

clean:
	vagrant destroy
	rm -f *.box snap4.tar.gz
	echo "the iso directory can be removed"

# vagrant is a tool for automating virtualbox
vagrant:
	echo "### need to install vagrant";
	echo "try: sudo gem install vagrant";
	exit 2;

# veewee is a vagrant plugin to automate installs from distro CDs
veewee: $(vagrant_installed)
	echo "### need to install veewee";
	echo "try: sudo gem install veewee";
	exit 2;

# Here the magic happens. If vagrant reports the box named % is
# registered, then it's fine and we don't care about files existing or
# not. Otherwise an extra dependency on the file called %.box is added
have_%: $(vagrant_installed) $$(if $$(filter $$*, $$(shell vagrant box list)), ,$$*.box) ;

%_installed:  ;

# veewee might download an OS image. don't let make auto delete it, it's big!
.PRECIOUS: %.iso

$(BASEBOX).box: $(veewee_installed)
	  @echo "### need to build $(BASEBOX).box";
	  vagrant basebox build --force $(BASEBOX);
	  vagrant basebox validate $(BASEBOX);
	  vagrant basebox export   $(BASEBOX);

# test that the opengenera box is installed. make it if not.
opengenera.box: have_$(BASEBOX) opengenera2.tar.bz2
	  vagrant box add opengenera $(BASEBOX).box;
