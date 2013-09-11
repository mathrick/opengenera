set -e

#Installing ruby
wget http://rubyforge.org/frs/download.php/71096/ruby-enterprise-1.8.7-2010.02.tar.gz
tar xzvf ruby-enterprise-1.8.7-2010.02.tar.gz
mkdir -p /opt/ruby/lib/ruby/gems/1.8/gems

# installer is broken, hack around it
# see http://blog.martinlv.cawing.info/?p=93
RUBYINST="./ruby-enterprise-1.8.7-2010.02/installer -a /opt/ruby --no-dev-docs --dont-install-useful-gems"
HACKMSG="Ruby installer failed, trying to work around a known clock bug"
DAY=`expr 24 '*' 3600`
$RUBYINST || (
    echo $HACKMSG
    now=`date +%s`
    sudo date -s @`expr $now '+' $DAY`
    $RUBYINST
    now=`date +%s`
    sudo date -s @`expr $now '-' $DAY` )

echo 'PATH=$PATH:/opt/ruby/bin/'>> /etc/profile
rm -rf ./ruby-enterprise-1.8.7-2010.02/
rm ruby-enterprise-1.8.7-2010.02.tar.gz

#Installing chef & Puppet
/opt/ruby/bin/gem install chef --no-ri --no-rdoc
/opt/ruby/bin/gem install puppet --no-ri --no-rdoc
