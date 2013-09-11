# ubuntu requires packages git make rubygems libxml2-dev libxslt-dev zlib1g-dev virtualbox

# Most of these targets are pseudotargets, and make will always think
# they are out of date.  Requires GNU Make, since otherwise the logic
# is just too messy and brittle, and we only target Linux hosts, where
# no other make is installed anyway

BASEBOX=opengenera-ubuntu-7.10-server-amd64

all: have_opengenera opengenera2.tar.bz2

.PHONY: all vagrant veewee clean
# Magic GNU make target to allow have_% targets to work
.SECONDEXPANSION:

clean:
	vagrant destroy
	rm -f *.box snap4.tar.gz
	echo "the iso directory can be removed"

# vagrant is a tool for automating virtualbox
vagrant:
	@if test -z "$$(which vagrant)" ; then \
	  echo "### need to install vagrant"; \
	  echo "try: sudo gem install vagrant"; \
	  exit 2; \
	fi

# veewee is a vagrant plugin to automate installs from distro CDs
veewee: vagrant
	@if test -z "$$(bash -c 'vagrant basebox' 2>&1 | grep 'vagrant basebox <command> ')" ; then \
	  echo "### need to install veewee"; \
	  echo "try: sudo gem install veewee"; \
	  exit 2; \
	fi

# Here the magic happens. If vagrant reports the box named % is
# registered, then it's fine and we don't care about files existing or
# not. Otherwise an extra dependency on the file called %.box is added
have_%: vagrant $$(if $$(filter $$*, $$(shell vagrant box list)), ,$$*.box) ;

# veewee might download an OS image. don't let make auto delete it, it's big!
.PRECIOUS: %.iso

$(BASEBOX).box: veewee
	  @echo "### need to build $(BASEBOX).box";
	  vagrant basebox build --force $(BASEBOX);
	  vagrant basebox validate $(BASEBOX);
	  vagrant basebox export   $(BASEBOX);

# test that the opengenera box is installed. make it if not.
opengenera.box: vagrant have_$(BASEBOX)
	if test -z "$$(vagrant box list | grep -w opengenera)" ; then \
	  make $(BASEBOX).box; \
	  vagrant box add opengenera $(BASEBOX).box; \
	fi
