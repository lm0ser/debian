# motd
wget -qO- https://raw.githubusercontent.com/lm0ser/debian9/master/motd/install.sh | bash

# .bashrc
wget -qO- https://raw.githubusercontent.com/lm0ser/debian9/master/bashrc/bashrc | touch /etc/profile.d/bash.sh | chmod +x /etc/profile.d/bash.sh | bash
