vim9script

var dish = 'spam omelet'

echo dish .. ' 1probably got spam in it'
execute 'echo dish  ''2probably got spam in it'''

# normal /eggdw
execute 'normal /eggdw'

silent echo dish .. ' 3probably got spam in it'
silent execute 'echo dish ''4probably got spam in it'''

silent !echo '5this is running in a shell'

if has('python3')
  echom 'Your Vim was compiled with Python 3 support!'
endif
