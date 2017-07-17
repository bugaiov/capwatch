all: build install

build:
	gem build capwatch.gemspec

install:
	gem install capwatch-*.gem
	rm capwatch-*.gem

clean:
	gem uninstall -x capwatch

test:
	bundle exec rspec
