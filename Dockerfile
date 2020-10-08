FROM ruby:2.7.2-alpine

RUN apk add --update --no-cache \
	binutils-gold \
      	build-base \
      	curl \
      	file \
      	g++ \
      	gcc \
      	git \
      	less \
      	libstdc++ \
      	libffi-dev \
      	libc-dev \
      	linux-headers \
      	libxml2-dev \
      	libxslt-dev \
      	libgcrypt-dev \
      	make \
      	netcat-openbsd \
      	nodejs \
      	openssl \
      	pkgconfig \
      	postgresql-dev \
      	python3 \
      	tzdata \
      	yarn

RUN mkdir /CountryRoadsTech
WORKDIR /CountryRoadsTech

# Copy over the Ruby and Javascript dependency files as a separate step, so they can be cached if they are unmodified.
COPY Gemfile Gemfile.lock package.json yarn.lock /CountryRoadsTech/

RUN gem install bundler

RUN bundle install

RUN yarn install --check-files

COPY . /CountryRoadsTech/

# Remove a potentially preexisting server.pid file for the Rails server.
RUN rm -f /CountryRoadsTech/tmp/pids/server.pid

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
