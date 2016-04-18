
# ruby2.3
FROM openshift/base-centos7

MAINTAINER Brandon cox <bcox@redhat.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building Ruby2.3” \
      io.k8s.display-name="Ruby=2.3.0” \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,ruby,ruby23”

ENV RUBY_MAJOR 2.3
ENV RUBY_VERSION 2.3.0
ENV RUBYGEMS_VERSION 2.6.3

RUN  wget https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.0.tar.gz \
	&& tar -xvzf ruby-2.3.0.tar.gz \
	&& cd ruby-2.3.0/ \
	&& ./configure --disable-install-doc \
	&& make -j"$(nproc)" \
	&& make install \
	&& cd .. && rm -rf ruby-2.3.0* \
	&& ruby -v


ENV BUNDLER_VERSION 1.11.2

RUN gem install bundler --version "$BUNDLER_VERSION"

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_BIN="$GEM_HOME/bin" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
	&& chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

CMD [ "irb" ]

LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti

# Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./.s2i/bin/ /usr/local/s2i

# Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default CMD for the image
CMD ["usage"]
