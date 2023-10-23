# Use an official Ruby runtime as a parent image
FROM --platform=linux/amd64 ruby:3.0.0

# Set environment variables
ENV RAILS_ROOT /var/www/interview
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

# Set working directory
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client libpq-dev
RUN gem install bundler -v '2.2.3'
RUN bundle config set --local without 'development test'
RUN bundle config set --local force_ruby_platform true
RUN bundle install --jobs 20 --retry 5


# Add the rest of the application
COPY . .

# Expose port 3000 to the Docker host, so we can access it from the outside
EXPOSE 3000

# The main command to run when the container starts
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

