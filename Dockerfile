FROM archlinux:latest

RUN pacman -Sy && \
    pacman -S --noconfirm fish lua make && \
    pacman -Sc --noconfirm

RUN mkdir ~/.config/fish -p
RUN echo 'zua.lua init | source' >> ~/.config/fish/config.fish
RUN echo 'set -gx ZUA_DATA_FILE ~/zua_data_file' >> ~/.config/fish/config.fish
RUN touch ~/zua_data_file

COPY . /zua
RUN cd /zua && make install

CMD /usr/bin/fish
