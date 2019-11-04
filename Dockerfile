FROM ubuntu

ENV HOME="/root"
RUN apt update && apt install curl xvfb libgtk2.0-0 libgtk-3-0 libnss3 libxss1 libasound2 -y
RUN curl -s -L "https://atom.io/download/deb?channel=stable" -H 'Accept: application/octet-stream' -o "atom-amd64.deb"
RUN dpkg-deb -x atom-amd64.deb "${HOME}/atom"
ENV ATOM_SCRIPT_NAME="atom"
ENV APM_SCRIPT_NAME="apm"
ENV ATOM_SCRIPT_PATH="${HOME}/atom/usr/bin/${ATOM_SCRIPT_NAME}"
ENV APM_SCRIPT_PATH="${HOME}/atom/usr/bin/${APM_SCRIPT_NAME}"
ENV NPM_SCRIPT_PATH="${HOME}/atom/usr/share/${ATOM_SCRIPT_NAME}/resources/app/apm/node_modules/.bin/npm"
ENV PATH="${PATH}:${HOME}/atom/usr/bin"
RUN ${APM_SCRIPT_PATH} install
RUN ${APM_SCRIPT_PATH} clean
ENV PATH="${HOME}/atom/usr/share/${ATOM_SCRIPT_NAME}/resources/app/apm/bin:${PATH}"
ENV DISPLAY=":99"
RUN if [ -d ./spec ]; then /sbin/start-stop-daemon --start --quiet --pidfile /tmp/custom_xvfb_99.pid --make-pidfile --background --exec /usr/bin/Xvfb -- :99 -ac -screen 0 1280x1024x16 && echo ::set-output name=$(${ATOM_SCRIPT_PATH} --test spec); fi
 
